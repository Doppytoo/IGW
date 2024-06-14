from fastapi import APIRouter, HTTPException
from sqlmodel import select
from sqlalchemy.exc import IntegrityError

from ...data.models import Service, Record
from ...data.db import get_session

router = APIRouter(
    prefix="/services",
    tags=["services"],
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


@router.post("/new", responses={409: {"description": "Database conflict"}})
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


@router.patch("/{service_id}", responses={409: {"description": "Database conflict"}})
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
