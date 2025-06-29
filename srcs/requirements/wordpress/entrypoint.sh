#! /bin/sh

set -e

if [ ! -f "/var/www/html/wp-config.php" ]; then
	# create wp-config.php
	wp config create --path=/var/www/html/ --dbname=$MARIADB_DATABASE --dbuser=$MARIADB_USER --dbpass=$MARIADB_PASSWORD --dbhost=$MARIADB_HOST --dbprefix=wp_ --skip-check
	# install wordpress
	wp core install --path=/var/www/html/ --url=$WEBSITE_URL --title=$WEBSITE_TITLE --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL --skip-email
fi

exec su-exec wp_user php-fpm -F
