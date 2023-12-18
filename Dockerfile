FROM ubuntu


USER root

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

RUN mkdir -p /var/log/uwsgi/vassals \ 
    && mkdir -p /var/www/django_app/static


#RUN chown -R www-data:www-data /var/log/uwsgi \
#    && chown -R www-data:www-data /var/www/django_app \
#    && chown -R www-data:www-data /opt/venv \
#    && chown -R www-data:www-data /var/log/nginx \
##    && chmod -R 755 /opt/venv \
 #   && chmod -R 664 /var/www/django_app \
 #   && chmod -R 664 /var/log/uwsgi \
 #   && chmod -R 664 /var/log/nginx


COPY config/run.sh /
COPY config/default /etc/nginx/sites-available/
COPY config/uwsgi.ini /etc/uwsgi/apps-enabled/ 

RUN python3 /var/www/django_app/manage.py collectstatic \
    && python3 /var/www/django_app/manage.py migrate 

RUN chmod +x /run.sh

EXPOSE 80
ENTRYPOINT [ "/bin/bash" ]
CMD [ "/run.sh" ]


