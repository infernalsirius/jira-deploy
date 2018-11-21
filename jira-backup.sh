#!/bin/bash
JIRA_BACKUP_DIR=/home/sqream/jira/jira/backups

# Jira Data
JIRA_DATA_PATH=/home/sqream/jira/jira/jira-data/data
JIRA_INDEX_PATH=/home/sqream/jira/jira/jira-data/caches

# Database
DB_NAME=jiradb
DB_HOST=postgresql
DB_USER=jira
DB_PASS=jellyfish
TIMESTAMP=$(date +'%Y-%m-%d-%H-%M')

# Output
JIRA_DATA_BACKUP_OUTPUT=${JIRA_BACKUP_DIR}/jira-data-${TIMESTAMP}.tar
JIRA_INDEX_BACKUP_OUTPUT=${JIRA_BACKUP_DIR}/jira-index-${TIMESTAMP}.tar
JIRA_DATABASE_DUMP_OUTPUT=${JIRA_BACKUP_DIR}/jira-database-dump-${TIMESTAMP}.sql

backup_jira_data() {
    echo "Backing up Jira data"
    tar -P -cf  ${JIRA_DATA_BACKUP_OUTPUT} ${JIRA_DATA_PATH}
    echo "Created ${JIRA_DATA_BACKUP_OUTPUT}"
}

backup_jira_index() {
   echo "Backing up Jira indexes"
   tar -P -cf ${JIRA_INDEX_BACKUP_OUTPUT} ${JIRA_INDEX_PATH}
   echo "Created ${JIRA_INDEX_BACKUP_OUTPUT}"
}

dump_jira_database() {
    echo "Dumping Jira database"
    docker exec jira_postgresql_1  pg_dump --dbname=$DB_HOST://$DB_USER:$DB_PASS@$DB_HOST:5432/$DB_NAME > postgres_backup.sql
    echo "pg_dump --dbname=$DB_HOST://$DB_USER:$DB_PASS@$DB_HOST:5432/$DB_NAME > postgres_backup.sql"
    #/usr/bin/pg_dump -U "${DB_USER}" "${DB_NAME}" -h "${DB_HOST}" > "${JIRA_DATABASE_DUMP_OUTPUT}"
    echo "Created ${JIRA_DATABASE_DUMP_OUTPUT}"
}

main() {
    echo "Backing up Jira"
    backup_jira_data
    backup_jira_index
    dump_jira_database
}

main