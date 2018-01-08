#!/bin/bash

if [ -e /etc/battery_monitor.sh ]; then
	echo "start the battery monitor service"
	source /etc/battery_monitor.sh &
fi
