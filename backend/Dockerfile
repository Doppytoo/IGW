

FROM python:3.12

ADD ./app /service/app

WORKDIR /service
RUN pip install -r ./app/requirements.txt

EXPOSE 8000

ENTRYPOINT [ "python", "-m", "app.start" ]