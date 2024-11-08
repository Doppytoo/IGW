from fastapi import FastAPI

from .routers import records, incidents, services, settings, auth, users, telegram


app = FastAPI(
    responses={
        404: {"description": "Not found"},
    }
)

app.include_router(services.router)
app.include_router(records.router)
app.include_router(incidents.router)
app.include_router(settings.router)
app.include_router(auth.router)
app.include_router(users.router)
app.include_router(telegram.router)


@app.get("/ping", tags=["ping"])
async def root():
    return "pong"


def start_api():
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8000)


if __name__ == "__main__":
    start_api()
