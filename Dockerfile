FROM ubuntu

ARG VENVLOCATION=/opt/venv
# update packages
RUN apt-get update

ENV DEBIAN_FRONTEND=noninteractive
# ENV PIP_ROOT_USER_ACTION=ignore

# install required packages
RUN apt-get install -y python3-venv \
                        python3-dev \
                        python3-pip \
                        nginx \
                        software-properties-common \
                        vim \
                        libpcre3-dev \
                        uwsgi-plugin-python3 uwsgi


RUN python3 -m venv $VENVLOCATION
ENV PATH="/opt/venv/bin:$PATH"


WORKDIR /var/www/django_app
COPY django_app/. /var/www/django_app/

RUN pip install --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org -r requirements.txt

RUN mkdir -p /var/log/uwsgi/vassals


RUN chown -R www-data:www-data /var/www/django_app
RUN chown -R www-data:www-data /var/log/uwsgi
RUN chown -R www-data:www-data /var/log/nginx
RUN chmod -R 755 /var/www/django_app
RUN chmod -R 664 /var/log/uwsgi
RUN chmod -R 664 /var/log/nginx



COPY config/default /etc/nginx/sites-available/
COPY config/uwsgi.ini /etc/uwsgi/apps-enabled/ 
RUN /etc/init.d/nginx restart
USER www-data 
ENTRYPOINT [ "/usr/bin/uwsgi" ]

EXPOSE 8000
CMD ["--ini", "/etc/uwsgi/apps-enabled/uwsgi.ini"]

