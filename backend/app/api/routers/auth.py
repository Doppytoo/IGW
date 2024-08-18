from fastapi import APIRouter, HTTPException, Depends, Form
from fastapi.security.oauth2 import OAuth2PasswordRequestForm
from sqlmodel import select
from datetime import datetime
from typing import Annotated
import re

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
    prefix="/auth",
    tags=["auth"],
)


@router.post("/login")
async def login(form_data: Annotated[OAuth2PasswordRequestForm, Depends()]):
    with get_session() as sess:
        query = select(User).where(User.username == form_data.username)
        user = sess.exec(query).one_or_none()

        if not user:
            raise HTTPException(
                status_code=400, detail="Incorrect username or password"
            )

    if not verify_password(form_data.password, user.hashed_password):
        raise HTTPException(status_code=400, detail="Incorrect username or password")

    return {"access_token": new_token(user), "token_type": "bearer"}
