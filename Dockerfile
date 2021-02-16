
FROM alpine:20201218

MAINTAINER ops@lifen.fr

RUN apk update \
    && apk upgrade \
    && apk add squid openssl \
    && rm -rf /var/cache/apk/*

RUN mkdir -p /etc/squid/ssl \
    && cd /etc/squid/ssl \
    && openssl genrsa -out squid.key 2048 \
    && openssl req -new -key squid.key -out squid.csr -subj "/C=XX/ST=XX/L=squid/O=squid/CN=squid" \
    && openssl x509 -req -days 3650 -in squid.csr -signkey squid.key -out squid.crt

CMD ["sh", "-c", "(tail -F /var/log/squid/access.log &) && /usr/sbin/squid -f /etc/squid/squid.conf -NYCd 1"]
