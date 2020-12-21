FROM alpine:3.10

COPY LICENSE README.md /

RUN apt-get update && apt-get install -y \
  curl

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
