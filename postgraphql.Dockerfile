FROM node:9-alpine

RUN mkdir /app

WORKDIR /app

RUN npm install -g postgraphql@next

COPY ./.graphql/entrypoint /app/entrypoint

EXPOSE 5000

ENTRYPOINT /app/entrypoint