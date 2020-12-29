#!/bin/bash
echo "docker container has been started"
CRON=${CRON:-0 0,6,12,18 * * *}

declare -p | grep -Ev 'BASHOPTS|BASH_VERSINFO|EUID|PPID|SHELLOPTS|UID' > /var/tmp/container.env

touch /var/tmp/cron.log

echo "setting up cron ${CRON}"
echo "SHELL=/bin/bash
BASH_ENV=/var/tmp/container.env
${CRON} /opt/speedtest2mqtt.sh >> /var/tmp/cron.log 2>&1
# This extra line makes it a valid cron" > /var/tmp/scheduler.txt
crontab -u foo /var/tmp/scheduler.txt

echo "starting cron"
cron && tail -f /var/tmp/cron.log

