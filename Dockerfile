FROM node:14-alpine AS build

LABEL maintainer="Francis Masha" MAINTAINER="Francis Masha <francismasha96@gmail.com>"
LABEL application="guacamole-api"

ARG NODE_ENV=$NODE_ENV
ENV APP_HOME=/home/app

RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

RUN apk update && apk add curl
RUN apk add bash

# installing Alpine Dependencies, but the context for the command from `yarn install` is explained above
RUN apk add --no-cache --virtual .build-deps1 g++ gcc libgcc libstdc++ linux-headers make python && \
    apk add --no-cache --virtual .npm-deps cairo-dev jpeg-dev libjpeg-turbo-dev pango pango-dev && \
    apk add bash

RUN apk update
RUN apk add mongodb
RUN apk add mongodb-tools

RUN npm config set unsafe-perm true
RUN npm install yarn@1.22.x
RUN rm -rf package-lock.json

COPY yarn.lock $APP_HOME
COPY package.json $APP_HOME

RUN yarn set version berry
RUN echo 'nodeLinker: node-modules' >> .yarnrc.yml
RUN yarn install

ENV PATH="./node_modules/.bin:$PATH"
ADD . $APP_HOME

CMD ["yarn", "start"]