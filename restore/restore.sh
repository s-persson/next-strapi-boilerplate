#!/bin/bash
if [ -z "$RESTORE_PATH" ]; then
  echo "RESTORE_PATH not set"
  exit 1
fi

CONTAINERS=("strapi" "postgres-server")
for c in "${CONTAINERS[@]}"; do
  if ! docker ps --format '{{.Names}}' | grep -q "^$c$"; then
  echo "Container $c is not running, stopping backup process"
  exit 1
fi
done

echo "Stopping all connections"
PGPASSWORD="$DATABASE_PASSWORD" psql -h postgres-server -U "$DATABASE_USERNAME" -d postgres -c "
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = '$DATABASE_NAME'
  AND pid <> pg_backend_pid();
"

echo "Removing and recreating database"
PGPASSWORD="$DATABASE_PASSWORD" psql -h postgres-server -U "$DATABASE_USERNAME" -d postgres -c "DROP DATABASE IF EXISTS \"$DATABASE_NAME\";"
PGPASSWORD="$DATABASE_PASSWORD" psql -h postgres-server -U "$DATABASE_USERNAME" -d postgres -c "CREATE DATABASE \"$DATABASE_NAME\";"

echo "Restoring from $RESTORE_PATH"
  
# Restore PostgreSQL database
PGPASSWORD="$DATABASE_PASSWORD" pg_restore -h postgres-server -p 5432 -U "$DATABASE_USERNAME" -d "$DATABASE_NAME" -v "$RESTORE_PATH/postgres.dump" --if-exists -c

# Restore Strapi files
echo "Restoring Strapi files"
rsync -a "$RESTORE_PATH/config/" /mnt/strapi_config/
rsync -a "$RESTORE_PATH/src/" /mnt/strapi_src/
rsync -a "$RESTORE_PATH/uploads/" /mnt/strapi_uploads/

echo "Restore completed"