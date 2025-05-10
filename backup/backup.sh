#!/bin/sh
TIMESTAMP=$(date +"%Y-%m-%d")
BACKUP_DIR="/mnt/backups/$DATABASE_NAME $TIMESTAMP"  
mkdir -p "$BACKUP_DIR"

# Make pg_dump
PGPASSWORD="$DATABASE_PASSWORD" pg_dump -h postgres-server -p 5432 -U "$DATABASE_USERNAME" -d "$DATABASE_NAME" -F c -b -v -f "$BACKUP_DIR/postgres.dump"

# Copy Strapi config, src, and uploads
rsync -r /mnt/strapi_config "$BACKUP_DIR/config"
rsync -r /mnt/strapi_src "$BACKUP_DIR/src"
rsync -r /mnt/strapi_uploads "$BACKUP_DIR/uploads"

echo "Rsyncing backup to hetzner storage box"
rsync -avz -e "ssh -p23" "$BACKUP_DIR/" u420764@u420764.your-storagebox.de:/home/u420764/backups/"$DATABASE_NAME/$TIMESTAMP"/

echo "✅ Backup completed successfully!"
