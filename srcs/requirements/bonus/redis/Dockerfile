FROM alpine:3.21

RUN apk update && apk add --no-cache redis

COPY conf/redis.conf /etc/redis.conf

RUN chown redis:redis /etc/redis.conf

EXPOSE 6379

ENTRYPOINT ["redis-server", "/etc/redis.conf"]
