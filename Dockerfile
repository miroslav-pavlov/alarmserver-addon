FROM golang:1.24.3-alpine3.21 AS build_base
RUN apk add ca-certificates

WORKDIR /tmp/app

COPY . .
RUN go get -d ./... && CGO_ENABLED=0 go build -ldflags="-w -s" -o ./out/alarmserver

FROM scratch
COPY --from=build_base /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build_base /tmp/app/out/alarmserver /alarmserver

EXPOSE 15002

ENTRYPOINT ["/alarmserver"]
