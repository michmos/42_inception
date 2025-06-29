#! /bin/sh

set -e

if [ ! -f "/var/www/html/wp-config.php" ]; then
	# create wp-config.php
	wp config create --path=/var/www/html/ --dbname=$MARIADB_DATABASE --dbuser=$MARIADB_USER --dbpass=$MARIADB_PASSWORD --dbhost="$MARIADB_HOST:$MARIADB_PORT" --dbprefix=wp_ --skip-check
	# set filesystem method to allow php writing to file system (e.g. for plugins and themes)
	wp config set FS_METHOD direct --config-file=/var/www/html/wp-config.php
	# install wordpress
	until mysql $MARIADB_DATABASE -h $MARIADB_HOST -u $MARIADB_USER --password=$MARIADB_PASSWORD 2> /dev/null; do
		echo "Waiting for mariadb to be available..."
		sleep 2
	done
	wp core install --path=/var/www/html/ --url=$WEBSITE_URL --title=$WEBSITE_TITLE --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL --skip-email
fi

exec su-exec wp_user php-fpm -F
