#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Quick script to check database configuration
Run this to verify which database is being used
"""
import os
from web.app import app

print("=" * 60)
print("DATABASE CONFIGURATION CHECK")
print("=" * 60)

# Check environment variable
db_url_env = os.environ.get('DATABASE_URL', 'NOT SET')
print(f"\n1. DATABASE_URL environment variable:")
print(f"   {db_url_env}")

# Check Flask config
db_url_config = app.config.get('SQLALCHEMY_DATABASE_URI', 'NOT SET')
print(f"\n2. Flask SQLALCHEMY_DATABASE_URI config:")
print(f"   {db_url_config}")

# Determine database type
if 'postgresql' in db_url_config.lower():
    print(f"\n✅ Using PostgreSQL")
elif 'sqlite' in db_url_config.lower():
    print(f"\n❌ Using SQLite (THIS IS WRONG FOR PRODUCTION!)")
else:
    print(f"\n⚠️  Unknown database type")

print("\n" + "=" * 60)
print("WHAT TO DO:")
print("=" * 60)

if 'sqlite' in db_url_config.lower() or db_url_env == 'NOT SET':
    print("\n❌ DATABASE_URL is not set or incorrect!")
    print("\nOn Render Dashboard:")
    print("1. Go to your Web Service")
    print("2. Click 'Environment' tab")
    print("3. Add/Edit DATABASE_URL variable")
    print("4. Use the INTERNAL Database URL from your PostgreSQL")
    print("5. It should look like:")
    print("   postgresql://user:pass@dpg-xxx-a/dbname")
    print("   (Note: NOT the External URL with 'virginia-postgres.render.com')")
else:
    print("\n✅ DATABASE_URL is set correctly!")

print("\n" + "=" * 60)
