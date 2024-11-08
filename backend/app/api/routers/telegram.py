from datetime import datetime, timezone
from typing import Annotated, List
import random

from fastapi import APIRouter, HTTPException, Depends, Form
from fastapi.security.oauth2 import OAuth2PasswordRequestForm
from sqlmodel import select
from sqlalchemy.exc import IntegrityError

from ...data.models import User, TelegramAccount
from ...data.db import get_session
from ...bot.main import logout_user_cor

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
        return [
            tgacc for tgacc in user.telegram_accounts if tgacc.account_id is not None
        ]


@router.get("/link")
async def link_telegram(user: User = Depends(auth)):
    code = generate_tg_code(user)

    with get_session() as sess:
        query = select(TelegramAccount).where(TelegramAccount.user == user)
        tgacc = sess.exec(query).one_or_none()
        if tgacc is not None and tgacc.account_id is None:
            sess.delete(tgacc)
            sess.commit()
        elif tgacc is not None:
            raise HTTPException(
                status_code=400, detail="Telegram account already linked"
            )

        while True:
            try:
                tgacc = TelegramAccount(user=user, code=code)

                sess.add(tgacc)
                sess.commit()
                break
            except IntegrityError:
                code = generate_tg_code(user)
                continue

    return {"code": code}


@router.delete("/unlink")
async def unlink_telegram(user: User = Depends(auth)):
    with get_session() as sess:
        query = select(TelegramAccount).where(TelegramAccount.user == user)
        tgacc = sess.exec(query).first()
        if tgacc is None:
            raise HTTPException(status_code=404, detail="Telegram account not found")

        await logout_user_cor(tgacc)

        sess.delete(tgacc)
        sess.commit()


if __name__ == "__main__":
    print(generate_tg_code(User(username="Artem", id=1)))
