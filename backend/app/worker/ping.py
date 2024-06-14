import requests
from datetime import datetime
from sqlmodel import select, Session
from typing import List

from ..data.models import Service, Record

from ..settings import Settings

prometheus_url = Settings().get("PROMETHEUS_URL")


def get_ping_times():
    response = requests.get(
        prometheus_url + "/api/v1/query?query=probe_duration_seconds"
    )
    response.raise_for_status()

    data = response.json()["data"]["result"]

    results = {site["metric"]["instance"]: float(site["value"][1]) for site in data}
    return results


def make_records(
    data: dict[str, float], sess: Session, save: bool = False
) -> List[Record]:
    now = datetime.now()
    records: List[Record] = []

    for site_url, ping_time in data.items():
        query = select(Service).where(Service.url == site_url)
        svc = sess.exec(query).one_or_none()
        # if not svc:
        #     svc = Service(url=site_url, name=site_url, ping_threshold=0.5)
        if svc:
            rec = Record(ping_time=ping_time, service=svc, time_recorded_at=now)
            if save:
                sess.add(rec)
            records.append(rec)
    if save:
        sess.commit()

    return records


# def save_ping_times(data: dict[str, float]):
#     now = datetime.now()

#     with get_session() as sess:
#         for site_url, ping_time in data.items():
#             query = select(Service).where(Service.url == site_url)
#             svc = sess.exec(query).one_or_none()
#             if not svc:
#                 svc = Service(url=site_url, name=site_url, ping_threshold=0.5)
#                 sess.add(svc)

#             rec = Record(ping_time=ping_time, service=svc, time_recorded_at=now)
#             sess.add(rec)

#         sess.commit()
