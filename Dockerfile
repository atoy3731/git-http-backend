# small is beautiful
FROM alpine:latest

MAINTAINER hey@bgulla.dev

# The container listens on port 80, map as needed
EXPOSE 80

# This is where the repositories will be stored, and
# should be mounted from the host (or a volume container)
VOLUME ["/git"]

# We need the following:
# - git, because that gets us the git-http-backend CGI script
# - fcgiwrap, because that is how nginx does CGI
# - spawn-fcgi, to launch fcgiwrap and to create the unix socket
# - nginx, because it is our frontend
RUN apk add --update nginx && \
    apk add --update git && \
    apk add --update git-daemon && \
    apk add --update fcgiwrap && \
    apk add --update spawn-fcgi && \
    rm -rf /var/cache/apk/*

COPY ./src/nginx.conf /etc/nginx/nginx.conf
COPY ./src/run.sh /run.sh
RUN chmod +x /run.sh

#CMD sh /run.sh

CMD spawn-fcgi -s /run/fcgi.sock /usr/bin/fcgiwrap && \
    nginx -g "daemon off;"
