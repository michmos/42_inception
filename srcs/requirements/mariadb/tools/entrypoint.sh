#! /bin/sh
set -e

# install db
if [ ! -d "/var/lib/mysql/mysql" ]; then
	mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
fi

# configure database
if [ ! -f "/var/lib/mysql/.mariadb_configured" ]; then
	# run safe daemon for initialization without networking (clients can't connect)
	mariadbd-safe --skip-networking &
	sleep 5

	# get credentials from secrets
	MARIADB_PASSWORD=$(cat "$MARIADB_PASSWORD_FILE")
	MARIADB_ROOT_PASSWORD=$(cat "$MARIADB_ROOT_PASSWORD_FILE")

	# create db and set user permissions
	mariadb -e "CREATE DATABASE IF NOT EXISTS ${MARIADB_DATABASE};"
	mariadb -e "CREATE USER '${MARIADB_USER}'@'%' IDENTIFIED BY '${MARIADB_PASSWORD}';"
	mariadb -e "CREATE USER '${MARIADB_USER}'@'localhost' IDENTIFIED BY '${MARIADB_PASSWORD}';"
	mariadb -e "GRANT ALL ON ${MARIADB_DATABASE}.* TO '${MARIADB_USER}'@'%';"
	mariadb -e "GRANT ALL ON ${MARIADB_DATABASE}.* TO '${MARIADB_USER}'@'localhost';"
	mariadb -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}';"
	mariadb -e "FLUSH PRIVILEGES;" --password="${MARIADB_ROOT_PASSWORD}"
	# shutdown mysqld_safe
	mariadb-admin shutdown --password="${MARIADB_ROOT_PASSWORD}"
	# mark successful installation
	touch /var/lib/mysql/.mariadb_configured
fi

# run actual mysqld as mysql
exec su-exec mysql mariadbd
