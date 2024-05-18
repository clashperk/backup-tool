#!/bin/bash
set -e

DATE=$(date +%Y-%m-%dT%H-%M)
BACKUP_DIR="backup"

echo "Starting mongodump..."

COLLECTIONS=("PlayerLinks" "Users" "ClanStores" "LastSeen")

for COLLECTION in "${COLLECTIONS[@]}";
do
    mongodump --host $MONGO_HOST \
        --port $MONGO_PORT \
        --username $MONGO_USERNAME \
        --password $MONGO_PASSWORD \
        --authenticationDatabase admin \
        --db $MONGO_DB_NAME \
        --collection $COLLECTION \
        --out ./$BACKUP_DIR
done

tar -czf "$DATE.tar.gz" -c "$BACKUP_DIR"

echo "Uploading backup to S3..."
aws s3 cp "./$DATE.tar.gz" "s3://$S3_BUCKET/$DATE.tar.gz"

echo "Backup and upload completed successfully."
