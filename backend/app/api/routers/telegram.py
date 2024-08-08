from fastapi import APIRouter, HTTPException, Depends, Form
from fastapi.security.oauth2 import OAuth2PasswordRequestForm
from sqlmodel import select
from sqlalchemy.exc import IntegrityError
from datetime import datetime, timezone
from typing import Annotated, List
import random

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
    prefix="/telegram",
    tags=["telegram"],
)


def generate_tg_code(user: User) -> str:
    code = (
        str(random.randint(0, 999999)).ljust(6, "0")
        # + str(int(datetime.timestamp(datetime.now(timezone.utc)) * 10**6))
        + str(user.id)
    )

    return code


@router.get("/my")
async def my_telegram(user: User = Depends(auth)) -> List[TelegramAccount]:
    with get_session() as sess:
        sess.add(user)
        return user.telegram_accounts


@router.get("/link")
async def link_telegram(user: User = Depends(auth)):
    code = generate_tg_code(user)

    with get_session() as sess:
        while True:
            try:
                tgacc = TelegramAccount(
                    user=user,
                    token=code,
                )

                sess.add(tgacc)
                sess.commit()
                break
            except IntegrityError:
                code = generate_tg_code(user)
                continue

    return {"code": code}


if __name__ == "__main__":
    print(generate_tg_code(User(username="Artem", id=1)))
