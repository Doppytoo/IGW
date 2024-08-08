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
    prefix="",
    tags=["auth"],
)


@router.post("/token")
async def login(form_data: Annotated[OAuth2PasswordRequestForm, Depends()]):
    with get_session() as sess:
        query = select(User).where(User.username == form_data.username)
        user = sess.exec(query).one_or_none()

        if not user:
            raise HTTPException(
                status_code=400, detail="Incorrect username or password"
            )

    if not verify_password(form_data.password, user.password):
        raise HTTPException(status_code=400, detail="Incorrect username or password")

    return {"access_token": new_token(user), "token_type": "bearer"}


@router.post("/register")
async def register(
    username: Annotated[str, Form()],
    password: Annotated[str, Form()],
    is_admin: Annotated[bool, Form()],
    admin: Annotated[User, Depends(auth_admin)],
) -> User:
    user = create_user(username, password, is_admin)

    if user is None:
        raise HTTPException(status_code=400, detail="Username already exists")

    return user
