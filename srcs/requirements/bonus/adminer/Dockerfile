FROM alpine:3.23

RUN apk update && apk add --no-cache php83 php83-mysqli php83-session curl

RUN mkdir -p /var/www/html && \
    curl -sSL https://www.adminer.org/latest.php -o /var/www/html/index.php

WORKDIR /var/www/html

EXPOSE 8080

ENTRYPOINT ["php83", "-S", "0.0.0.0:8080", "-t", "/var/www/html"]
