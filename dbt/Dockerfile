FROM python:3.12-slim

WORKDIR /usr/app/dbt

RUN apt-get update \
    && apt-get install -y git \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir dbt-postgres

CMD ["tail", "-f", "/dev/null"]