FROM alpine:3.10

COPY LICENSE README.md /

RUN apk add curl

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
