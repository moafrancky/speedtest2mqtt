#!/bin/bash
CRON=${CRON:-0 0,6,12,18 * * *}
echo "speedtest2mqtt has been started "

declare | grep -Ev 'BASHOPTS|BASH_VERSINFO|EUID|PPID|SHELLOPTS|UID' > /var/tmp/container.env
cp /home/foo/crontab.yml /var/tmp/
sed -i "/schedule/c\    schedule: \"${CRON}\"" /var/tmp/crontab.yml

echo "starting cron (${CRON})"
/yacronenv/bin/yacron -c /var/tmp/crontab.yml
