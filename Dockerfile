FROM ubuntu:18.04
MAINTAINER Chronicle Kein <keinclonicle@gmail.com>

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y vim
RUN apt-get install -y git
RUN apt-get install -y nginx
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf
RUN chown -R www-data:www-data /var/lib/nginx
RUN apt-get install -y software-properties-common
RUN apt-get update
RUN add-apt-repository ppa:certbot/certbot
RUN apt-get update
RUN apt-get install -y python-certbot-nginx

VOLUME ["/data", "/etc/nginx/site-enabled", "/var/log/nginx"]

WORKDIR /etc/nginx

CMD ["nginx"]

EXPOSE 80
EXPOSE 443
