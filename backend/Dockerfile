FROM elixir:1.10.2-alpine

COPY . /app
WORKDIR /app

ENV MIX_ENV=dev \
    MIX_HOME=/opt/mix

RUN mix local.hex --force \
    mix local.rebar --force \
    mix deps.get
