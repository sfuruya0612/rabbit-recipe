FROM elixir:1.10.2-alpine AS build

ARG ENV
ARG MASTER_USERNAME
ARG MASTER_USERPASSWORD
ARG MYSQL_HOSTNAME

ENV MIX_ENV=${ENV} \
    MIX_HOME=/opt/mix \
    MASTER_USERNAME=${MASTER_USERNAME} \
    MASTER_USERPASSWORD=${MASTER_USERPASSWORD} \
    MYSQL_HOSTNAME=${MYSQL_HOSTNAME}

RUN apk update && apk upgrade

RUN apk add --update --no-cache \
        openssl-dev \
        bash

COPY . /app
WORKDIR /app

RUN mix local.hex --force && \
    mix local.rebar --force

RUN mix do deps.get, compile && \
    MIX_ENV=${ENV} mix distillery.release --env=${ENV} --verbose

# Prepare release image
FROM alpine:edge AS app

ARG APP_NAME
ARG ENV

ENV HOME=/app

RUN apk update && apk upgrade

RUN apk add --update --no-cache \
        openssl \
        bash \
        erlang \
        elixir
        # erlang-sasl>22.1

RUN mkdir /app
WORKDIR /app

COPY --from=build --chown=nobody:nobody /app/_build/${ENV}/rel/${APP_NAME} ./
RUN chown -R nobody: /app
USER nobody

# CMD ["bin/${APP_NAME}", "foreground"]
