FROM jlesage/baseimage-gui:ubuntu-26.04-v4.14@sha256:ba4b93918b17f74c21ab2a0ae7c44c0821efef4f7fd17455b754cf812add84af

# Prevent deletion of Galaxy-managed temporary files.
RUN rm -f /etc/cont-init.d/08-clear-tmp-dir.sh

SHELL ["/bin/bash", "-c"]

# The base image's helper initializes user/group files needed by package scripts
# (including fontconfig's root:staff ownership), then cleans up after apt.
RUN add-pkg \
        ca-certificates dbus-x11 \
        fonts-sil-charis fonts-sil-doulos \
        libgtk-3-0t64 libasound2t64 libpulse0 libjack-jackd2-0

ARG PRAAT_VERSION=7.0.02
ARG PRAAT_SHA256=371c309e18198026af8b82fe2a0e92827645e43682e2fa54d849d2c19de79b1e

LABEL org.opencontainers.image.title="Praat desktop" \
      org.opencontainers.image.description="Praat ${PRAAT_VERSION} in a browser-accessible desktop (noVNC) for Galaxy Interactive Tools" \
      org.opencontainers.image.source="https://github.com/usegalaxy-eu/docker-praat_desktop" \
      org.opencontainers.image.version="${PRAAT_VERSION}" \
      org.opencontainers.image.licenses="MIT AND GPL-3.0-or-later" \
      org.opencontainers.image.authors="Ivo Christopher Leist <ivo.leist@gmail.com>"

RUN set -eux; \
    add-pkg --virtual praat-build-deps curl; \
    PRAAT_VERSION_COMPACT="${PRAAT_VERSION//./}"; \
    curl -fsSL --retry 3 \
        "https://github.com/praat/praat.github.io/releases/download/v${PRAAT_VERSION}/praat${PRAAT_VERSION_COMPACT}_linux-x64v3.tar.gz" \
        -o /tmp/praat.tar.gz; \
    printf '%s  %s\n' "${PRAAT_SHA256}" /tmp/praat.tar.gz | sha256sum -c -; \
    tar -xzf /tmp/praat.tar.gz -C /usr/local/bin; \
    chmod 755 /usr/local/bin/praat; \
    rm /tmp/praat.tar.gz; \
    praat --version; \
    install_app_icon.sh \
        "https://raw.githubusercontent.com/praat/praat.github.io/v${PRAAT_VERSION}/main/praat-128.png"; \
    del-pkg praat-build-deps

COPY --chmod=755 startapp.sh /startapp.sh

ENV APP_NAME="Praat" \
    WEB_AUDIO=1

# Enable audio by default in the web-based VNC client.
RUN sed -i \
    "s/WebUtil.readSetting('audio_enabled', '0')/WebUtil.readSetting('audio_enabled', '1')/" \
    /opt/noVNC/app/ui.js

COPY rc.xml.template /opt/base/etc/openbox/rc.xml.template

WORKDIR /config
