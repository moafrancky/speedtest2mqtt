FROM python:3.8-alpine
ARG TARGETARCH

RUN apk --no-cache add bash mosquitto-clients jq wget gcc musl-dev && \
    echo "Target Arch $TARGETARCH" && \
    if test "$TARGETARCH" = 'amd64'; then wget https://bintray.com/ookla/download/download_file?file_path=ookla-speedtest-1.0.0-x86_64-linux.tgz -O /var/tmp/speedtest.tar.gz; fi && \
    if test "$TARGETARCH" = 'arm'; then wget https://bintray.com/ookla/download/download_file?file_path=ookla-speedtest-1.0.0-arm-linux.tgz -O /var/tmp/speedtest.tar.gz; fi && \
    if test "$TARGETARCH" = 'arm64'; then wget https://bintray.com/ookla/download/download_file?file_path=ookla-speedtest-1.0.0-arm-linux.tgz -O /var/tmp/speedtest.tar.gz; fi && \
    tar xf /var/tmp/speedtest.tar.gz -C /var/tmp && \
    mv /var/tmp/speedtest /usr/local/bin && \
    rm /var/tmp/speedtest.tar.gz

RUN python3 -m venv yacronenv && \
    . yacronenv/bin/activate && \
    pip install yacron

ADD ./entrypoint.sh /opt/entrypoint.sh
ADD ./speedtest2mqtt.sh /opt/speedtest2mqtt.sh
ADD ./crontab.yml /home/foo/crontab.yml

RUN addgroup -S foo && adduser -S foo -G foo && \
    chmod +x /opt/speedtest2mqtt.sh /opt/entrypoint.sh && \
    chown foo:foo /home/foo/crontab.yml

USER foo
ENTRYPOINT /opt/entrypoint.sh

