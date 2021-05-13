ARG TELEGRAF_VERSION=alpine
FROM telegraf:$TELEGRAF_VERSION AS base

# required for inputs.iptables and curl exec
RUN apk add --no-cache curl iptables

ARG TARGETARCH
ARG TOML_URL=https://github.com/DrPsychick/toml_update/releases
ARG TOML_VERSION=0.0.7
RUN curl -sSL -o toml_update_${TOML_VERSION}_Linux_${TARGETARCH}.tar.gz ${TOML_URL}/download/v${TOML_VERSION}/toml_update_${TOML_VERSION}_Linux_${TARGETARCH}.tar.gz \
    && tar -xzf toml_update_${TOML_VERSION}_Linux_${TARGETARCH}.tar.gz toml_update \
    && chmod +x ./toml_update \
    && mv ./toml_update /usr/bin

COPY default.env toml_update.sh  /
RUN chmod +x /toml_update.sh

ENTRYPOINT ["/toml_update.sh"]
CMD ["telegraf"]
