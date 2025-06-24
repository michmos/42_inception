
FROM alpine:3.20

RUN apk update && apk upgrade
RUN apk add mariadb mariadb-client

RUN set -e \
	&& mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql \
	&& mkdir -p var/log/mysql /run/mysqld  \
	&& chown mysql:mysql var/log/mysql /run/mysqld

COPY conf/mariadb-server.cnf /etc/my.cnf.d/

USER mysql

CMD ["mysqld"]
