FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /app

# Install required packages
RUN apt-get update && apt-get install -y wget && rm -rf /var/lib/apt/lists/*

# Download and install Cloud SQL Proxy
RUN wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud_sql_proxy
RUN chmod +x cloud_sql_proxy

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN mkdir -p /app/staticfiles
RUN python manage.py collectstatic --noinput

EXPOSE 8000

# Start Cloud SQL Proxy in background and then start Django
CMD ["sh", "-c", "./cloud_sql_proxy -instances=unified-atom-461804-c9:us-central1:pro-shop-db=tcp:5432 & sleep 10 && python manage.py migrate && gunicorn backend.wsgi:application --bind 0.0.0.0:8000"]