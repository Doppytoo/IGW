from datetime import datetime, date, time, timedelta

from fastapi import APIRouter, HTTPException, Depends
from sqlmodel import select
from sqlalchemy.exc import IntegrityError

from ...data.models import Service, Record, Incident, EssentialMetrics
from ...data.db import get_session

from ..auth import auth, auth_admin

router = APIRouter(
    prefix="/services",
    tags=["services"],
    dependencies=[Depends(auth)],
    responses={
        401: {"description": "Unauthorized"},
        403: {"description": "Forbidden"},
        404: {"description": "Not found"},
    },
)


@router.get("/all")
def get_services() -> list[Service]:
    with get_session() as sess:
        query = select(Service)
        services = sess.exec(query).all()
        return services


@router.get("/{service_id}")
def get_service(service_id: int) -> Service:
    with get_session() as sess:
        query = select(Service).where(Service.id == service_id)
        service = sess.exec(query).one_or_none()
        return service


@router.post(
    "/new",
    responses={409: {"description": "Database conflict"}},
    dependencies=[Depends(auth_admin)],
)
def create_service(service: Service) -> Service:
    service.id = None

    with get_session() as sess:
        try:
            sess.add(service)
            sess.commit()

            sess.refresh(service)
            return service
        except IntegrityError as e:
            raise HTTPException(status_code=409, detail=e._message())


@router.patch(
    "/{service_id}",
    responses={409: {"description": "Database conflict"}},
    dependencies=[Depends(auth_admin)],
)
def update_service(service_id: int, service: Service) -> Service:
    with get_session() as sess:
        query = select(Service).where(Service.id == service_id)
        svc = sess.exec(query).one_or_none()
        if not svc:
            raise HTTPException(status_code=404, detail="service not found")

        svc.name = service.name
        svc.url = service.url
        svc.ping_threshold = service.ping_threshold

        try:
            sess.add(svc)
            sess.commit()

            sess.refresh(svc)
            return svc
        except IntegrityError as e:
            raise HTTPException(status_code=409, detail=e._message())


@router.delete("/{service_id}", dependencies=[Depends(auth_admin)])
def delete_service(service_id: int):
    with get_session() as sess:
        query = select(Service).where(Service.id == service_id)
        svc = sess.exec(query).one_or_none()
        if not svc:
            raise HTTPException(status_code=404, detail="service not found")

        query = select(Record).where(Record.service_id == svc.id)
        records = sess.exec(query).all()
        query = select(Incident).where(Incident.service_id == svc.id)
        incidents = sess.exec(query).all()

        for r in records:
            sess.delete(r)
        for i in incidents:
            sess.delete(i)

        sess.delete(svc)
        sess.commit()

    return "ok"


@router.get("/{service_id}/ping")
def ping_service(service_id: int) -> Record:
    with get_session() as sess:
        query = (
            select(Record)
            .where(Record.service_id == service_id)
            .order_by(Record.id.desc())
        )
        record = sess.exec(query).first()

        if not record:
            raise HTTPException(status_code=404, detail="no record found")

        return record


@router.get("/{service_id}/metrics")
def ping_service(service_id: int) -> EssentialMetrics:
    end = datetime.combine(date.today(), time.min)
    start = end - timedelta(days=7)

    with get_session() as sess:

        base_query = (
            select(Incident)
            .where(Incident.service_id == service_id)
            .where(Incident.time_started_at <= end)
        )

        incidents: list[Incident] = []

        incidents.extend(sess.exec(base_query.where(Incident.time_ended_at >= start)))
        incidents.extend(sess.exec(base_query.where(Incident.time_ended_at == None)))

        service = sess.exec(select(Service).where(Service.id == service_id)).one()

        total_time = timedelta()
        max_ping_time = 0
        for incident in incidents:
            if incident.has_ended:
                total_time += incident.time_ended_at - max(
                    incident.time_started_at, start
                )
            else:
                total_time += end - max(incident.time_started_at, start)

            if incident.ping_time_at_start > max_ping_time:
                max_ping_time = incident.ping_time_at_start

        return EssentialMetrics(
            service_id=service_id,
            number_of_incidents=len(incidents),
            total_incident_time=round(total_time.total_seconds()),
            max_ping_time=max_ping_time,
        )
