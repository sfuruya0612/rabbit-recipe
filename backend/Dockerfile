FROM elixir:1.10.2-alpine AS build

ARG APP_NAME
ARG ENV

ENV MIX_ENV=${ENV} \
    MIX_HOME=/opt/mix

RUN apk add --update --no-cache \
        openssl-dev \
        # erlang \
        # erlang-sasl \
        bash

COPY . /app
WORKDIR /app

RUN mix local.hex --force && \
    mix local.rebar --force

RUN mix do deps.get, compile && \
    MIX_ENV=${ENV} mix distillery.release --env=${ENV} --verbose

# Prepare release image
FROM alpine:latest AS app

ARG APP_NAME
ARG ENV

ENV HOME=/app

RUN apk add --update --no-cache \
        openssl \
        erlang \
        erlang-sasl \
        bash

RUN mkdir /app
WORKDIR /app

COPY --from=build --chown=nobody:nobody /app/_build/${ENV}/rel/${APP_NAME} ./
RUN chown -R nobody: /app
USER nobody

CMD ["bin/${APP_NAME}", "foreground"]
