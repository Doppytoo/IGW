from fastapi import APIRouter, Depends, Body
from typing import Annotated, Any

from ...settings import settings

from ..auth import auth, auth_admin

# ! Do not use yet

# TODO: Add admin auth dependency
router = APIRouter(
    prefix="/settings",
    tags=["settings"],
    dependencies=[Depends(auth_admin)],
    responses={
        401: {"description": "Unauthorized"},
        403: {"description": "Forbidden"},
        404: {"description": "Not found"},
    },
)


@router.get("/all")
def get_all_settings():
    return settings.data


@router.get("/{key}")
def get_setting(key: str):
    return settings.get(key)


@router.post("/{key}")
def set_setting(key: str, value: Annotated[Any, Body()]):
    try:
        value = int(value)
    except ValueError:
        try:
            value = float(value)
        except ValueError:
            pass

    settings.set(key, value)
