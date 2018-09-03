#!/bin/bash
dd if=/etc/uboot/netboot.imx of=/dev/mtdblock0 bs=512 seek=2
echo 1 > /etc/uboot/enable
sync
echo "u-boot boot from netboot!"
