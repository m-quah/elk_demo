FROM docker.elastic.co/logstash/logstash:8.3.3

RUN rm -f /usr/share/logstash/config/logstash.yml

RUN rm -f /usr/share/logstash/pipeline/logstash.conf

ADD ./configfiles/logstash.yml /usr/share/logstash/config/logstash.yml

ADD ./configfiles/logstash.conf /usr/share/logstash/pipeline/logstash.conf