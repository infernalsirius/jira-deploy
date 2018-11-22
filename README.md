# Backup 
Backup script inspired by [this](https://github.com/puppetlabs/jira-backup) GitHub project.
We will Use two stages backup process as described [here](https://confluence.atlassian.com/adminjiraserver071/backing-up-data-802592964.html) (not [_Jira's XML Backup_](https://confluence.atlassian.com/adminjiraserver071/automating-jira-application-backups-802592966.html)):

1. _Postgres_ backup with native database backup tool.
2. _Jira's_ application data to backup (path inside the _Docker_ container):
    - This directory includes **attachments** directory: **/var/atlassian/jira/data**
    - This directory includes _Jira Indexes_: **/var/atlassian/jira/caches**  

### Set permissions for data directory

`chmod -R 777 jira-data2`    

### 1. Backup _Jira_ indexes
`sudo rm -r jira-data2/caches`  
`sudo cp -r /var/lib/docker/volumes/jira_data/_data/caches/ jira-data2/caches/`  
`sudo chown -R orid:orid jira-data2/caches`  

### With _Docker_
`docker exec -it jira_jira_1 rm -r caches`
`sudo docker cp /var/lib/docker/volumes/jira_data/_data/caches/ jira_jira_1:/var/atlassian/jira/caches/`  



### 2. Backup _Jira_ data
`sudo rm -r  jira-data2/data/`  
`sudo cp -r /var/lib/docker/volumes/jira_data/_data/data jira-data2/data/`    
`sudo chown -R orid:orid jira-data2/data/`  


### With _Docker_
`docker exec -it jira_jira_1 rm -r data`  
`sudo docker cp /var/lib/docker/volumes/jira_data/_data/data jira_jira_1:/var/atlassian/jira/data`  

### 3. Backup _Postgres_ database
`docker exec jira_postgresql_1  pg_dump --dbname=jira.sq.l://orid:turhsubr1974:5432/jiradb > postgres_backup.sql`

# Restore
### _Postgres_ datadase restore
Copy backup script to container:  
`docker cp postgres_backup.sql jira_postgresql_1:/var/backups/postgres_backup.sql`  

Run backup script inside the container:  
`docker exec -it jira_postgresql_1 psql -U jira -d jiradb -f /var/backups/postgres_backup.sql`  

### _Jira_ Reindex
In order the changes to take effect you should reindex Jira, reindexing is done via the UI, instructions [here](https://confluence.atlassian.com/adminjiraserver073/search-indexing-861253852.html).  
From command line via REST API:  
`curl -D- -s -S -k -u orid:turhsubr1974 -X POST -H "Content-Type: application/json" "jira.sq.l/rest/api/2/reindex"`  