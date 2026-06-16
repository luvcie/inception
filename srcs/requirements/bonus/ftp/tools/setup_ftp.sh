#!/bin/sh
set -e

if ! grep -q '^/sbin/nologin$' /etc/shells 2>/dev/null; then
    echo "/sbin/nologin" >> /etc/shells
fi

if ! id "${FTP_USER}" > /dev/null 2>&1; then
    adduser -D -h /var/www/html -s /sbin/nologin -G nobody "${FTP_USER}"
fi

echo "${FTP_USER}:${FTP_PASSWORD}" | chpasswd

chgrp nobody /var/www/html
chmod 775 /var/www/html

sed -i "s/__PASV_ADDRESS__/${FTP_PASV_ADDRESS}/" /etc/vsftpd/vsftpd.conf

exec vsftpd /etc/vsftpd/vsftpd.conf
