ARG TELEGRAF_VERSION=alpine
FROM telegraf:$TELEGRAF_VERSION AS base

FROM golang:alpine AS build
COPY toml_update.go /root
RUN cd /root \
    && go mod init github.com/drpsychick/docker-telegraf \
    && go mod vendor \
    && go build -o /root/toml_update /root/toml_update.go

FROM base
COPY --from=build /root/toml_update /
COPY default.env toml_update.sh  /
RUN chmod +x /toml_update.sh

# required for inputs.iptables and curl exec
RUN apk add --no-cache curl iptables

ENTRYPOINT ["/toml_update.sh"]
CMD ["telegraf"]
