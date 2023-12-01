# Copyright 2013 Thatcher Peskens
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM ubuntu

ARG VENVLOCATION=/opt/venv
# update packages
RUN apt-get update

ENV DEBIAN_FRONTEND=noninteractive
# ENV PIP_ROOT_USER_ACTION=ignore

# install required packages
RUN apt-get install -y python3-venv python3-dev python3-pip nginx software-properties-common vim libpcre3-dev uwsgi-plugin-python3



RUN python3 -m venv $VENVLOCATION
ENV PATH="/opt/venv/bin:$PATH"

WORKDIR /var/www/django_app
COPY django_app/. /var/www/django_app/

RUN pip install --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org -r requirements.txt

RUN mkdir -p /var/log/uwsgi/vassals
RUN chown -R www-data:www-data /var/log/uwsgi 
RUN chmod -R 750 /var/log/uwsgi 

#RUN chown -R www-data:www-data /opt/venv
#RUN chown -R www-data:www-data /var/www/django_app

COPY config/default /etc/nginx/sites-available/
COPY config/uwsgi.ini /etc/uwsgi/apps-enabled/ 

RUN /etc/init.d/nginx restart

CMD [ "/usr/bin/uwsgi", "--ini", "/etc/uwsgi/apps-enabled/uwsgi.ini" ]

