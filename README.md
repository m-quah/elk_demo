## Description

This project uses Docker to set up a single-node ELK stack (ver. 8.x.x) with security enabled. Syslogs are streamed and indexed into Elasticsearch using Filebeat/Logstash. A demo Security Alert/Rule Dashboard displaying various syslog details and preconfigured Security Rules have also been set up in Kibana.

The current setup involves 2 different sources of syslog that are streamed into Elasticsearch:
  1. '*filebeat_es*' container uses *filebeat* to stream its local syslogs directly to Elasticsearch
  2. '*filebeat_logstash*' container uses *filebeat* to receive host machine's syslog via port 5000 and outputs it to *logstash* which parses the data before shipping to Elasticsearch


## Preparation of Environment

Before running `docker-compose`, ensure the following settings have been configured:
- Set up passwords for Elasticsearch, Kibana and Logstash in `.env` file
- Set the same password (in the `.env` file) for the '*elastic*' user in the '*/configfiles/logstash.conf*' file and also the '*/configfiles/filebeat_\*.yml*' files as required
- Set vm.max_map_count to at least 262144
  ``` bash
  sudo sysctl -w vm.max_map_count=262144
  ```
- Set up *rsyslog* to send messages to port 5000 on the host machine
  - Add the following line to the file *'/etc/rsyslog.d/50=default.conf'* so that all syslog messages are routed to port 5000
    - `*.*      @@127.0.0.1:5000`
  - Restart *rsyslog.service* to update the latest changes
    ``` bash 
    sudo systemctl restart rsyslog.service
    ```


## Set Up ELK and Filebeat Services with Docker

- Navigate to the directory containing the *docker-compose.yml* file. 
- Run the following command to start the various ELK services.
``` bash
docker-compose up --build
``` 

Once setup is completed, `stdout` will periodically update with the latest syslog log entry, which is also being added to the Elasticsearch index '***syslog***' (configured in the output in the file '*/configfiles/logstash.conf*').


## Kibana Login

Login to Kibana via `localhost:5601` in the web browser, with the username '*elastic*' and the password that was set up previously in the `.env` file.


## Kibana Security Alerts/Rules Dashboard

A few **preconfigured security rules** have already been set up. To access them, follow these steps:
1. Import the *saved_object* located in '***./kibana_saved_objects/demo.ndjson***' into Kibana.
      - **Management** -> **Stack Management** -> **Kibana** -> **Saved Objects**
  2. Import the *preconfigured security rules* located in '***./security_rules/rules_export.ndjson***' into Kibana.
      - **Security** -> **Rules** -> **Import Rules**
      - Each rule has a brief description of what it is detecting
      - Rules have also been configured to run every 1 minute
  3. Ensure that the various rules are '**Enabled**'

Navigate to the Security Alert Dashbord to have an overview of the number of occurrences of each rule.

One of the rule detects the use of `sudo` in the host machine (which is captured by syslog message). To trigger the alert, enter any `sudo` command in the host machine terminal (eg. `sudo ls`).


## Tear Down ELK Services

- To tear down the services cleanly and remove all named volumes, run the command 
``` bash
docker-compose down -v
```