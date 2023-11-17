FROM ubuntu

ENV DEBIAN_FRONTEND=noninteractive

 
RUN apt-get update && apt-get install -y python3-venv python3-dev python3-pip nginx software-properties-common sqlitebrowser

WORKDIR /apps
COPY . /apps

RUN pip install -r requirements.txt

RUN python3 manage.py migrate

RUN DJANGO_SUPERUSER_PASSWORD=admin python3 manage.py createsuperuser --username admin --email admin@mail.com