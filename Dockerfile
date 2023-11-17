FROM ubuntu

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y python3-venv python3-dev python3-pip nginx software-properties-common uwsgi supervisor

WORKDIR /var/www/django-uwsgi-nginx
COPY . /var/www/django-uwsgi-nginx

RUN rm /etc/nginx/sites-enabled/default
RUN ln -s /var/www/django-uwsgi-nginx/conf/nginx.conf /etc/nginx/conf.d/
RUN service nginx restart

RUN ln -s /var/www/django-uwsgi-nginx/conf/uwsgi.ini /etc/uwsgi/apps-available/
RUN ln -s /var/www/django-uwsgi-nginx/conf/uwsgi.ini /etc/uwsgi/apps-enabled/

RUN mkdir -p /var/log/uwsgi

RUN python3 manage.py collectstatic --settings=djangosite.settings.prod

# Supervisor configuration
COPY supervisor.conf /etc/supervisor/conf.d/supervisor.conf


EXPOSE 80

# CMD to run supervisor
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]