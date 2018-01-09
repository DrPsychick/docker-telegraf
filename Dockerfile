FROM telegraf:alpine

COPY default.env /
COPY envreplace.sh /
COPY telegraf.conf.tmpl /

RUN chmod +x /envreplace.sh

ENTRYPOINT ["/envreplace.sh"]
CMD ["telegraf"]
