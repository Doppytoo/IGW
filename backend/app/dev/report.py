from threading import Thread
import asyncio

from sqlmodel import select


from ..data.models import Incident, User
from ..data.db import get_session

from ..bot.main import report_incidents, report_incident_cor, start_bot


def main() -> None:
    # bot_thread = Thread(target=start_bot)

    with get_session() as sess:
        query = select(Incident)
        inc = sess.exec(query).first()

        query = select(User)
        users = sess.exec(query).all()

        for user in users:
            user.telegram_accounts
        inc.service

    asyncio.run(report_incident_cor(inc, users))

    print(inc, users, [user.telegram_accounts for user in users])


if __name__ == "__main__":
    main()
