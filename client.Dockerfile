FROM node:9-alpine

RUN mkdir /app

VOLUME /app/node_modules

WORKDIR /app

COPY . /app

RUN npm install

EXPOSE 5000

ENTRYPOINT /app/entrypoint