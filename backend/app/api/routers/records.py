from fastapi import APIRouter, HTTPException, Depends
from sqlmodel import select
from datetime import datetime

from ...data.models import Record
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


@router.get("/{record_id}")
def get_record(record_id: int) -> Record:
    with get_session() as sess:
        query = select(Record).where(Record.id == record_id)
        record = sess.exec(query).one_or_none()
        return record


@router.get("/")
def get_records(
    page: int = 0,
    lim: int = 100,
    service_id: int = None,
    period_start: datetime = None,
    period_end: datetime = None,
) -> list[Record]:
    with get_session() as sess:
        query = select(Record).order_by(Record.id.desc())
        if service_id:
            query = query.where(Record.service_id == service_id)
        if period_start:
            query = query.where(Record.time_recorded_at >= period_start)
        if period_end:
            query = query.where(Record.time_recorded_at <= period_end)

        records = sess.exec(query.offset(page * lim).limit(lim)).all()

        if len(records) == 0:
            raise HTTPException(
                status_code=404, detail="records not found or page out of range"
            )

        return records
