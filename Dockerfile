# Use an official Ubuntu runtime as a parent image
FROM ubuntu:latest

# Avoid prompts during package installations
ENV DEBIAN_FRONTEND=noninteractive

# Update and install necessary dependencies
RUN apt-get update -y && \
    apt-get install -y python3 python3-pip python3-venv nginx

# Create and set working directory
WORKDIR /app

# Copy and install requirements
COPY requirements.txt /app/
RUN python3 -m venv venv && \
    . venv/bin/activate && \
    pip install --no-cache-dir -r requirements.txt

# Copy the Django project files to the container
COPY . /app/

COPY nginx /etc/nginx/site-available/default

EXPOSE 8000

RUN service nginx start

# Configure uWSGI
CMD ["venv/bin/uwsgi", "--ini", "/app/uwsgi.ini"]