#!/bin/sh

logFile=/home/root/bootCount.tt
adv_hctosys_sleep_time=600
bootCountFile=/home/root/S98advboot
installPath=/etc/rc5.d/S98advboot

bootCount()
{

	if [ -e ${logFile} ] ; then 
		logNu=`cat ${logFile}`
		countNu=$((${logNu}+1))
		echo ${countNu} > ${logFile}
	else
		touch ${logFile}
		echo "1" > ${logFile}
	fi
}

adv_hctosys()
{
	#echo "adv_hctosys -- sync every " ${adv_hctosys_sleep_time} " seconds"

	while :
	do
		sleep ${adv_hctosys_sleep_time}
		hwclock -s -u
	done
}


bootCount
adv_hctosys&
