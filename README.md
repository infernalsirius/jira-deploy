# Resrote data in Jira
### Set permissions for data directory
chmod -R 777 jira-data2  

### Backup Jira indexes
`sudo rm -r jira-data2/caches`  
`sudo cp -r /var/lib/docker/volumes/jira_data/_data/caches/ jira-data2/caches/`  
`sudo chown -R orid:orid jira-data2/caches`  

### with docker
`docker exec -it jira_jira_1 rm -r caches`
`sudo docker cp /var/lib/docker/volumes/jira_data/_data/caches/ jira_jira_1:/var/atlassian/jira/caches/`  



### Backup Jira data
`sudo rm -r  jira-data2/data/`  
`sudo cp -r /var/lib/docker/volumes/jira_data/_data/data jira-data2/data/`    
`sudo chown -R orid:orid jira-data2/data/`  


### with docker
`docker exec -it jira_jira_1 rm -r data`  
`sudo docker cp /var/lib/docker/volumes/jira_data/_data/data jira_jira_1:/var/atlassian/jira/data`  

# Reindex
In order the changes to take effect you should reindex Jira, reindexing is done via the UI, instructions [here](https://confluence.atlassian.com/adminjiraserver073/search-indexing-861253852.html).  

### From command line via REST API
`curl -D- -s -S -k -u orid:turhsubr1974 -X POST -H "Content-Type: application/json" "jira.sq.l/rest/api/2/reindex"`  