FROM alpine:latest

RUN apk --no-cache add bash mosquitto-clients jq wget dcron libcap
RUN wget https://bintray.com/ookla/download/download_file?file_path=ookla-speedtest-1.0.0-x86_64-linux.tgz -O /var/tmp/speedtest.tar.gz
RUN tar xf /var/tmp/speedtest.tar.gz -C /var/tmp
RUN ls -alF /var/tmp
RUN cp /var/tmp/speedtest /usr/local/bin

RUN addgroup -S foo && adduser -S foo -G foo

RUN chown foo:foo /usr/sbin/crond && \
    setcap cap_setgid=ep /usr/sbin/crond

ADD ./entrypoint.sh /opt/entrypoint.sh
ADD ./speedtest2mqtt.sh /opt/speedtest2mqtt.sh
RUN chmod +x /opt/speedtest2mqtt.sh /opt/entrypoint.sh

USER foo

ENTRYPOINT /opt/entrypoint.sh

