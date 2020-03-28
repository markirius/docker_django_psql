FROM python:3.8.2-alpine3.11
ENV PYTHONUNBUFFERED 1
RUN mkdir /project
WORKDIR /project
COPY requirements.txt /project/
RUN apk add postgresql-dev build-base
RUN pip install -r requirements.txt
COPY . /project/
