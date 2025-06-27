#! /bin/sh
set -e

if [ ! -d "/var/lib/mysql/mysql" ]; then
	# init data directory - where db is stored
	mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
	# run safe daemon for initialization without networking (clients can't connect)
	mysqld_safe --skip-networking &
	# wait for db to become ready
	sleep 5

	# create db and set user permissions
	mysql -e "CREATE DATABASE IF NOT EXISTS ${MARIADB_DATABASE};"
	mysql -e "CREATE USER '${MARIADB_USER}'@'%' IDENTIFIED BY '${MARIADB_PASSWORD}';"
	mysql -e "GRANT ALL ON ${MARIADB_DATABASE}.* TO '${MARIADB_USER}'@'%';"
	mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}';"
	# shutdown mysqld_safe
	mysqladmin shutdown --password=${MARIADB_ROOT_PASSWORD}
fi

# run actual mysqld as mysql
exec su-exec mysql mysqld
