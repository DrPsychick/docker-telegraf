FROM telegraf:alpine

COPY envreplace.sh /
COPY telegraf.conf.tmpl /

RUN chmod +x /envreplace.sh

ENTRYPOINT ["/envreplace.sh"]
CMD ["telegraf"]
