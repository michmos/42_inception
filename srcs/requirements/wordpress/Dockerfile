FROM alpine:3.20

RUN apk update && apk upgrade
RUN apk add php php-fpm

RUN addgroup -S wp_group && adduser -S wp_user -G wp_group

RUN set -e && \
    php_fpm_bin=$(find /usr/sbin -name 'php-fpm*' | grep -E '^/usr/sbin/php-fpm[0-9]+' | head -n1) \
	&& ln -s "$php_fpm_bin" /usr/sbin/php-fpm \
	&& err_log_dir=$(find /var/log/ -name 'php*') \
	&& chown wp_user:wp_group "$err_log_dir"


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
	&& conf_dir=$(find /etc/php* -name 'php-fpm.d') \
	&& mv conf/www.conf "$conf_dir"/www.conf \
	&& mv conf/wp-config.php /var/www/html/

USER wp_user

CMD ["php-fpm", "-F"]
