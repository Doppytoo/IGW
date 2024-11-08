from sqlmodel import Session, select
from typing import List, Optional

from ..data.models import Record, Incident


def process_incidents(
    records: List[Record], sess: Session, save: bool = False
) -> List[Incident]:
    incidents: List[Incident] = []

    for rec in records:
        query = (
            select(Incident)
            .where(Incident.service_id == rec.service_id)
            .where(Incident.has_ended == False)
        )
        incident = sess.exec(query).one_or_none()

        if (not incident) and (rec.ping_time > rec.service.ping_threshold):
            incident = start_incident(rec)
            if save:
                sess.add(incident)
            incidents.append(incident)
        elif incident and rec.ping_time <= rec.service.ping_threshold:
            incident = end_incident(incident, rec)
            if save:
                sess.add(incident)
            incidents.append(incident)

    if save:
        sess.commit()

    return incidents


def start_incident(rec: Record) -> Incident:
    incident = Incident(
        service=rec.service,
        time_started_at=rec.time_recorded_at,
        ping_time_at_start=rec.ping_time,
        has_ended=False,
    )

    return incident


def end_incident(incident: Incident, rec: Record) -> Incident:
    incident.time_ended_at = rec.time_recorded_at
    incident.ping_time_at_end = rec.ping_time
    incident.has_ended = True

    return incident
