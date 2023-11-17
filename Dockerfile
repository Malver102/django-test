FROM Ubuntu

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y python3-venv python3-dev python3-pip nginx software-properties-common uwsgi

WORKDIR /var/www/django-uwsgi-nginx
COPY . /var/www/django-uwsgi-nginx

RUN rm /etc/nginx/sites-enabled/default

