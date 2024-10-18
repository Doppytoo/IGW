import asyncio
import logging
import sys
from os import getenv

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
TOKEN = Settings().get("TG_BOT_TOKEN")

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
        await message.answer("No login code provided")
        return

    if " " in login_code:
        await message.answer(
            "Login code input incorrectly."
            + " Please try again using the /login command."
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
                f"You are already logged in as {hbold(tgacc.user.username)}"
            )
            return

        query = select(TelegramAccount).where(TelegramAccount.code == login_code)
        tgacc = sess.exec(query).one_or_none()

        if tgacc.account_id:
            await message.answer("This login code has already been used.")
        elif tgacc:
            tgacc.account_id = message.from_user.id
            tgacc.full_name = message.from_user.full_name
            tgacc.code = None
            sess.add(tgacc)
            sess.commit()
            await message.answer(f"Logged in as {hbold(tgacc.user.username)}.")
        else:
            await message.answer("Could not log in. Is your code valid?")


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
            await message.answer("Logged out successfully.")
        else:
            await message.answer("You are not currently logged in")


@dp.message(Command("me"))
async def me_handler(message: Message) -> None:
    with get_session() as sess:
        query = select(TelegramAccount).where(
            TelegramAccount.account_id == message.from_user.id
        )
        tgacc = sess.exec(query).one_or_none()

        if tgacc:
            await message.answer(
                f"You are currently logged in as {hbold(tgacc.user.username)}"
            )
        else:
            await message.answer("You are not currently logged in")


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


@dp.message(CommandStart(deep_link=False))
async def command_start_handler(message: Message) -> None:
    await message.answer(
        f"Hello, {hbold(message.from_user.full_name)}!\nUse /login to subscribe to incident reports."
    )


async def main() -> None:
    print(bot)
    await dp.start_polling(bot)


def start_bot() -> None:
    logging.basicConfig(level=logging.INFO, stream=sys.stdout)

    asyncio.run(main())


if __name__ == "__main__":
    start_bot()
