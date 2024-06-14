from sqlmodel import select

from .db import get_session
from .models import Service

svc = Service(
    url="https://google.com",
    name="Google",
    ping_threshold=5.0,
)

with get_session() as session:
    query = select(Service)

    res = session.exec(query)

    print(res.all())

print("Done!")
