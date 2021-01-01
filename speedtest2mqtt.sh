#!/bin/bash
MQTT_HOST=${MQTT_HOST:-localhost}
MQTT_ID=${MQTT_ID:-speedtest2mqtt}
MQTT_TOPIC=${MQTT_TOPIC:-speedtest}
MQTT_OPTIONS=${MQTT_OPTIONS:-"-r"}
MQTT_USER=${MQTT_USER:-user}
MQTT_PASS=${MQTT_PASS:-pass}

file=~/ookla.json

echo "$(date -Iseconds) starting speedtest"

speedtest --accept-license --accept-gdpr -f json-pretty > ${file}

downraw=$(jq -r '.download.bandwidth' ${file})
download=$(printf %.2f\\n "$((downraw * 8))e-6")
upraw=$(jq -r '.upload.bandwidth' ${file})
upload=$(printf %.2f\\n "$((upraw * 8))e-6")
ping=$(jq -r '.ping.latency' ${file})
jitter=$(jq -r '.ping.jitter' ${file})
packetloss=$(jq -r '.packetLoss' ${file})
serverid=$(jq -r '.server.id' ${file})
servername=$(jq -r '.server.name' ${file})
servercountry=$(jq -r '.server.country' ${file})
serverlocation=$(jq -r '.server.location' ${file})
serverhost=$(jq -r '.server.host' ${file})
timestamp=$(jq -r '.timestamp' ${file})

echo "$(date -Iseconds) speedtest results"

echo "$(date -Iseconds) download = ${download} Mbps"
echo "$(date -Iseconds) upload =  ${upload} Mbps"
echo "$(date -Iseconds) ping =  ${ping} ms"
echo "$(date -Iseconds) jitter = ${jitter} ms"

echo "$(date -Iseconds) sending results to ${MQTT_HOST} as clientID ${MQTT_ID} with options ${MQTT_OPTIONS} using user ${MQTT_USER}"

/usr/bin/mosquitto_pub -h ${MQTT_HOST} -i ${MQTT_ID} ${MQTT_OPTIONS} -u ${MQTT_USER} -P ${MQTT_PASS} -t ${MQTT_TOPIC}/download -m "${download}"
/usr/bin/mosquitto_pub -h ${MQTT_HOST} -i ${MQTT_ID} ${MQTT_OPTIONS} -u ${MQTT_USER} -P ${MQTT_PASS} -t ${MQTT_TOPIC}/upload -m "${upload}"
/usr/bin/mosquitto_pub -h ${MQTT_HOST} -i ${MQTT_ID} ${MQTT_OPTIONS} -u ${MQTT_USER} -P ${MQTT_PASS} -t ${MQTT_TOPIC}/ping -m "${ping}"
/usr/bin/mosquitto_pub -h ${MQTT_HOST} -i ${MQTT_ID} ${MQTT_OPTIONS} -u ${MQTT_USER} -P ${MQTT_PASS} -t ${MQTT_TOPIC}/jitter -m "${jitter}"
/usr/bin/mosquitto_pub -h ${MQTT_HOST} -i ${MQTT_ID} ${MQTT_OPTIONS} -u ${MQTT_USER} -P ${MQTT_PASS} -t ${MQTT_TOPIC}/packetloss -m "${packetloss}"

/usr/bin/mosquitto_pub -h ${MQTT_HOST} -i ${MQTT_ID} ${MQTT_OPTIONS} -u ${MQTT_USER} -P ${MQTT_PASS} -t ${MQTT_TOPIC}/server/id -m "${serverid}"
/usr/bin/mosquitto_pub -h ${MQTT_HOST} -i ${MQTT_ID} ${MQTT_OPTIONS} -u ${MQTT_USER} -P ${MQTT_PASS} -t ${MQTT_TOPIC}/server/name -m "${servername}"
/usr/bin/mosquitto_pub -h ${MQTT_HOST} -i ${MQTT_ID} ${MQTT_OPTIONS} -u ${MQTT_USER} -P ${MQTT_PASS} -t ${MQTT_TOPIC}/server/location -m "${serverlocation}"
/usr/bin/mosquitto_pub -h ${MQTT_HOST} -i ${MQTT_ID} ${MQTT_OPTIONS} -u ${MQTT_USER} -P ${MQTT_PASS} -t ${MQTT_TOPIC}/server/host -m "${serverhost}"
/usr/bin/mosquitto_pub -h ${MQTT_HOST} -i ${MQTT_ID} ${MQTT_OPTIONS} -u ${MQTT_USER} -P ${MQTT_PASS} -t ${MQTT_TOPIC}/server/country -m "${servercountry}"

/usr/bin/mosquitto_pub -h ${MQTT_HOST} -i ${MQTT_ID} ${MQTT_OPTIONS} -u ${MQTT_USER} -P ${MQTT_PASS} -t ${MQTT_TOPIC}/timestamp -m "${timestamp}"
