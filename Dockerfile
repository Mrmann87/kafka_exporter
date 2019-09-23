####################################
## Build Stage
####################################
FROM golang:1.13.0-alpine3.10 as builder

RUN apk --no-cache add bash ca-certificates git build-base

WORKDIR /opt/src

COPY go.mod go.sum ./
RUN go mod download || true

COPY . ./

RUN make

####################################
## Binary Stage
####################################
FROM alpine:3.10 as binary

# Install runtime packages
RUN apk --no-cache add tzdata bash ca-certificates

COPY --from=builder /opt/src/kafka_exporter /bin/kafka_exporter

EXPOSE     9090
ENTRYPOINT [ "/bin/kafka_exporter" ]
