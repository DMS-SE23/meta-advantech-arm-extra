#!/bin/sh

CAL="200"
LUX="1"
RESULT="0"

function init_test() {
	BL_ENABLE=$(cat "/proc/adv_input_manager/light_en")
	BL_CONTORL=$(cat "/proc/adv_input_manager/control_bl")
	echo close...BL
	echo "0" > "/proc/adv_input_manager/control_bl"
	echo "0" > "/proc/adv_input_manager/light_en"
	echo "5" > "/sys/class/backlight/backlight/brightness"
	BL_TABLE=$(cat "/proc/adv_input_manager/levels")
	echo BL_TABLE:$BL_TABLE
	echo "[20,100][65000,150]" > "/proc/adv_input_manager/levels"
	NEW_BL_TABLE=($(cat "/proc/adv_input_manager/levels"))
	echo NEW_BL_TABLE:$NEW_BL_TABLE
	BL_RANGE=$(cat "/proc/adv_input_manager/threshold_range")
	echo "10" > "/proc/adv_input_manager/threshold_range"
	ping 127.0.0.1 -c 1 > nul
}

function recover_data() {
	echo "$BL_RANGE" > "/proc/adv_input_manager/threshold_range"
	echo "$BL_TABLE" > "/proc/adv_input_manager/levels"
	echo "$BL_ENABLE" > "/proc/adv_input_manager/light_en"
	echo "$BL_CONTORL" > "/proc/adv_input_manager/control_bl"
}

	if [ -f "/proc/adv_input_manager/lux" ]; then
		LUX=($(cat "/proc/adv_input_manager/lux"))
		#echo LUX:$LUX
		CAL=($(cat "/proc/adv_input_manager/lux200"))
		echo CAL:$CAL
		LUX=$[$[$LUX*200]/$CAL]
		echo LUX:$LUX
		BL=($(cat "/sys/class/backlight/backlight/brightness"))
		echo BL:$BL
		init_test
		BL=($(cat "/sys/class/backlight/backlight/brightness"))
		echo setting BL:$BL
		if [ "$BL" = "5" ]
		then
			echo open...BL
			echo "1" > "/proc/adv_input_manager/control_bl"
			echo "1" > "/proc/adv_input_manager/light_en"
			ping 127.0.0.1 -c 4 > nul
			BL=($(cat "/sys/class/backlight/backlight/brightness"))
			echo new BL:$BL
			if [ "$BL" != "1" ]
			then
				export RESULT="1"
			fi
		fi
		if [ "$RESULT" = "1" ]
		then
			recover_data
			echo "auto brightness work"
			echo "PASS"
		else
			recover_data
			echo "Light Sensor can't work"
			echo "FAIL"
		fi
	else
		recover_data
		echo "Light Sensor node is not exist"
		echo "FAIL"
	fi
