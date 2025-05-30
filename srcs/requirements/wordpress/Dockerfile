FROM alpine:3.20

RUN apk update && apk upgrade
RUN apk add php php-fpm

RUN addgroup -S fpm_group && adduser -S fpm_user -G fpm_group

RUN set -e && \
    php_fpm_bin=$(find /usr/sbin -name 'php-fpm*' | grep -E '^/usr/sbin/php-fpm[0-9]+' | head -n1) && \
	ln -s "$php_fpm_bin" /usr/sbin/php-fpm

USER fpm_user

CMD ["/bin/sh"]
