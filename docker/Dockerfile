# syntax=docker/dockerfile:1

ARG DEBIAN_FRONTEND=noninteractive
ARG DEBIAN_PRIORITY=critical

FROM golang:1.20-bookworm AS builder

# Set up the shell
SHELL [ "/bin/bash", "-ceuxo", "pipefail" ]

# set up some important environment variables
ARG DEBIAN_FRONTEND
ARG DEBIAN_PRIORITY
ENV LC_ALL=C.UTF-8

# Set work dir
WORKDIR /work

# Clone yag repo
ARG YAGPDB_REPO=https://github.com/botlabs-gg/yagpdb.git
ARG YAGPDB_REF=master
RUN git clone --depth=1 "${YAGPDB_REPO}" "yagpdb" \
    && cd yagpdb \
    && git fetch --depth=1 origin "${YAGPDB_REF}" \
    && git checkout -B build FETCH_HEAD

# Move into yag repo
WORKDIR /work/yagpdb

# Acquire deps
RUN go mod download

# Move into yag build dir
WORKDIR /work/yagpdb/cmd/yagpdb

# Build
ARG CGO_ENABLED=0
ARG GOOS=linux
RUN CGO_ENABLED="${CGO_ENABLED}" GOOS="${GOOS}" \
    go build -v -ldflags "-X github.com/botlabs-gg/yagpdb/v2/common.VERSION=$(git describe --tags)"


# Make app container
FROM alpine:3.18 AS app

# Set workdir
WORKDIR /app

# Add dependencies (such as they are)
RUN apk add --no-cache \
    bash \
    ca-certificates \
    curl \
    ffmpeg \
    nano \
    tzdata \
    wget

# Set up the shell for ease of debugging later
SHELL [ "/bin/bash", "-ceuxo", "pipefail" ]

# Copy in the binary
COPY --from=builder /work/yagpdb/cmd/yagpdb/yagpdb /app/yagpdb

# default env values
ENV YAGPDB_PQHOST=db
ENV YAGPDB_PQUSERNAME=postgres
ENV YAGPDB_PQPASSWORD=postgres
ENV YAGPDB_REDIS=redis:6379

# define our volumes
VOLUME [ "/app/soundboard", "/app/cert", "/app/data" ]
# Set our entrypoint
ENTRYPOINT [ "/app/yagpdb" ]
# and command
CMD [ "-all", "-pa", "-exthttps=false", "-https=true" ]
