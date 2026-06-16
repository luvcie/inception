FROM alpine:3.21

RUN apk update && apk add --no-cache mariadb mariadb-client && \
    mkdir -p /run/mysqld && \
    chown -R mysql:mysql /run/mysqld /var/lib/mysql

COPY conf/my.cnf /etc/my.cnf.d/inception.cnf
COPY tools/init_db.sh /usr/local/bin/init_db.sh

RUN  chmod +x /usr/local/bin/init_db.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/init_db.sh"]
