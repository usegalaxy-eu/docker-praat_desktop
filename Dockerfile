FROM jlesage/baseimage-gui:ubuntu-24.04-v4

ARG PRAAT_VERSION=7.0.02
ARG PRAAT_VERSION_COMPACT=7002

LABEL org.opencontainers.image.title="Praat for Galaxy" \
      org.opencontainers.image.description="Praat desktop for Galaxy Interactive Tools" \
      org.opencontainers.image.version="${PRAAT_VERSION}"

# The base image's helper initializes user/group files needed by package scripts
# (including fontconfig's root:staff ownership), then cleans up after apt.
RUN add-pkg \
        ca-certificates curl dbus-x11 \
        libgtk-3-0t64 libasound2t64 libpulse0 libjack-jackd2-0 \
        fonts-sil-charis fonts-sil-doulos wget

RUN set -eux; \
    wget -q \
        "https://github.com/praat/praat/releases/download/v${PRAAT_VERSION}/praat${PRAAT_VERSION_COMPACT}_linux-x64v3.tar.gz" \
        -O /tmp/praat.tar.gz; \
    tar -xzf /tmp/praat.tar.gz -C /usr/local/bin; \
    chmod 755 /usr/local/bin/praat; \
    rm /tmp/praat.tar.gz; \
    praat --version

# Use Praat's upstream application icon.
RUN install_app_icon.sh \
    "https://raw.githubusercontent.com/praat/praat.github.io/v${PRAAT_VERSION}/main/praat-128.png"

COPY startapp.sh /startapp.sh
RUN chmod 755 /startapp.sh
COPY rc.xml.template /opt/base/etc/openbox/rc.xml.template

ENV APP_NAME="Praat" \
    KEEP_APP_RUNNING=0 \
    TAKE_CONFIG_OWNERSHIP=1 \
    WEB_AUDIO=1

WORKDIR /config
