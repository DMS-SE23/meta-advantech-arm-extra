#!/bin/sh

### BEGIN INIT INFO
# Provides:             vpm-amp-mute
# Required-Start:
# Required-Stop:
# Default-Start:        2 3 4 5
# Default-Stop:
### END INIT INFO

VPM_INIT_AMP_MODE="/sys/devices/soc0/soc/2100000.aips-bus/21a0000.i2c/i2c-0/0-0068/vpm_amp_mute"

if [ -f "$VPM_INIT_AMP_MODE" ]; then
	echo 0 > "$VPM_INIT_AMP_MODE" 
else
	echo "sysfs entry for vpm amp mute is not exist"
fi
