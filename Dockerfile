FROM debian:10-slim

RUN apt-get update && \
    apt-get install -y gnupg1 apt-transport-https dirmngr mosquitto-clients jq cron && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 379CE192D401AB61 && \ 
    echo "deb https://ookla.bintray.com/debian generic main" | tee  /etc/apt/sources.list.d/speedtest.list && \
    apt-get update && \
    apt-get install -y speedtest && \
    rm -rf /var/cache/apt

RUN groupadd foo && \
    useradd -m -g foo foo

ADD ./entrypoint.sh /opt/entrypoint.sh
ADD ./speedtest2mqtt.sh /opt/speedtest2mqtt.sh
RUN chmod +x /opt/speedtest2mqtt.sh /opt/entrypoint.sh

RUN chmod gu+s /usr/sbin/cron

USER foo

ENTRYPOINT /opt/entrypoint.sh

