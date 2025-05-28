FROM alpine:3.20

# installing nginx
# 	installing prerequisites
RUN apk add openssl curl ca-certificates \
	# set up apk repo for stable nginx packages
	&& printf "%s%s%s%s\n" \
    "@nginx " \
    "http://nginx.org/packages/alpine/v" \
    `egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release` \
    "/main" \
    | tee -a /etc/apk/repositories \
	# import nginx signing key for apk to verify package authenticity
	&& curl -o /tmp/nginx_signing.rsa.pub https://nginx.org/keys/nginx_signing.rsa.pub \
	&& mv /tmp/nginx_signing.rsa.pub /etc/apk/keys/ \
	# install nginx
	&& apk add nginx@nginx

# create usergroup and user
RUN addgroup -S nginx_group && adduser -S nginx_user -G nginx_group

# create dirs required by nginx and give nginx_user permissions
RUN mkdir -p /var/cache/nginx /var/log/nginx/ && touch /run/nginx.pid \
	&& chown nginx_user:nginx_group /var/cache/nginx /var/log/nginx/ /run/nginx.pid \
	&& chmod -R 700 /var/cache/nginx /var/log/nginx/ /run/nginx.pid

WORKDIR /app

RUN mkdir data

COPY . .

RUN mv conf /etc/nginx/nginx.conf

USER nginx_user

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]

