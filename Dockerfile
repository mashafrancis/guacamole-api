FROM node:14-alpine AS build

ENV APP_HOME=/usr/src/app
WORKDIR $APP_HOME

RUN apk update && apk add curl
RUN apk add bash

# installing Alpine Dependencies, but the context for the command from `yarn install` is explained above
RUN apk add --no-cache --virtual .build-deps1 g++ gcc libgcc libstdc++ linux-headers make python && \
    apk add --no-cache --virtual .npm-deps cairo-dev jpeg-dev libjpeg-turbo-dev pango pango-dev && \
    apk add bash

RUN echo 'http://dl-cdn.alpinelinux.org/alpine/v3.9/main' >> /etc/apk/repositories
RUN echo 'http://dl-cdn.alpinelinux.org/alpine/v3.9/community' >> /etc/apk/repositories

RUN apk update
RUN apk add mongodb
RUN apk add mongodb-tools

RUN npm config set unsafe-perm true
RUN npm install -g yarn@1.22.5 --force
RUN rm -rf package-lock.json

COPY package.json ./
COPY yarn.lock ./

RUN rm -rf yarn.lock
RUN yarn set version berry
RUN yarn config set nodeLinker "node-modules"
RUN yarn plugin import typescript
RUN yarn plugin import exec
RUN touch yarn.lock
RUN yarn install

COPY . .
RUN yarn install
RUN yarn build

EXPOSE 5000

## The cleaner
FROM node:14-alpine as cleaner
WORKDIR /usr/src/app
COPY --from=builder /usr/src/app .
RUN npm prune --production

## Output image
FROM node:14-alpine

LABEL maintainer="Francis Masha" MAINTAINER="Francis Masha <francismasha96@gmail.com>"
LABEL application="guacamole-api"
ENV APP_HOME=/usr/src/app

RUN apk add --update curl
HEALTHCHECK CMD curl -f http://localhost/healthcheck || exit 1
WORKDIR $APP_HOME

COPY --from=cleaner /usr/src/app .

EXPOSE 80
EXPOSE 5000

CMD ["yarn", "prod"]
