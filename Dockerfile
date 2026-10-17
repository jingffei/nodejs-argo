FROM node:alpine3.22

WORKDIR /tmp

COPY index.js index.html package.json ./

RUN apk update && apk upgrade && \
    apk add --no-cache openssl curl gcompat iproute2 coreutils bash && \
    apk add --no-cache bash &&\
    chmod +x index.js && \
    npm install

EXPOSE 3000/tcp

CMD ["node", "index.js"]
