FROM alpine:3.23

RUN apk update && apk add --no-cache vsftpd shadow

COPY conf/vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY tools/setup_ftp.sh /usr/local/bin/setup_ftp.sh

RUN chmod +x /usr/local/bin/setup_ftp.sh && \
    mkdir -p /var/run/vsftpd/empty /var/www/html

EXPOSE 21 21100-21110

ENTRYPOINT ["/usr/local/bin/setup_ftp.sh"]
