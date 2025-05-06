#!/bin/sh
if [ -z "$RESTORE_PATH" ]; then
  echo "❌ RESTORE_PATH not set"
  exit 1
fi

echo "🔁 Restoring from $RESTORE_PATH"
  
# Restore PostgreSQL database
PGPASSWORD="$DATABASE_PASSWORD" pg_restore -h postgres-server -p 5432 -U "$DATABASE_USERNAME" -d "$DATABASE_NAME" -v "$RESTORE_PATH/postgres.dump" --if-exists -c

# Restore Strapi files
echo "🔁 Restoring Strapi files..."
rsync -a "$RESTORE_PATH/config/" /mnt/strapi_config/
rsync -a "$RESTORE_PATH/src/" /mnt/strapi_src/
rsync -a "$RESTORE_PATH/uploads/" /mnt/strapi_uploads/

echo "✅ Restore completed!"