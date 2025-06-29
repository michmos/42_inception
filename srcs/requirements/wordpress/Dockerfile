FROM alpine:3.20

RUN apk update && apk upgrade
RUN apk add --no-cache \
	curl \
	su-exec \
	php83 \
	php83-fpm \
	php83-phar\
	php83-json \
	php83-mysqli \
	php83-curl \
	php83-dom \
	php83-exif \
	php83-fileinfo \
	php83-intl \
	php83-mbstring \
	php83-openssl \
	php83-xml \
	php83-zip \
	php83-apcu \
	php83-opcache \
	php83-redis \
	php83-tokenizer \
	php83-pecl-igbinary \
	php83-pecl-imagick \
	php83-pecl-memcached

RUN addgroup -S wp_group && adduser -S wp_user -G wp_group

RUN set -e \
	&& ln -s /usr/sbin/php-fpm83 /usr/sbin/php-fpm \
	&& chown -R wp_user:wp_group /var/log/php83/

RUN set -e \
	&& curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp

RUN set -e \
	&& mkdir -p /var/www/html \
	&& chown -R wp_user:wp_group /var/www/html \
	&& chmod 755 /var/www/html \
	&& php -d memory_limit=512M /usr/local/bin/wp core download --path=/var/www/html


WORKDIR /app
COPY . .

# move files
RUN set -e \
	&& mv conf/www.conf /etc/php83/php-fpm.d/www.conf

CMD ["/bin/sh", "entrypoint.sh"]
