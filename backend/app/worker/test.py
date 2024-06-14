from sqlmodel import select
import requests

from ..data.db import get_session
from ..data.models import Service


def main():
    with get_session() as sess:
        services = list(sess.exec(select(Service)).all())

    print(services)

    codes = {}
    for service in services[:10]:
        resp = requests.get(service.url + "/probe")
        codes[service.url] = resp.status_code

    print()
    print(codes)


if __name__ == "__main__":
    main()
