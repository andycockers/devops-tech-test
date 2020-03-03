export DB_IDENTIFIER=$1

aws rds delete-db-instance --db-instance-identifier $DB_IDENTIFIER --final-db-snapshot-identifier cmsfinalsnapshot --delete-automated-backups 