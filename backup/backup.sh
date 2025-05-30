#!/bin/bash
CONTAINERS=("strapi" "postgres-server")
for c in "${CONTAINERS[@]}"; do
  if ! docker ps --format '{{.Names}}' | grep -q "^$c$"; then
  echo "Container $c is not running, stopping backup process"
  exit 1
fi
done

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
rsync -avz \
  -e "ssh -p${REMOTE_SSH_PORT:-22}" \
  --rsync-path="mkdir -p $REMOTE_STORAGE_BACKUP_PATH/$DATABASE_NAME/$TIMESTAMP && rsync" \
  "$BACKUP_DIR/" \
  "$REMOTE_STORAGE:$REMOTE_STORAGE_BACKUP_PATH/$DATABASE_NAME/$TIMESTAMP/"

echo "Backup completed successfully"