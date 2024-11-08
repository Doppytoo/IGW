from fastapi import APIRouter, HTTPException, Depends, Body
from fastapi.security.oauth2 import OAuth2PasswordRequestForm
from sqlmodel import select
from datetime import datetime
from typing import Annotated
import re

from ...data.models import User, TelegramAccount
from ...data.db import get_session

from ..auth import (
    new_token,
    decode_token,
    verify_password,
    hash_password,
    create_user,
    auth,
    auth_admin,
)

router = APIRouter(
    prefix="/users",
    tags=["auth"],
)


@router.get("/me")
async def me(user: User = Depends(auth)):
    return user


@router.post("/new", dependencies=[Depends(auth_admin)])
async def create_new_user(
    username: Annotated[str, Body()],
    password: Annotated[str, Body()],
    is_admin: Annotated[bool | None, Body()] = False,
):
    if is_admin is None:
        is_admin = False

    if (
        re.fullmatch(
            r"(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[?!@$%^&*#-])[A-Za-z0-9?!@$%^&*#-]{8,}",
            password,
        )
        is None
    ):
        raise HTTPException(status_code=400, detail="Password is too weak")
    # 1 capital letter, 1 lowercase letter, 1 number, 1 special character, min 8 chars
    if re.fullmatch(r"\w{3,20}", username) is None:
        raise HTTPException(status_code=400, detail="Username is invalid")

    user = create_user(username, password, is_admin)

    if user is None:
        raise HTTPException(status_code=400, detail="Username already exists")

    return user


@router.get("/all", dependencies=[Depends(auth_admin)])
async def get_all_users():
    with get_session() as sess:
        query = select(User)
        users = sess.exec(query).all()
        return users


@router.get("/{id}", dependencies=[Depends(auth_admin)])
async def get_user(id: int):
    with get_session() as sess:
        user = sess.get(User, id)

        if user is None:
            raise HTTPException(status_code=404, detail="User not found")

        return user


@router.patch("/{id}", dependencies=[Depends(auth_admin)])
async def update_user(
    id: int,
    username: Annotated[str | None, Body()] = None,
    password: Annotated[str | None, Body()] = None,
    is_admin: Annotated[bool | None, Body()] = None,
):
    with get_session() as sess:

        user = sess.get(User, id)

        if user is None:
            raise HTTPException(status_code=404, detail="User not found")

        if username is not None:
            user.username = username
        if password is not None:
            user.hashed_password = hash_password(password)
        if is_admin is not None:
            user.is_admin = is_admin

        sess.add(user)
        sess.commit()

        sess.refresh(user)
        return user


@router.delete("/{id}", dependencies=[Depends(auth_admin)])
async def delete_user(id: int):
    with get_session() as sess:
        user = sess.get(User, id)

        if user is None:
            raise HTTPException(status_code=404, detail="User not found")

        telegram_accounts = sess.exec(
            select(TelegramAccount).where(TelegramAccount.user_id == id)
        ).all()

        for tgacc in telegram_accounts:
            sess.delete(tgacc)

        sess.delete(user)
        sess.commit()

    return "ok"
