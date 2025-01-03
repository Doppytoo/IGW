from fastapi import APIRouter, HTTPException, Depends
from sqlmodel import select
from datetime import datetime

from ...data.models import Record, Service
from ...data.db import get_session

from ..auth import auth

router = APIRouter(
    prefix="/records",
    tags=["records"],
    dependencies=[Depends(auth)],
    responses={
        401: {"description": "Unauthorized"},
        403: {"description": "Forbidden"},
        404: {"description": "Not found"},
    },
)


@router.get("/all")
def get_all_records() -> list[Record]:
    with get_session() as sess:
        query = select(Record).order_by(Record.id.desc())
        records = sess.exec(query).all()
        return records


@router.get("/latest")
def get_latest_records() -> list[Record]:
    with get_session() as sess:
        times = set(sess.exec(select(Record.time_recorded_at)).all())

        if len(times) == 0:
            return []

        latest_time = max(times)

        query = (
            select(Record)
            .where(Record.time_recorded_at == latest_time)
            .order_by(Record.service_id)
        )
        records = sess.exec(query).all()

        return records


@router.get("/{record_id}")
def get_record(record_id: int) -> Record:
    with get_session() as sess:
        query = select(Record).where(Record.id == record_id)
        record = sess.exec(query).one_or_none()
        return record


@router.get("/")
def get_records(
    skip: int = 0,
    lim: int = 100,
    # ascending: bool = False,
    service_id: int | None = None,
    period_start: datetime | None = None,
    period_end: datetime | None = None,
) -> list[Record]:
    with get_session() as sess:
        query = select(Record).order_by(Record.id.desc())
        if service_id is not None:
            query = query.where(Record.service_id == service_id)
        if period_start is not None:
            query = query.where(Record.time_recorded_at >= period_start)
        if period_end is not None:
            query = query.where(Record.time_recorded_at <= period_end)

        records = sess.exec(query.offset(skip).limit(lim)).all()

        if len(records) == 0:
            raise HTTPException(
                status_code=404, detail="records not found or page out of range"
            )

        return records
