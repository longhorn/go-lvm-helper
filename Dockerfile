# syntax=docker/dockerfile:1.22.0@sha256:4a43a54dd1fedceb30ba47e76cfcf2b47304f4161c0caeac2db1c61804ea3c91
FROM golangci/golangci-lint:v2.12.2@sha256:5cceeef04e53efe1470638d4b4b4f5ceefd574955ab3941b2d9a68a8c9ad5240 AS golangci-lint

FROM registry.suse.com/bci/bci-base:16.0@sha256:38bb07164a0b64c429a285e877277d618fa7531eccd0d31d34375b9ea247c843 AS base

ARG TARGETARCH

ENV GOLANG_VERSION=1.26.1

ENV ARCH=${TARGETARCH}
ENV GOFLAGS=-mod=vendor

RUN zypper -n install curl tar gzip git awk lvm2 && \
    rm -rf /var/cache/zypp/*

# Install Go
ENV GOPATH=/go PATH=/go/bin:/usr/local/go/bin:${PATH} SHELL=/bin/bash
RUN curl -sSL "https://golang.org/dl/go${GOLANG_VERSION}.linux-${ARCH}.tar.gz" -o /tmp/go.tar.gz \
    && tar -C /usr/local -xzf /tmp/go.tar.gz \
    && rm /tmp/go.tar.gz

# Copy golangci-lint binary from official image
COPY --from=golangci-lint /usr/bin/golangci-lint /usr/local/bin/golangci-lint

WORKDIR /go/src/github.com/longhorn/go-lvm-helper
COPY . .

FROM base AS validate
RUN ./scripts/ci && touch /validate.done

FROM scratch AS ci-artifacts
COPY --from=validate /validate.done /validate.done
COPY --from=validate /go/src/github.com/longhorn/go-lvm-helper/coverage.out /coverage.out
