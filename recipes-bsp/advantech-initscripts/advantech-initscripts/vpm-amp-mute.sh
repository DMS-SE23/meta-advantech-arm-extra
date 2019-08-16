#!/bin/sh

### BEGIN INIT INFO
# Provides:             vpm-amp-mute
# Required-Start:
# Required-Stop:
# Default-Start:        2 3 4 5
# Default-Stop:
### END INIT INFO

VPM_INIT_AMP_CHIP="/sys/devices/soc0/soc/2100000.aips-bus/21a0000.i2c/i2c-0/0-0068/vpm_amp_on"
VPM_INIT_AMP_MODE="/sys/devices/soc0/soc/2100000.aips-bus/21a0000.i2c/i2c-0/0-0068/vpm_amp_mute"

SYSFS_GPIO="/sys/class/gpio"
VPM_NOTIFY_GPIO="16"
VPM_NOTIFY_GPIO_SYSFS="${SYSFS_GPIO}/gpio${VPM_NOTIFY_GPIO}"


echo "${VPM_NOTIFY_GPIO}" > "${SYSFS_GPIO}/export"
sleep 1

if [ -d "${VPM_NOTIFY_GPIO_SYSFS}" ]; then
	echo "notify vpm to stop amp mute"
	
	echo "out" > "${VPM_NOTIFY_GPIO_SYSFS}/direction"
	echo 0 > "${VPM_NOTIFY_GPIO_SYSFS}/value"
	sleep 1
else

	echo "sysfs entry for vpm stop amp mute is not exist"
fi

if [ -f "$VPM_INIT_AMP_CHIP" ]; then
	echo 1 > "$VPM_INIT_AMP_CHIP"
else
	echo "sysfs entry for vpm amp chip is not exist"
fi

if [ -f "$VPM_INIT_AMP_MODE" ]; then
	echo 0 > "$VPM_INIT_AMP_MODE" 
else
	echo "sysfs entry for vpm amp mute is not exist"
fi

