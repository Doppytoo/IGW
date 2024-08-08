from fastapi import APIRouter, HTTPException, Depends, Form
from fastapi.security.oauth2 import OAuth2PasswordRequestForm
from sqlmodel import select
from datetime import datetime
from typing import Annotated

from ...data.models import User
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
    username: Annotated[str, Form()],
    password: Annotated[str, Form()],
    is_admin: Annotated[bool | None, Form()],
):
    if is_admin is None:
        is_admin = False

    user = create_user(username, password, is_admin)

    if user is None:
        raise HTTPException(status_code=400, detail="Username already exists")

    return user


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
    username: Annotated[str | None, Form()],
    password: Annotated[str | None, Form()],
    is_admin: Annotated[bool | None, Form()],
):
    with get_session() as sess:
        user = sess.get(User, id)

        if user is None:
            raise HTTPException(status_code=404, detail="User not found")

        if username:
            user.username = username
        if password:
            user.password = hash_password(password)
        if not (is_admin is None):
            user.is_admin = user.is_admin

        sess.add(user)
        sess.commit()

        sess.refresh(user)
        return user
