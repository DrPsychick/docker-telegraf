ARG TELEGRAF_VERSION=alpine
FROM telegraf:$TELEGRAF_VERSION AS base

FROM golang:alpine AS build
COPY conf_update.go /
RUN go build -o /conf_update /conf_update.go

FROM base
COPY --from=build /conf_update /
COPY default.env conf_update.sh  /
RUN chmod +x /conf_update.sh

# required for inputs.iptables
RUN apk add --no-cache iptables

ENTRYPOINT ["/conf_update.sh"]
CMD ["telegraf"]
