FROM python:3.11-slim-bookworm

LABEL maintainer="stha2022sushant@gmail.com"

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
        postgresql-client \
    && pip install --upgrade pip poetry \
    && poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-ansi --no-root \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

COPY . /code/

RUN addgroup --system django && adduser --system --ingroup django django

# Make sure the user owns the app folder
RUN chown -R django:django /code

# Switch to the non-root user
USER django

CMD ["bash", "scripts/run_develop.sh"]
