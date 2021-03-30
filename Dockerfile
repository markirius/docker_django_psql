# Multistage - FIRST STEP
# pull official base image
FROM python:3.9-alpine as base

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1

# install psycopg2 dependencies
RUN apk update && \
    apk add --no-cache --virtual .build-deps \
    postgresql-dev python3-dev musl-dev gcc

# install pipenv on base
RUN pip install --upgrade pip

# setting work directory
WORKDIR app

# copy Pipfile and Pipfile.lock
COPY ./requirements.txt .

RUN pip install -r requirements.txt

# Multistage - SECOND STEP
# pulling official image to copy needed files from base
FROM python:3.9-alpine

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

COPY --from=base /usr/local/lib/python3.9/site-packages/ \
/usr/local/lib/python3.9/site-packages
COPY --from=base /usr/local/bin/ /usr/local/bin/
COPY --from=base /usr/bin/ /usr/bin/

# installing libpq to avoid missed libpq.so.5
RUN apk add --no-cache libpq

# set work directory
WORKDIR app

# copy pproject to app folder
COPY . .
