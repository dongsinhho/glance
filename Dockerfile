FROM golang:1.23.6-alpine3.21 AS builder

WORKDIR /app
COPY . /app
RUN ls -lR
RUN CGO_ENABLED=0 go build .

FROM alpine:3.21

WORKDIR /app
COPY --from=builder /app/glance .
#COPY --from=builder /app/config/glance.yml /app/config/
RUN ls -lR

HEALTHCHECK --timeout=10s --start-period=60s --interval=60s \
  CMD wget --spider -q http://localhost:8118/api/healthz

EXPOSE 8118/tcp
RUN ls -lR
ENTRYPOINT ["/app/glance", "--config", "/app/config/glance.yml"]
