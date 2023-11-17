FROM ubuntu

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y python3-venv python3-dev python3-pip nginx software-properties-common uwsgi uwsgi-plugin-python3

WORKDIR /var/www/django-uwsgi-nginx
COPY . /var/www/django-uwsgi-nginx

RUN python3 tools/django_secret_keygen.py
RUN python3 -m venv venv

RUN rm /etc/nginx/sites-enabled/default
RUN ln -s /var/www/django-uwsgi-nginx/conf/nginx.conf /etc/nginx/conf.d/
RUN service nginx restart

RUN pip install -r requirements.txt

RUN ln -s /var/www/django-uwsgi-nginx/conf/uwsgi.ini /etc/uwsgi/apps-available/
RUN ln -s /var/www/django-uwsgi-nginx/conf/uwsgi.ini /etc/uwsgi/apps-enabled/

RUN mkdir -p /var/log/uwsgi

RUN python3 djangosite/manage.py collectstatic --settings=djangosite.settings.prod

COPY conf/emperor.ini /etc/uwsgi/emperor.ini

EXPOSE 80

CMD ["uwsgi", "--ini", "conf/uwsgi.ini", "--emperor", "/etc/uwsgi/apps-enabled"]