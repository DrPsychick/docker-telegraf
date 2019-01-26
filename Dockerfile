ARG ALPINE_VERSION=alpine
FROM telegraf:$ALPINE_VERSION

COPY default.env envreplace.sh telegraf.conf.tmpl /
RUN chmod +x /envreplace.sh

ENTRYPOINT ["/envreplace.sh"]
CMD ["telegraf"]
