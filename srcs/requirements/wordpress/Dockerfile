FROM alpine:3.20

RUN apk update && apk upgrade
RUN apk add php php-fpm

RUN addgroup -S fpm_group && adduser -S fpm_user -G fpm_group

RUN set -e && \
    php_fpm_bin=$(find /usr/sbin -name 'php-fpm*' | grep -E '^/usr/sbin/php-fpm[0-9]+' | head -n1) && \
	ln -s "$php_fpm_bin" /usr/sbin/php-fpm

RUN set -e \
	&& apk add --no-cache wget ca-certificates \
	&& update-ca-certificates \
	&& wget https://wordpress.org/latest.tar.gz \
	&& tar -xf latest.tar.gz \
	&& mkdir -p /var/www/html/ \
	&& mv wordpress/* /var/www/html/ \
	&& rm -rf latest.tar.gz wordpress

USER fpm_user

CMD ["/bin/sh"]
