ARG IMGREPO

## Build Target

FROM ${IMGREPO}golang:latest AS builder

ARG VERSION

RUN wget -q https://github.com/redpanda-data/benthos/archive/refs/tags/v${VERSION}.tar.gz \
 && tar -xf v${VERSION}.tar.gz

WORKDIR /go/benthos-${VERSION}

# TODO: test if `go get -u` works again
RUN awk '/Import/{print;print "\t_ \"github.com/redpanda-data/connect/v4/public/components/pure/extended\"";next}1' cmd/benthos/main.go > cmd/benthos/temp.go && mv cmd/benthos/temp.go cmd/benthos/main.go
RUN go mod tidy \
 && go get ./... \
 && go build -ldflags "-w -s -X github.com/redpanda-data/benthos/v4/internal/cli.Version=${VERSION}" -o ../benthos ./cmd/benthos

## Development Target

FROM ${IMGREPO}ubuntu:24.04 AS develop

RUN apt-get update \
 && apt-get -y --no-install-recommends install tzdata wget ca-certificates \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

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

ARG DB_HOST
ENV DB_HOST=$DB_HOST

ARG DB_PORT
ENV DB_PORT=$DB_PORT

ARG DB_NAME
ENV DB_NAME=$DB_NAME

ENV DL_BASE=""

ENV DB_USER=root

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s CMD wget --no-verbose --tries=1 --spider http://localhost:4195/ready || exit 1

ENTRYPOINT ./benthos -w -c "/yaml/dataasee.yaml" -t "/yaml/templates/*.yaml" -r "/yaml/resources/*.yaml"


## Release Target:

FROM develop AS release

ARG DL_VERSION

LABEL org.opencontainers.image.title="DatAasee: Backend"

LABEL org.opencontainers.image.version="${DL_VERSION}"

LABEL org.opencontainers.image.licenses="MIT"

LABEL org.opencontainers.image.url="https://github.com/ulbmuenster/dataasee"

LABEL org.opencontainers.image.authors="Christian Himpe (University of Münster)"

LABEL org.opencontainers.image.ref.name="dataasee"

USER root

COPY --chown=benthos backend/ /yaml

COPY --chown=benthos api/ /schemas

USER benthos

ENTRYPOINT ./benthos -c "/yaml/dataasee.yaml" -t "/yaml/templates/*.yaml" -r "/yaml/resources/*.yaml"
