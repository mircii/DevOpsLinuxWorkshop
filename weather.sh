#!/bin/bash

set -euo pipefail

LOG_FILE="/var/log/weather.log"

source /etc/default/weather

if [ -z "$CITY" ]; then
  CITY="Timisoara"
fi

HOSTNAME=$(hostname)
DATE=$(date)
WEATHER=$(curl -s "https://wttr.in/$CITY?format=1")
UPTIME=$(uptime -p)
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5 " used on " $1}')
CPU_LOAD=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4 "%"}')

MOTD_CONTENT=$(cat <<EOF

~~~~~~~~~~~~Welcome to the Almighty Linux VM~~~~~~~~~~~~

City: $CITY
Weather: $WEATHER
Hostname: $HOSTNAME
Time: $DATE
Uptime: $UPTIME
Disk Usage: $DISK_USAGE
CPU Load: $CPU_LOAD

Hint: Grab a beer and get coding !! xD

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
********************************************************
________________________________________________________
 __    __     __     ______     ______     __     __
/\ "-./  \   /\ \   /\  == \   /\  ___\   /\ \   /\ \
\ \ \-./\ \  \ \ \  \ \  __<   \ \ \____  \ \ \  \ \ \
 \ \_\ \ \_\  \ \_\  \ \_\ \_\  \ \_____\  \ \_\  \ \_\
  \/_/  \/_/   \/_/   \/_/ /_/   \/_____/   \/_/   \/_/
________________________________________________________
********************************************************
--------------------------------------------------------

EOF
)

echo "$MOTD_CONTENT" | sudo tee /etc/motd > /dev/null

echo "[$DATE] Weather fetched for $CITY: $WEATHER" | sudo tee -a $LOG_FILE > /dev/null
