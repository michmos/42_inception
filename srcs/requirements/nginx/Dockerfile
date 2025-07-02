
FROM alpine:3.20

RUN apk add --no-cache nginx

RUN addgroup -S nginx_group && adduser -S nginx_user -G nginx_group

# create dirs required by nginx and give nginx_user permissions
RUN set -e \
	&& mkdir -p /var/cache/nginx /var/log/nginx/ /etc/ssl/certs/ /var/lib/nginx /run/nginx && touch /run/nginx.pid \
	&& chown -R nginx_user:nginx_group /var/cache/nginx /var/log/nginx/ /var/lib/nginx /run/nginx \
	&& chmod -R 700 /var/cache/nginx /var/log/nginx/ /var/lib/nginx/ /run/nginx /etc/ssl/certs/

COPY conf/nginx.conf /etc/nginx/nginx.conf

USER nginx_user

ENTRYPOINT ["nginx", "-g", "daemon off;"]
