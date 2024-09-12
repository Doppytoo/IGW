from fastapi import APIRouter, Depends, Body, HTTPException
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
def get_all_settings() -> dict[str, Any]:
    return {
        key: value.value for key, value in settings.data.items() if not value.private
    }


@router.get("/{key}")
def get_setting(key: str):
    try:
        return settings.get(key)
    except KeyError:
        raise HTTPException(status_code=404)


@router.post("/{key}")
def set_setting(key: str, value: Annotated[Any, Body()]):
    settings.set(key, value)
