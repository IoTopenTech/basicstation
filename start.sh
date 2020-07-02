#!/usr/bin/env bash


# declare map of hardware pins to GPIO on Raspberry Pi
declare -a pinToGPIO
pinToGPIO=( -1 -1 -1 2 -1 3 -1 4 14 -1 15 17 18 27 -1 22 23 -1 24 10 -1 9 25 11 8 -1 7 0 1 5 -1 6 12 13 -1 19 16 26 20 -1 21)


cd examples/live-s2.sm.tc

# Default to TTN server
TC_URI=${TC_URI:-"wss://lns.eu.thethings.network:443"} 
TC_TRUST=${TC_TRUST:-$(curl https://letsencrypt.org/certs/trustid-x3-root.pem.txt)}

# Introduce the EUI from the mac address as a balenaCloud TAG
TAG_KEY= "TTN_EUI"
TTN_EUI= $(cat /sys/class/net/eth0/address | sed -r 's/[:]+//g' | sed -e 's#\(.\{6\}\)\(.*\)#\1FFFE\2#g')

ID=$(curl -sX GET "https://api.balena-cloud.com/v5/device?\$filter=uuid%20eq%20'$BALENA_DEVICE_UUID'" \
-H "Content-Type: application/json" \
-H "Authorization: Bearer $BALENA_API_KEY" | \
jq ".d | .[0] | .id")

curl -sX POST \
"https://api.balena-cloud.com/v5/device_tag" \
-H "Content-Type: application/json" \
-H "Authorization: Bearer $BALENA_API_KEY" \
--data "{ \"device\": \"$ID\", \"tag_key\": \"$TAG_KEY\", \"value\": \"$TTN_EUI\" }" > /dev/null


GW_RESET_PIN=${GW_RESET_PIN:-11}
GW_RESET_GPIO=${GW_RESET_GPIO:-${pinToGPIO[$GW_RESET_PIN]}}

# Setup TC files from environment
echo $TC_URI > tc.uri
echo "$TC_TRUST" > tc.trust

# Reset gateway
echo "Resetting gateway concentrator on GPIO $GW_RESET_GPIO"
echo $GW_RESET_GPIO > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio$GW_RESET_GPIO/direction
echo 0 > /sys/class/gpio/gpio$GW_RESET_GPIO/value
echo 1 > /sys/class/gpio/gpio$GW_RESET_GPIO/value
echo 0 > /sys/class/gpio/gpio$GW_RESET_GPIO/value
echo $GW_RESET_GPIO > /sys/class/gpio/unexport

RADIODEV=/dev/spidev0.0 ../../build-rpi-std/bin/station 

