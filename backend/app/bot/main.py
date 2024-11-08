import asyncio
import logging
import sys
import os

from aiogram import Bot, Dispatcher, Router, types
from aiogram.enums import ParseMode
from aiogram.filters import CommandStart, Command, CommandObject
from aiogram.types import Message
from aiogram.utils.markdown import hbold
from aiogram.client.default import DefaultBotProperties

from typing import List
from sqlmodel import select

from ..data.models import Incident, User, TelegramAccount
from ..data.db import get_session

from ..settings import Settings

# Bot token can be obtained via https://t.me/BotFather
TOKEN = os.environ["TG_BOT_TOKEN"]

# All handlers should be attached to the Router (or Dispatcher)
dp = Dispatcher()
bot = Bot(
    TOKEN,
    default=DefaultBotProperties(parse_mode="html", link_preview_is_disabled=True),
)


@dp.message(Command("login"))
@dp.message(CommandStart(deep_link=True))
async def login_handler(message: Message, command: CommandObject) -> None:
    if command.args:
        login_code = command.args.strip()
    else:
        await message.answer("Не предоставлен код для входа.")
        return

    if " " in login_code:
        await message.answer(
            "Код введён некорректно." + " Попробуйте снова с помощью команды /login."
            if command.command == "start"
            else ""
        )
        return

    with get_session() as sess:
        query = select(TelegramAccount).where(
            TelegramAccount.account_id == message.from_user.id
        )
        tgacc = sess.exec(query).one_or_none()

        if tgacc:
            await message.answer(
                f"Вы уже вошли в систему как {hbold(tgacc.user.username)}"
            )
            return

        query = select(TelegramAccount).where(TelegramAccount.code == login_code)
        tgacc = sess.exec(query).one_or_none()

        if tgacc.account_id:
            await message.answer("Этот код уже был использован")
        elif tgacc:
            tgacc.account_id = message.from_user.id
            tgacc.full_name = message.from_user.full_name
            tgacc.code = None
            sess.add(tgacc)
            sess.commit()
            await message.answer(f"Выполнен вход как {hbold(tgacc.user.username)}.")
        else:
            await message.answer("Вход не выполнен. Убедитесь, что ввели верный код.")


@dp.message(Command("logout"))
async def logout_handler(message: Message) -> None:
    with get_session() as sess:
        query = select(TelegramAccount).where(
            TelegramAccount.account_id == message.from_user.id
        )
        tgacc = sess.exec(query).one_or_none()

        if tgacc:
            sess.delete(tgacc)
            sess.commit()
            await message.answer("Выход выполнен.")
        else:
            await message.answer("Вы ещё не вошли в систему.")


async def logout_user_cor(tgacc: TelegramAccount):
    await bot.send_message(tgacc.account_id, "Вы вышли из системы.")


def logout_user(tgacc: TelegramAccount):
    asyncio.run(logout_user_cor(tgacc))


@dp.message(Command("me"))
async def me_handler(message: Message) -> None:
    with get_session() as sess:
        query = select(TelegramAccount).where(
            TelegramAccount.account_id == message.from_user.id
        )
        tgacc = sess.exec(query).one_or_none()

        if tgacc:
            await message.answer(
                f"Вы вошли в систему как {hbold(tgacc.user.username)}."
            )
        else:
            await message.answer("Вы ещё не вошли в систему")


async def report_incident_cor(incident: Incident, users: List[User]):
    inc = str(incident)

    for user in users:
        for acct in user.telegram_accounts:
            if acct.account_id:
                await bot.send_message(acct.account_id, inc)


async def report_incidents_cor(incidents: List[Incident], users: List[User]):
    for incident in incidents:
        inc = str(incident)

        for user in users:
            for acct in user.telegram_accounts:
                if acct.account_id:
                    await bot.send_message(acct.account_id, inc)


def report_incidents(incidents: List[Incident], users: List[User]):

    asyncio.run(report_incidents_cor(incidents, users))


def report_incidents_if_open(incidents: List[Incident], users: List[User]):
    with get_session() as sess:
        open_incidents = []
        for inc in incidents:
            sess.refresh(inc)
            if not inc.has_ended:
                open_incidents.append(inc)

    report_incidents(open_incidents, users)


@dp.message(CommandStart(deep_link=False))
async def command_start_handler(message: Message) -> None:
    await message.answer(
        f"Здравствуйте, {hbold(message.from_user.full_name)}!\nИспользуйте /login, чтобы начать получать оповещения об инцидентах."
    )


async def main() -> None:
    print(bot)
    await dp.start_polling(bot)


def start_bot() -> None:
    logging.basicConfig(level=logging.INFO, stream=sys.stdout)

    asyncio.run(main())


if __name__ == "__main__":
    start_bot()
