FROM ubuntu:22.04

RUN (apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential git python3-venv python3-dev pip python3-setuptools nginx sqlite3 supervisor)
RUN pip install uwsgi

ADD app/requirements.txt /opt/django/app/requirements.txt
RUN pip install -r /opt/django/app/requirements.txt
ADD . /opt/django/

RUN (echo "daemon off;" >> /etc/nginx/nginx.conf &&\
  rm /etc/nginx/sites-enabled/default &&\
  ln -s /opt/django/django.conf /etc/nginx/sites-enabled/ &&\
  ln -s /opt/django/supervisord.conf /etc/supervisor/conf.d/)

COPY run.sh /opt/django/run.sh

RUN chmod +x /opt/django/run.sh

VOLUME ["/opt/django/app"]
EXPOSE 80
CMD ["/opt/django/run.sh"]