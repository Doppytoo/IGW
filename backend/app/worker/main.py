import time
import threading
import os

from sqlmodel import select

from .ping import get_ping_times, make_records
from .incidents import process_incidents
from ..data.db import get_session
from ..data.models import User

from ..settings import settings

from ..bot.main import report_incidents, report_incidents_if_open


def main_loop():  # * Call this with threading.Thread(target=main_loop, daemon=true) to start the data collection worker.
    next_call = time.time()
    while True:
        settings.refresh()
        with get_session() as sess:
            records = get_ping_times(sess, save=True, mode=os.environ["PING_MODE"])

            incidents = process_incidents(records, sess, save=True)
            for incident in incidents:
                sess.refresh(incident)

            query = select(User)
            users = sess.exec(query).all()

            for inc in incidents:
                print(inc.model_dump_json())
            report_incidents(incidents, users)

            if settings.get("repeat_incident_notifications"):
                threading.Timer(
                    settings.get("incident_notification_repeat_delay") * 60,
                    report_incidents_if_open,
                    args=(incidents, users),
                ).start()

        delay = settings.get("ping_interval")
        next_call += delay * 60
        time.sleep(next_call - time.time())


if __name__ == "__main__":
    main_loop()
