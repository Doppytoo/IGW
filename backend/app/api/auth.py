from fastapi.security.oauth2 import OAuth2PasswordBearer
from fastapi import Depends, HTTPException

from passlib.context import CryptContext
import jwt

from typing import Annotated
from datetime import datetime, timedelta, timezone

from sqlmodel import select
from sqlalchemy.exc import IntegrityError

from ..data.db import get_session
from ..data.models import User

from ..settings import settings

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="auth/login")
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
jwt_secret = settings.get("JWT_SECRET")
expire_delta = timedelta(minutes=settings.get("JWT_EXPIRES"))


def hash_password(password: str) -> str:
    return pwd_context.hash(password)


def verify_password(password: str, hashed_password: str) -> bool:
    return pwd_context.verify(password, hashed_password)


def new_token(user: User) -> str:
    to_encode = {
        "sub": user.username,
        "exp": datetime.now(timezone.utc) + expire_delta,
    }
    encoded = jwt.encode(to_encode, jwt_secret, algorithm="HS256")

    return encoded


def decode_token(token: str) -> User:
    token_error = HTTPException(
        status_code=401,
        detail="Invalid credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )

    try:
        decoded = jwt.decode(token, jwt_secret, algorithms=["HS256"])
    except jwt.InvalidTokenError:
        raise token_error

    username = decoded.get("sub", None)
    if username is None:
        raise token_error
    with get_session() as sess:
        query = select(User).where(User.username == username)

        user = sess.exec(query).one_or_none()

        if user is None:
            raise token_error

    return user


def create_user(username: str, password: str, is_admin: bool) -> User | None:
    with get_session() as sess:
        try:
            new_user = User(
                username=username,
                hashed_password=hash_password(password),
                is_admin=is_admin,
            )

            sess.add(new_user)
            sess.commit()

            sess.refresh(new_user)
            return new_user
        except IntegrityError as e:
            return None


def auth(token: Annotated[str, Depends(oauth2_scheme)]) -> User:
    user = decode_token(token)

    return user


def auth_admin(token: Annotated[str, Depends(oauth2_scheme)]) -> User:
    user = decode_token(token)

    if not user.is_admin:
        raise HTTPException(status_code=403, detail="Not admin")

    return user


if __name__ == "__main__":
    to_encode = {
        "sub": "admin",
        "exp": datetime.now(timezone.utc) + expire_delta,
    }
    encoded = jwt.encode(to_encode, "STRONGSECRET", algorithm="HS256")

    print(decode_token(encoded))
