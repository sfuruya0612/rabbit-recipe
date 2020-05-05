FROM node:13.13.0-alpine3.10

RUN apk add --update --no-cache \
        openssl-dev \
        bash

COPY . /app
WORKDIR /app

RUN yarn add react-scripts typescript
