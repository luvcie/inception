FROM alpine:3.23

RUN apk update && apk add --no-cache curl tar ca-certificates

RUN curl -sSL https://github.com/portainer/portainer/releases/download/2.39.3/portainer-2.39.3-linux-amd64.tar.gz \
    -o /tmp/portainer.tar.gz && \
    tar -xzf /tmp/portainer.tar.gz -C /opt && \
    rm /tmp/portainer.tar.gz

EXPOSE 9443

ENTRYPOINT ["/opt/portainer/portainer"]
