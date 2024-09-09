ARG IMGREPO

## Build Target

FROM ${IMGREPO}golang:latest AS builder

ARG VERSION

RUN wget https://github.com/redpanda-data/benthos/archive/refs/tags/v${VERSION}.tar.gz && tar -xf v${VERSION}.tar.gz

WORKDIR /go/benthos-${VERSION}

RUN awk '/Import/{print;print "\t_ \"github.com/redpanda-data/connect/v4/public/components/pure/extended\"\n\t_ \"github.com/redpanda-data/connect/v4/public/components/prometheus\"";next}1' cmd/benthos/main.go | tee cmd/benthos/main.go
RUN go get -u ./...
RUN go mod tidy
RUN go build -ldflags "-w -s -X github.com/redpanda-data/benthos/v4/internal/cli.Version=${VERSION}" -o ../benthos ./cmd/benthos

## Development Target

FROM ${IMGREPO}ubuntu:24.04 AS develop

LABEL maintainer="Christian Himpe (University of Münster)"

RUN apt-get update && apt-get upgrade -y && apt-get -y --no-install-recommends install tzdata wget ca-certificates && rm -rf /var/lib/apt/lists/*

RUN useradd -m benthos

RUN mkdir /yaml; chown benthos:benthos /yaml

RUN mkdir /schemas; chown benthos:benthos /schemas

WORKDIR /home/benthos

USER benthos

COPY --from=builder /go/benthos ./

ARG DL_NAME
ENV DL_NAME=$DL_NAME

ARG DL_VERSION
ENV DL_VERSION=$DL_VERSION

ARG DL_PORT
ENV DL_PORT=$DL_PORT

ARG DL_PATH
ENV DL_PATH=$DL_PATH

ARG DB_TYPE
ENV DB_TYPE=$DB_TYPE

ARG DB_HOST
ENV DB_HOST=$DB_HOST

ARG DB_PORT
ENV DB_PORT=$DB_PORT

ARG DB_NAME
ENV DB_NAME=$DB_NAME

ENV DL_BASE=

ENV DB_USER=root

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s CMD wget --no-verbose --tries=1 --spider http://localhost:4195/ready || exit 1

ENTRYPOINT ./benthos -w -c "/yaml/dataasee.yaml" -t "/yaml/templates/*.yaml" -r "/yaml/resources/*.yaml"

## Release Target:

FROM develop AS release

USER root

COPY --chown=benthos backend/ /yaml

COPY --chown=benthos api/ /schemas

USER benthos

ENTRYPOINT ./benthos -c "/yaml/dataasee.yaml" -t "/yaml/templates/*.yaml" -r "/yaml/resources/*.yaml"
