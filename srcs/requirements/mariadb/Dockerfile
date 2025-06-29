
FROM alpine:3.20

RUN apk update && apk upgrade
RUN apk add mariadb mariadb-client su-exec

RUN set -e \
	&& mkdir -p var/log/mysql /run/mysqld  \
	&& chown -R mysql:mysql var/log/mysql /run/mysqld

COPY conf/mariadb-server.cnf /etc/my.cnf.d/
COPY entrypoint.sh .

CMD ["/bin/sh", "entrypoint.sh"]
