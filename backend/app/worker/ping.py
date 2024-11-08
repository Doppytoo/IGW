import os
import requests
from typing import List
from datetime import datetime

from selenium import webdriver
from sqlmodel import select, Session

from ..data.models import Service, Record
from ..settings import settings

prometheus_url = os.environ["PROMETHEUS_URL"]


def get_ping_times(
    sess: Session, save: bool = False, mode: str = "manual"
) -> list[Record]:
    records: List[Record] = []

    if mode == "manual":
        records = _get_ping_times_manual(sess)
    elif mode == "prometheus":
        records = _get_ping_times_prometheus(sess)
    else:
        raise ValueError(f"Unknown ping mode: {mode}")

    if save:
        sess.add_all(records)
        sess.commit()

    return records


def _get_ping_times_manual(sess: Session):
    # TODO: test this
    options = webdriver.FirefoxOptions()
    options.add_argument("--headless")
    driver = webdriver.Firefox(options=options)

    services = sess.exec(select(Service))

    records: List[Record] = []
    for svc in services:
        driver.get(svc.url)
        # Use Navigation Timing  API to calculate the timings that matter the most
        navigation_start = driver.execute_script(
            "return window.performance.timing.navigationStart"
        )
        response_start = driver.execute_script(
            "return window.performance.timing.responseStart"
        )
        dom_complete = driver.execute_script(
            "return window.performance.timing.domComplete"
        )

        # Calculate the performance
        backend_performance = response_start - navigation_start
        frontend_performance = dom_complete - response_start

        records.append(
            Record(
                time_recorded_at=datetime.now(),
                ping_time=backend_performance + frontend_performance,
                service=svc,
            )
        )

        # print("Back End: %s" % backend_performance)
        # print("Front End: %s" % frontend_performance)

    return records


def _get_ping_times_prometheus(sess: Session):
    response = requests.get(
        prometheus_url + "/api/v1/query?query=probe_duration_seconds"
    )
    response.raise_for_status()

    data = response.json()["data"]["result"]

    results = {site["metric"]["instance"]: float(site["value"][1]) for site in data}

    now = datetime.now()
    records: List[Record] = []

    for site_url, ping_time in results.items():
        query = select(Service).where(Service.url == site_url)
        svc = sess.exec(query).one_or_none()
        # if not svc:
        #     svc = Service(url=site_url, name=site_url, ping_threshold=0.5)
        if svc:
            rec = Record(ping_time=ping_time, service=svc, time_recorded_at=now)
            records.append(rec)

    return records


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
