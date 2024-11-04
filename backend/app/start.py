import multiprocessing as mp
import time
import os

import uvicorn
from sqlmodel import select

from .data.db import create_db_and_tables, get_session
from .data.models import User
from .worker.main import main_loop
from .api.main import start_api
from .api.auth import hash_password
from .bot.main import start_bot
from .settings import settings


def main():
    for k, v in settings.data.items():
        if v is None:
            raise RuntimeError(
                "Settings file is invalid. Check that all values are not null"
            )

    create_db_and_tables()

    with get_session() as sess:
        users = sess.exec(select(User)).all()
        if users is None or len(users) == 0:
            admin = User(
                username=os.environ["DEFAULT_USERNAME"],
                hashed_password=hash_password(os.environ["DEFAULT_PASSWORD"]),
                is_admin=True,
            )

            sess.add(admin)
            sess.commit()

    worker_proc = mp.Process(target=main_loop, name="Worker")
    api_proc = mp.Process(
        target=start_api,
        name="API",
    )
    bot_proc = mp.Process(target=start_bot, name="Bot")

    # worker_proc.start()
    api_proc.start()
    bot_proc.start()

    try:
        while 1:
            time.sleep(0.1)
    except KeyboardInterrupt:
        worker_proc.terminate()
        api_proc.terminate()
        bot_proc.terminate()


if __name__ == "__main__":
    main()
