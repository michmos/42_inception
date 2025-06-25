FROM alpine:3.20

RUN apk update && apk upgrade
RUN apk add php83 php83-fpm

RUN addgroup -S wp_group && adduser -S wp_user -G wp_group

RUN set -e \
	&& ln -s /usr/sbin/php-fpm83 /usr/sbin/php-fpm \
	&& chown wp_user:wp_group /var/log/php83/

RUN set -e \
	&& apk add --no-cache wget ca-certificates \
	&& update-ca-certificates \
	&& wget https://wordpress.org/latest.tar.gz \
	&& tar -xf latest.tar.gz \
	&& mkdir -p /var/www/html/ \
	&& mv wordpress/* /var/www/html/ \
	&& rm -rf latest.tar.gz wordpress


WORKDIR /app
COPY . .

# move files
RUN set -e \
	&& mv conf/www.conf /etc/php83/php-fpm.d/www.conf \
	&& mv conf/wp-config.php /var/www/html/

USER wp_user

CMD ["php-fpm", "-F"]
