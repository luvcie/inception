FROM alpine:3.21

RUN apk update && apk add --no-cache nginx

COPY conf/static.conf /etc/nginx/http.d/default.conf
COPY site/ /usr/share/nginx/html/

EXPOSE 8081

ENTRYPOINT ["nginx", "-g", "daemon off;"]
