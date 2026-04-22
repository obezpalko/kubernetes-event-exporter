FROM golang:1.22 AS builder

ARG VERSION=dev
ARG TARGETOS=linux
ARG TARGETARCH=amd64
ENV PKG=github.com/resmoio/kubernetes-event-exporter/pkg

ADD . /app
WORKDIR /app
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build \
    -ldflags="-s -w -X ${PKG}/version.Version=${VERSION}" \
    -a -o /main .

FROM gcr.io/distroless/static:nonroot
COPY --from=builder --chown=nonroot:nonroot /main /kubernetes-event-exporter
USER 65532
ENTRYPOINT ["/kubernetes-event-exporter"]
