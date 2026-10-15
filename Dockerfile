FROM jlesage/baseimage-gui:ubuntu-26.04-v4.14

# Prevent deletion of Galaxy-managed temporary files.
RUN rm -f /etc/cont-init.d/08-clear-tmp-dir.sh

SHELL ["/bin/bash", "-c"]

# The base image's helper initializes user/group files needed by package scripts
# (including fontconfig's root:staff ownership), then cleans up after apt.
RUN add-pkg \
        ca-certificates curl dbus-x11 \
        fonts-sil-charis fonts-sil-doulos \
        libgtk-3-0t64 libasound2t64 libpulse0 libjack-jackd2-0

ARG PRAAT_VERSION=7.0.02

LABEL org.opencontainers.image.authors="Ivo Christopher Leist <ivo.leist@gmail.com>" 

RUN set -eux; \
    PRAAT_VERSION_COMPACT="${PRAAT_VERSION//./}"; \
    curl -fsSL --retry 3 \
        "https://github.com/praat/praat/releases/download/v${PRAAT_VERSION}/praat${PRAAT_VERSION_COMPACT}_linux-x64v3.tar.gz" \
        -o /tmp/praat.tar.gz; \
    tar -xzf /tmp/praat.tar.gz -C /usr/local/bin; \
    chmod 755 /usr/local/bin/praat; \
    rm /tmp/praat.tar.gz; \
    praat --version

# Use Praat's upstream application icon.
RUN install_app_icon.sh \
    "https://raw.githubusercontent.com/praat/praat.github.io/v${PRAAT_VERSION}/main/praat-128.png"

COPY --chmod=755 startapp.sh /startapp.sh

ENV APP_NAME="Praat" \
    WEB_AUDIO=1

# Enable audio by default in the web-based VNC client.
RUN sed -i \
    "s/WebUtil.readSetting('audio_enabled', '0')/WebUtil.readSetting('audio_enabled', '1')/" \
    /opt/noVNC/app/ui.js

COPY rc.xml.template /opt/base/etc/openbox/rc.xml.template

WORKDIR /config
