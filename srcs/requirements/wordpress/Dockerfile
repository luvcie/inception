FROM alpine:3.23

RUN apk update && apk add --no-cache \
    php83 \
    php83-fpm \
    php83-mysqli \
    php83-curl \
    php83-dom \
    php83-exif \
    php83-fileinfo \
    php83-mbstring \
    php83-opcache \
    php83-xml \
    php83-zip \
    php83-gd \
    php83-redis \
    php83-phar \
    php83-iconv \
    php83-session \
    php83-simplexml \
    php83-xmlreader \
    php83-xmlwriter \
    php83-tokenizer \
    php83-ctype \
    curl \
    mysql-client

RUN curl -sS https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -o /usr/local/bin/wp && \
    chmod +x /usr/local/bin/wp

RUN echo "memory_limit = 512M" > /etc/php83/conf.d/zz-wp-cli.ini

COPY conf/www.conf /etc/php83/php-fpm.d/www.conf
COPY tools/setup_wp.sh /usr/local/bin/setup_wp.sh

RUN chmod +x /usr/local/bin/setup_wp.sh && \
    mkdir -p /var/www/html && \
    chown -R nobody:nobody /var/www/html

WORKDIR /var/www/html

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/setup_wp.sh"]
