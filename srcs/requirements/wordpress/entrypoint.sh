#! /bin/sh

set -e

# extract passwords from secrets
WP_DB_PASSWORD=$(cat $WP_DB_PASSWORD_FILE)
WP_ADMIN_PASSWORD=$(cat $WP_ADMIN_PASSWORD_FILE)
WP_USER_PASSWORD=$(cat $WP_USER_PASSWORD_FILE)

# create wp-config.php
if [ ! -f "/var/www/html/wp-config.php" ]; then
	wp config create --path=/var/www/html/ --dbname="$WP_DB" --dbuser="$WP_DB_USER" --dbpass="$WP_DB_PASSWORD" --dbhost="$WP_DB_HOST:$WP_DB_PORT" --dbprefix="$WP_DB_PREFIX" --skip-check
	wp config set FS_METHOD direct --config-file=/var/www/html/wp-config.php
fi


# install wordpress
if [ ! -f "/var/www/html/.wp_initialized" ]; then
	until mysql "$WP_DB" -h "$WP_DB_HOST" -u "$WP_DB_USER" --password="$WP_DB_PASSWORD" 2> /dev/null; do
		echo "Waiting for mariadb to be available..."
		sleep 2
	done
	wp core install --path=/var/www/html/ --url="$WP_WEBSITE_URL" --title="$WP_WEBSITE_TITLE" --admin_user="$WP_ADMIN_USER" --admin_password="$WP_ADMIN_PASSWORD" --admin_email="$WP_ADMIN_EMAIL" --skip-email
	wp user create --path=/var/www/html/ "$WP_USER" "$WP_USER_EMAIL" --role=author --user_pass="$WP_USER_PASSWORD"
	# mark successful installation
	touch /var/www/html/.wp_initialized
	# after installing all directories and files should be owned by wp_user
	chown -R wp_user:wp_group /var/www/html
fi

exec su-exec wp_user php-fpm -F
