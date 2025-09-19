FROM scratch AS ctx
COPY build_files /

# Universal Blue Images: https://github.com/orgs/ublue-os/packages
FROM ghcr.io/ublue-os/kinoite-main:latest

ARG IMAGE="orcus"
ARG BASE_IMAGE="kinoite"
ARG VERSION=""
ARG SHA_HEAD_SHORT=""

COPY system_files /

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh && \
    ostree container commit

# verify final image and contents are correct
RUN bootc container lint
