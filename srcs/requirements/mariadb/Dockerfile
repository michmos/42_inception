
FROM alpine:3.21

RUN apk add --no-cache mariadb mariadb-client su-exec

RUN set -e \
	&& mkdir -p var/log/mysql /run/mysqld  \
	&& chown -R mysql:mysql var/log/mysql /run/mysqld

WORKDIR /app

COPY conf/mariadb-server.cnf /etc/my.cnf.d/

COPY tools/entrypoint.sh .

ENTRYPOINT ["/bin/sh", "/app/entrypoint.sh"]
