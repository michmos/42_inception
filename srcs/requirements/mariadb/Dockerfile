
FROM alpine:3.20

RUN apk update && apk upgrade
RUN apk add mariadb mariadb-client

RUN set -e \
	&& mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql \
	&& mkdir -p /run/mysqld \
	&& chown mysql:mysql /run/mysqld

USER mysql

CMD ["mysqld"]
