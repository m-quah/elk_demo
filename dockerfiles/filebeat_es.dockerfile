FROM docker.elastic.co/beats/filebeat:8.3.3

COPY --chown=root:filebeat ./configfiles/filebeat_es.yml /usr/share/filebeat/filebeat.yml