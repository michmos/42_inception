
FROM alpine:3.21

RUN apk add --no-cache \
	curl su-exec mariadb-client php83 \
	php83-xmlreader php83-fpm php83-phar php83-json php83-mysqli \
	php83-curl php83-dom php83-exif php83-fileinfo php83-intl \
	php83-mbstring php83-openssl php83-xml php83-zip php83-apcu \
	php83-opcache php83-redis php83-tokenizer php83-pecl-igbinary \
	php83-pecl-imagick php83-pecl-memcached \
	&& addgroup -S wp_group \
	&& adduser -S wp_user -G wp_group \
	&& chown -R wp_user:wp_group /var/log/php83/ \
	&& curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp \
	&& mkdir -p /var/www/html /app/wp/ \
	&& chmod 755 /var/www/html \
	&& php -d memory_limit=512M /usr/local/bin/wp core download --path=/app/wp/

WORKDIR /app

COPY conf/www.conf /etc/php83/php-fpm.d/www.conf
COPY tools/entrypoint.sh .

ENTRYPOINT ["/bin/sh", "/app/entrypoint.sh"]
