import os
from pathlib import Path

from sqlmodel import SQLModel, create_engine, Session

from .models import *

# BASE_DIR = str(Path(__file__).resolve().parent.parent).replace("\\", "/")[3:]
# DB_URL = f"sqlite:////{BASE_DIR}/db.sqlite3"
DB_URL = os.environ["DATABASE_URL"]

engine = create_engine(DB_URL, echo=False)


def create_db_and_tables():
    SQLModel.metadata.create_all(engine)


def get_session():
    return Session(engine)


if __name__ == "__main__":
    create_db_and_tables()
