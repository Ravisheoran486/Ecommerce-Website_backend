#!/bin/sh

./cloud_sql_proxy -instances=unified-atom-461804-c9:us-central1:pro-shop-db=tcp:5432 &
sleep 5

python manage.py migrate

gunicorn backend.wsgi:application --bind 0.0.0.0:8000
