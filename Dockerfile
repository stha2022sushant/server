FROM python:3.11-slim-bookworm

LABEL maintainer="stha2022sushant@gmail.com"

# -----------------------------
# Environment variables
# -----------------------------
ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    DEBIAN_FRONTEND=noninteractive \
    POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_CREATE=false

WORKDIR /code

# -----------------------------
# System dependencies
# -----------------------------
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
        git \
        iproute2 \
        gcc \
        build-essential \
        libpq-dev \
        postgresql-client \
        gdal-bin \
        libgdal-dev \
        curl \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# -----------------------------
# wait-for-it script
# -----------------------------
RUN curl -o /usr/local/bin/wait-for-it.sh \
    https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh \
    && chmod +x /usr/local/bin/wait-for-it.sh

# -----------------------------
# Poetry
# -----------------------------
RUN pip install --upgrade pip poetry

# -----------------------------
# Copy dependency files first
# (helps Docker cache layers)
# -----------------------------
COPY pyproject.toml poetry.lock /code/

# -----------------------------
# Install Python dependencies
# -----------------------------
RUN poetry install --no-interaction --no-ansi --no-root

# -----------------------------
# Copy project source
# -----------------------------
COPY . /code/


# -----------------------------
# Default command
# -----------------------------
CMD ["bash", "scripts/run_develop.sh"]
