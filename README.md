# speedtest2mqtt

Alpine-based docker to push Ookla Speedtest results to a MQTT Server.

## Environment Variables

    CRON (Default '0 0,6,12,18 * * *' -> run speedtest 4 times a day )
    MQTT_HOST (Default 'localhost')
    MQTT_ID (Default 'speedtest2mqtt')
    MQTT_TOPIC (Default 'speedtest')
    MQTT_OPTIONS (Default '-r')
    MQTT_USER (Default 'user')
    MQTT_PASS (Default 'pass')

## Examples

#### docker-compose.yml

```
version: "3"

services:

  speedtest:
    image: moafrancky/speedtest2mqtt:latest
    container_name: speedtest2mqtt
    environment:
      - MQTT_HOST=192.168.100.100
    restart: unless-stopped
```

#### docker 

```
docker run -d --env-file ./env.list moafrancky/speedtest2mqtt:latest
```

with env.list

```
MQTT_HOST=192.168.100.100
MQTT_ID=speedtest2mqtt
MQTT_TOPIC=speedtest
MQTT_OPTIONS=-r
MQTT_USER=user
MQTT_PASS=changeme
CRON=0 * * * *
```

## Note

This docker image uses [ookla speedtest cli](https://www.speedtest.net/fr/apps/cli) and automatically 
accepts Ookla License and GDPR terms.
 
## Ookla speedtest License

You may only use this Speedtest software and information generated from it for personal, non-commercial use, through a command line interface on a personal computer. Your use of this software is subject to the End User License Agreement, Terms of Use and Privacy Policy at these URLs:

https://www.speedtest.net/about/eula
https://www.speedtest.net/about/terms
https://www.speedtest.net/about/privacy

## Ookla speedtest GDPR

Ookla collects certain data through Speedtest that may be considered
personally identifiable, such as your IP address, unique device
identifiers or location. Ookla believes it has a legitimate interest
to share this data with internet providers, hardware manufacturers and
industry regulators to help them understand and create a better and
faster internet. For further information including how the data may be
shared, where the data may be transferred and Ookla's contact details,
please see our Privacy Policy at:

http://www.speedtest.net/privacy