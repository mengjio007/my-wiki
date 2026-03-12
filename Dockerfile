# syntax=docker/dockerfile:1

FROM python:3.12-slim AS build
WORKDIR /src

COPY requirements.txt ./requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY mkdocs.yml ./mkdocs.yml
COPY docs ./docs

RUN mkdocs build --clean

FROM nginx:1.27-alpine
COPY deploy/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /src/site /usr/share/nginx/html

