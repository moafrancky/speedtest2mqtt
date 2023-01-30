#!/bin/bash
CRON=${CRON:-0 0,6,12,18 * * *}
echo "speedtest2mqtt has been started "

declare | grep -Ev 'BASHOPTS|BASH_VERSINFO|EUID|PPID|SHELLOPTS|UID' > /tmp/container.env
cp /home/foo/crontab.yml /tmp/
sed -i "/schedule/c\    schedule: \"${CRON}\"" /tmp/crontab.yml

echo "starting cron (${CRON})"
/yacronenv/bin/yacron -c /tmp/crontab.yml
