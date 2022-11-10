# small is beautiful
FROM alpine:latest

MAINTAINER hey@bgulla.dev

# The container listens on port 80, map as needed
EXPOSE 80

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

# Initialize charts
COPY ./src/charts.txt /tmp/charts.txt
COPY ./src/init-charts.sh /tmp/init-charts.sh
RUN chmod +x /tmp/init-charts.sh && \
    sh /tmp/init-charts.sh && \
    rm -f /tmp/charts.txt && \
    rm -f /tmp/init-charts.sh

COPY ./src/nginx.conf /etc/nginx/nginx.conf
COPY ./src/run.sh /run.sh
RUN chmod +x /run.sh

CMD sh /run.sh
