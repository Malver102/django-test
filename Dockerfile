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

from ubuntu


# update packages
run apt-get update

ENV DEBIAN_FRONTEND=noninteractive

# install required packages
RUN apt-get install -y python3-venv python3-dev python3-pip nginx software-properties-common




RUN python3 -m venv app
WORKDIR /app
COPY . /app
ENV PATH="/app/bin:$PATH"
RUN /bin/bash -c "source /app/bin/activate"
RUN pip install -r requirements.txt
RUN /app/app/bin/django-admin startproject helloworld
WORKDIR /app/helloworld
RUN /app/app/bin/python3 manage.py migrate
RUN DJANGO_SUPERUSER_PASSWORD=admin  /app/app/bin/python3 manage.py createsuperuser --username=admin --email=ps@drutex.pl --noinput




expose 8000
cmd ["/app/bin/python3", "manage.py", "runserver", "0.0.0.0:8000"]
