#!/bin/sh

set -x

TIMESTAMP=$(date +"%Y-%m-%d-%H-%M")
BACKUP_DIR="/mnt/pg_backup/$TIMESTAMP"  

echo "Creating backup directory at $BACKUP_DIR + "
mkdir -p "$BACKUP_DIR"

# Dump PostgreSQL database
echo "Backing up PostgreSQL to $BACKUP_DIR/postgres.dump"
echo "Database username: $DATABASE_USERNAME Database name: $DATABASE_NAME"
PGPASSWORD="$DATABASE_PASSWORD" pg_dump -h postgres-server -p 5432 -U "$DATABASE_USERNAME" -d "$DATABASE_NAME" -F c -b -v -f "$BACKUP_DIR/postgres.dump"

# Copy Strapi config, src, and uploads
echo "Copying Strapi config, src, and uploads"
cp -r /mnt/strapi_config "$BACKUP_DIR/config"
cp -r /mnt/strapi_src "$BACKUP_DIR/src"
cp -r /mnt/strapi_uploads "$BACKUP_DIR/uploads"

echo "✅ Backup completed successfully!"
