from sqlmodel import SQLModel, Field, Relationship
from typing import Optional, List
from datetime import datetime


class Service(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    url: str = Field(unique=True)
    name: str = Field(unique=True)
    ping_threshold: float

    records: List["Record"] = Relationship(back_populates="service")
    incidents: List["Incident"] = Relationship(back_populates="service")


class Record(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    time_recorded_at: datetime
    ping_time: float

    service_id: Optional[int] = Field(default=None, foreign_key="service.id")
    service: Optional[Service] = Relationship(back_populates="records")


class Incident(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    time_started_at: datetime
    time_ended_at: Optional[datetime] = Field(default=None)
    has_ended: bool = Field(default=False)
    ping_time_at_start: float
    ping_time_at_end: Optional[float] = Field(default=None)

    service_id: Optional[int] = Field(default=None, foreign_key="service.id")
    service: Optional[Service] = Relationship(back_populates="incidents")

    def __str__(self) -> str:
        inc = f"""ПРОБЛЕМА, Инцидент №{self.id}
{self.service.name}: снижение скорости загрузки страницы до {self.ping_time_at_start:.3f}с/{self.service.ping_threshold:.3f}с ({(self.ping_time_at_start / self.service.ping_threshold) - 1:.1%})
"""
        return inc

    # def start(self, rec: Record):
    #     self.service = rec.service
    #     self.time_started_at = rec.time_recorded_at
    #     self.ping_time_at_start = rec.ping_time
    #     self.has_ended = False

    #     return self

    # def end(self, rec: Record):
    #     self.time_ended_at = rec.time_recorded_at
    #     self.ping_time_at_end = rec.ping_time
    #     self.has_ended = True

    #     return self


class User(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    username: str = Field(unique=True)
    hashed_password: str = Field(exclude=True)
    is_admin: bool = Field(default=False)

    telegram_accounts: List["TelegramAccount"] = Relationship(back_populates="user")


class TelegramAccount(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True, exclude=True)
    code: Optional[str] = Field(unique=True, exclude=True, nullable=True)
    account_id: Optional[int] = Field(unique=True, nullable=True)
    full_name: Optional[str] = Field(nullable=True)

    user_id: Optional[int] = Field(default=None, foreign_key="user.id")
    user: Optional[User] = Relationship(back_populates="telegram_accounts")
