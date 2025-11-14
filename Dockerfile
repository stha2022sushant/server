FROM python:3.11-slim-bookworm

LABEL maintainer="dev@alpas.com.np"

ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    DEBIAN_FRONTEND=noninteractive

WORKDIR /code

COPY pyproject.toml poetry.lock /code/

RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
        git \
        iproute2 \
        wait-for-it \
        gdal-bin \
        gcc \
        libpq-dev \
    && pip install --upgrade pip poetry \
    && poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-ansi --no-root \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

COPY . /code/

CMD ["bash", "run_prod.sh"]
