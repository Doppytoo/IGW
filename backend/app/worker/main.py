import time
import threading
import asyncio

from sqlmodel import select

from .ping import get_ping_times, make_records
from .incidents import process_incidents
from ..data.db import get_session
from ..data.models import User

from ..settings import Settings

from ..bot.main import report_incidents


def main_loop():  # * Call this with threading.Thread(target=main_loop, daemon=true) to start the data collection worker.
    next_call = time.time()
    while True:
        ping_times = get_ping_times()
        with get_session() as sess:
            records = make_records(ping_times, sess, save=True)
            incidents = process_incidents(records, sess, save=True)
            for incident in incidents:
                sess.refresh(incident)

            query = select(User)
            users = sess.exec(query).all()

            for inc in incidents:
                print(inc.model_dump_json())
            report_incidents(incidents, users)

        delay = Settings().get("ping_delay")
        next_call += delay * 60
        time.sleep(next_call - time.time())


if __name__ == "__main__":
    main_loop()
