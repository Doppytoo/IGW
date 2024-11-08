from fastapi import APIRouter, HTTPException, Depends, Query
from sqlmodel import select, text
from datetime import datetime
from typing import List, Annotated

from ...data.models import Incident
from ...data.db import get_session

from ..auth import auth

router = APIRouter(
    prefix="/incidents",
    tags=["incidents"],
    dependencies=[Depends(auth)],
    responses={
        401: {"description": "Unauthorized"},
        403: {"description": "Forbidden"},
        404: {"description": "Not found"},
    },
)


@router.get("/all")
def get_all_incidents() -> list[Incident]:
    with get_session() as sess:
        query = select(Incident)
        incidents = sess.exec(query).all()
        return incidents


@router.get("/{incident_id}")
def get_incident(incident_id: int) -> Incident:
    with get_session() as sess:
        query = select(Incident).where(Incident.id == incident_id)
        incident = sess.exec(query).one_or_none()
        return incident


@router.get("/")
def get_incidents(
    skip: int = 0,
    lim: int = 100,
    service_id: Annotated[List[int] | None, Query()] = None,
    period_start: datetime = None,
    period_end: datetime = None,
    has_ended: bool = None,
) -> list[Incident]:

    with get_session() as sess:
        query = select(Incident).order_by(Incident.id.desc())
        if service_id:
            ids_sqlified = "(" + ", ".join(map(str, service_id)) + ")"
            query = query.where(text(rf"service_id IN {ids_sqlified}"))
        if period_start:
            query = query.where(Incident.time_started_at >= period_start)
        if period_end:
            query = query.where(Incident.time_started_at <= period_end)
        if has_ended is not None:
            query = query.where(Incident.has_ended == has_ended)

        incidents = sess.exec(query.offset(skip).limit(lim)).all()

        if len(incidents) == 0:
            raise HTTPException(
                status_code=404, detail="incidents not found or page out of range"
            )

        return incidents
