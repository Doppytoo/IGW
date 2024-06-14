from fastapi import FastAPI

from .routers import records, incidents, services

app = FastAPI(responses={404: {"description": "Not found"}})

app.include_router(services.router)
app.include_router(records.router)
app.include_router(incidents.router)


@app.get("/ping", tags=["ping"])
async def root():
    return "pong"


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8000)
