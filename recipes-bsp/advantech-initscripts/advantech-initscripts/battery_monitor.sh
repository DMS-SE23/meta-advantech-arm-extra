#!/bin/bash

BATT_CHARGING_SYSFS="/sys/class/power_supply/ac/online"
BATT_CAPACITY_SYSFS="/sys/class/power_supply/battery/capacity"
BATT_CAPACITY_THRESHOLD="5"

BATT_MONITOR_TAG="[BATT_MONITOR]"
BATT_MONITOR_PERIOD="10"
BATT_MONITOR_POWEROFF_COUNTDOWN="60"

BATT_MONITOR_LOG_FILE="/etc/battery_capacity.log"
BATT_MONITOR_LOG_EN="/etc/battery_monitor_log_en"
BATT_MONITOR_LOG_OUTPUT="/dev/null"

capacity="0"
charging="0"
count="0"
capacity_begin_charging=""

#======================================================#
# function : read charging status
#======================================================#
function read_charging_status
{
	local chgsts="0"
	
	chgsts=$(cat ${BATT_CHARGING_SYSFS})
	
	if [ "${chgsts}" == "1" ]; then
		charging="1"
	else
		charging="0"
	fi	
}

#======================================================#
# function : read battery capacity
#======================================================#
function read_battery_capacity
{
	capacity=$(cat $BATT_CAPACITY_SYSFS)
}

#======================================================#
# function : setup system log
#======================================================#
function setup_battery_log_output
{
	if [ -e ${BATT_MONITOR_LOG_EN} ]; then
		BATT_MONITOR_LOG_OUTPUT="${BATT_MONITOR_LOG_FILE}"
	else
		BATT_MONITOR_LOG_OUTPUT="/dev/null"
	fi
}

#======================================================#
# function : record charging begin capacity
#======================================================#
function record_charging_begin_capacity
{
	if [ "${capacity_begin_charging}" == "" ]; then
		capacity_begin_charging=$(cat $BATT_CAPACITY_SYSFS)
	fi
}

#======================================================#
# function : countdown system poweroff
#======================================================#
function countdown_system_poweroff
{
	countdown=$(expr ${BATT_MONITOR_POWEROFF_COUNTDOWN} - ${BATT_MONITOR_PERIOD} \* ${count})
	
	if [ "${countdown}" == "0" ]; then
		echo "${BATT_MONITOR_TAG} shutdown system" | tee -a ${BATT_MONITOR_LOG_OUTPUT}
		shutdown -h now
	fi
	
	echo "${BATT_MONITOR_TAG} prepare to shutdown in ${countdown} seconds" | tee -a  ${BATT_MONITOR_LOG_OUTPUT}
	count=$(expr ${count} + 1)
}


#======================================================#
# main function
#======================================================#

# remove the privious log file
if [ -e "${BATT_MONITOR_LOG_FILE}" ]; then
	rm ${BATT_MONITOR_LOG_FILE}
fi

# start the battery monitor service
while true; do

# enable/disable log output
setup_battery_log_output

# read capacity
read_battery_capacity

# check charging status
read_charging_status


if [ "${capacity}" == "Unknown" ]; then
	echo "${BATT_MONITOR_TAG} Unknown battery status" | tee -a ${BATT_MONITOR_LOG_OUTPUT}
else
	if [ "${capacity}" -le "${BATT_CAPACITY_THRESHOLD}" ]; then
		if [ "${charging}" == 1 ]; then
			record_charging_begin_capacity
			
			if [ "${capacity}" -ge "${capacity_begin_charging}" ]; then
				count="0"
				
				#record the higher capacity
				capacity_begin_charging="${capacity}"
				
				echo "${BATT_MONITOR_TAG} charging in the lower battery capacity : ${capacity}%" | tee -a ${BATT_MONITOR_LOG_OUTPUT}
			else
				countdown_system_poweroff
			fi
		else
			capacity_begin_charging=""
			
			countdown_system_poweroff			
		fi
	else
		count="0"
		capacity_begin_charging=""
	
		echo "${BATT_MONITOR_TAG} battery capacity : ${capacity}" >> ${BATT_MONITOR_LOG_OUTPUT}		
	fi
fi

sleep ${BATT_MONITOR_PERIOD}

done
