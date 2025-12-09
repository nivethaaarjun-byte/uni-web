#!/usr/bin/env bash
# exit on error
set -o errexit

pip install --upgrade pip
pip install -r requirements.txt

# Run database migrations if needed
# Uncomment the line below after setting up your database
# python -c "from DB import orm; orm.db.create_all()"
