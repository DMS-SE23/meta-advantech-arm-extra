#!/bin/bash

if [ -f "/etc/uboot/enable" ]
then
	dd if=/etc/uboot/u-boot.imx of=/dev/mtdblock0 bs=512 seek=2
	rm -f /etc/uboot/enable
	sync
	echo "u-boot boot from emmc!"
fi

