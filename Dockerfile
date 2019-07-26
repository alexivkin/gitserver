# Git with Smart HTTP
FROM nginx:alpine

LABEL description="GIT server with SSL and authentication"
LABEL maintainer="Alex Ivkin"

# git-daemon is the alpine thing, most other distros have it in the git package
# spawn-fcgi launches fcgiwrap to create the unix socket
RUN apk add --no-cache git git-daemon fcgiwrap spawn-fcgi \
 && mkdir /www /git \
 && chown nginx:nginx /www /git \
 && echo "This page is intentionally left blank" > /www/index.html

COPY gitsite.conf /etc/nginx/conf.d/default.conf

VOLUME /git
# start with the fcgi in the back, accessible by nginx
CMD spawn-fcgi -U nginx -G nginx -s /var/run/fcgiwrap.socket /usr/bin/fcgiwrap && nginx -g "daemon off;"
