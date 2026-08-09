ARG TELEGRAF_VERSION=alpine
FROM telegraf:$TELEGRAF_VERSION AS base
LABEL org.opencontainers.image.authors="drpsychick@drsick.net"
LABEL org.opencontainers.image.description="Telegraf metric collector with automatic TOML config update"
LABEL org.opencontainers.image.source="https://github.com/DrPsychick/docker-telegraf"

# required for inputs.iptables and curl exec
USER root
RUN apk add --no-cache curl iptables bash smartmontools nvme-cli

ARG TARGETARCH
ARG TOML_URL=https://github.com/DrPsychick/toml_update/releases
ARG TOML_VERSION=v0.1.0
RUN curl -sSL -o toml_update_${TOML_VERSION}_Linux_${TARGETARCH}.tar.gz ${TOML_URL}/download/${TOML_VERSION}/toml_update_${TOML_VERSION/v/}_Linux_${TARGETARCH}.tar.gz \
    && tar -xzf toml_update_${TOML_VERSION}_Linux_${TARGETARCH}.tar.gz toml_update \
    && chmod +x ./toml_update \
    && mv ./toml_update /usr/bin

COPY default.env toml_update.sh  /
RUN chmod +x /toml_update.sh

USER telegraf
ENTRYPOINT ["/toml_update.sh"]
CMD ["telegraf"]
