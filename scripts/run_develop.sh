#!/bin/bash
# Wait for DB to be ready
/code/scripts/wait-for-it db:5432 --timeout=60 --strict -- echo "Postgres is ready"

echo "########################"
echo "Running migrations and starting development server"
echo "########################"

# Optional: skip collectstatic in dev
# python manage.py collectstatic --noinput &

python manage.py migrate &
python manage.py runserver 0.0.0.0:8000
