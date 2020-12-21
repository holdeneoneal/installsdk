FROM ubuntu:20.04

COPY LICENSE README.md /
COPY go1.15.6.linux-amd64.tar.gz /usr/local
RUN cd /usr/local && tar xvf go1.15.6.linux-amd64.tar.gz
ENV PATH=/usr/local/go/bin:$PATH
RUN echo $PATH
RUN go version
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
