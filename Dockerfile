FROM node:10-alpine
LABEL maintainer="Scandiweb <info@scandiweb.com>"
LABEL authors="Jurijs Jegorovs jurijs+oss@scandiweb.com"

RUN npm config set unsafe-perm true &&\
    npm install -g docsify-cli@latest

COPY . /docs/

WORKDIR /docs

EXPOSE 3000

CMD [ "docsify", "serve", "." ]