FROM alpine:3.23

RUN apk update && apk add --no-cache nginx openssl

COPY conf/default.conf /etc/nginx/http.d/default.conf
COPY tools/setup_nginx.sh /usr/local/bin/setup_nginx.sh

RUN chmod +x /usr/local/bin/setup_nginx.sh && \
    mkdir -p /etc/nginx/ssl

EXPOSE 443

ENTRYPOINT ["/usr/local/bin/setup_nginx.sh"]
