#!/bin/bash
set -e

DATE=$(date +%Y-%m-%d-%H-%M-%S)
BACKUP_DIR="backup"

echo "Starting mongodump..."

mongodump --host $MONGO_HOST \
    --port $MONGO_PORT \
    --username $MONGO_USERNAME \
    --password $MONGO_PASSWORD \
    --authenticationDatabase admin \
    --db $MONGO_DB_NAME \
    --collection $MONGO_COLLECTION_NAME \
    --out ./$BACKUP_DIR

tar -czf "$BACKUP_DIR-$DATE.tar.gz" -c "$BACKUP_DIR"

echo "Uploading backup to S3..."
aws s3 cp "./$BACKUP_DIR-$DATE.tar.gz" "s3://$S3_BUCKET/$MONGO_COLLECTION_NAME-$DATE.tar.gz"

echo "Backup and upload completed successfully."
