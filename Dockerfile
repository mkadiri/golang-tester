FROM golang:1.13.9-alpine3.11

ENV \
    GOPATH="/go" \
    CGO_ENABLED=0

RUN mkdir -p /go-bin

RUN \
    apk --update add \
	    mysql-client \
        curl && \
	curl -L https://github.com/golang-migrate/migrate/releases/download/v3.4.0/migrate.linux-amd64.tar.gz | tar xvz && \
	mv migrate.linux-amd64 /migrate

EXPOSE 8000

COPY startup.sh /startup.sh
RUN chmod +x /startup.sh

WORKDIR /go/src/

CMD ["/startup.sh"]