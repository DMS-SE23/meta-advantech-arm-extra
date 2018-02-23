#!/bin/bash
TRY_ERROR=`seq 0 1 2`

EMMC_PATH=/dev/mmcblk2
EMMC_BOOT_PATH=/dev/mmcblk2p1
EMMC_ROOTFS_PATH=/dev/mmcblk2p2

SOURCE_DIR=/emmc


BOOTLOADER_FILE=u-boot.imx
DTB_FILE=imx6dl-dmsse23.dtb
BOOT_FILE=zImage
ROOTFS_FILE=adv-image-qt5-imx6dl-dmsse23.ext4

#clean(){
#   umount ${SOURCE_DIR}
#   cd
#   rm ${TMP_FOLDER} -rf
#}


printlog(){
    echo "$1" | tee /dev/tty0
}

bootloader(){
    printlog "[EMMC-Download]: Downloading booloader..."
    retval=1
    BOOTLOADER_PATH=${SOURCE_DIR}/${BOOTLOADER_FILE}
    SPI_ROM=/dev/mtdblock0

    if [ ! -e ${BOOTLOADER_PATH} ]; then
        printlog "[EMMC-Download]: Bootloader file not found!"
        retval=1
    fi

    if [ ! -e ${SPI_ROM} ]; then
        printlog "[EMMC-Download]: SPI_ROM device not found!"
        retval=1
    else
        retval=0
    fi

    if [ ${retval} -eq 0 ]; then
        for i in ${TRY_ERROR}
        do
            dd if=${BOOTLOADER_PATH} of=${SPI_ROM} bs=512 seek=2
            if [ $? -ne 0 ]; then
                printlog "[EMMC-Download]: dd failed\n"
            else
                printlog "[EMMC-Download]: u-boot download OK."

                retval=0
                break
            fi
        done
    else
        return 1
    fi

    if [ ${retval} -ne 0 ]; then
        #clean
        return 1
    else
        return 0
    fi
}

bootimage(){
    printlog  "[EMMC-Download]: Coping boot files..."
    TARGET_DIR=p1
    retval=1
    
    if [ ! -e ${EMMC_BOOT_PATH} ]; then
        printlog "[EMMC-Download]:Bootloader file not found!"
        return 1
    fi
    
    mkdir ${TARGET_DIR}
    mount -t vfat ${EMMC_BOOT_PATH} ${TARGET_DIR}
    if [ $? -ne 0 ]; then
        printlog "[EMMC-Download]: Fail to mount emmc boot partition!"
        return 1
    fi
    
    for i in ${TRY_ERROR}
    do
        cp ${SOURCE_DIR}/${DTB_FILE} ${TARGET_DIR}/
        if [ $? -ne 0 ] || [ ! -e "${TARGET_DIR}/${DTB_FILE}" ]; then
            printlog "[EMMC-Download]: Copy boot dtb file failed"
        else
            printlog "[EMMC-Download]: Copy dtb OK."
            retval=0
            break
        fi
    done
    
    if [ ${retval} -ne 0 ]; then
        #umount ${TARGET_DIR}
        #clean
        return 1
    fi
    
    for i in ${TRY_ERROR}
    do
        cp ${SOURCE_DIR}/${BOOT_FILE} ${TARGET_DIR}/
        if [ $? -ne 0 ] || [ ! -e "${TARGET_DIR}/${BOOT_FILE}" ]; then
            printlog "[EMMC-Download]: Copy boot file failed"
        else
            printlog "[EMMC-Download]: Copy boot file OK."
            retval=0
            break
        fi
    done
    
    #umount ${TARGET_DIR}
    if [ ${retval} -ne 0 ]; then
        #clean
        return 1
    else 
        return 0
    fi
}

rootfs(){
    printlog "[EMMC-Download]: Create rootfs..."
    TARGET_PATH=p2
    SOURCE_PATH=s2
    
    retval=1

    if [ -e ${TARGET_PATH} ]; then
        rm -rf ${TARGET_PATH}
    fi

    if [ -e ${SOURCE_PATH} ]; then
        rm -rf ${SOURCE_PATH}
    fi
    
    mkdir ${TARGET_PATH}
    mkdir ${SOURCE_PATH}
    
    if [ ! -e ${EMMC_ROOTFS_PATH} ] || [ ! -e ${TARGET_PATH} ]; then
        printlog "[EMMC-Download]: File not found:"${EMMC_ROOTFS_PATH}
        return 1
    fi

    printlog "[EMMC-Download]: Mount rootfs partition..."
    mount -t ext4 ${EMMC_ROOTFS_PATH} ${TARGET_PATH}
    if [ $? -ne 0 ]; then
        printlog "[EMMC-Download]: rootfs partition mount failed"
        return 1
    fi
    
    printlog "[EMMC-Download]: Mount rootfs file..."
    mount ${SOURCE_DIR}/${ROOTFS_FILE} ${SOURCE_PATH}
    if [ $? -ne 0 ]; then
        umount ${TARGET_PATH}
        printlog "[EMMC-Download]: rootfs file mount failed"
        return 1
    fi
    
    printlog "[EMMC-Download]: Copy rootfs..."
    for i in ${TRY_ERROR}
    do
        cp -R ${SOURCE_PATH}/* ${TARGET_PATH}/
        if [ $? -ne 0 ]; then
            printlog "[EMMC-Download]: Copy rootfs file failed"
            printlog "[EMMC-Download]: Please check SD image!"
            read -rsp $'press any key...'
        else
            printlog "[EMMC-Download]: Copy rootfs ok!"
            printlog "[EMMC-Download]: Done and Success!"
            printlog "[EMMC-Download]: Please remove SD Card and reboot device!"
            read -rsp $'press any key...'
            retval=0
            break
        fi
    done
    
    umount ${TARGET_PATH}
    umount ${SOURCE_PATH}
	
	return 0;
		
}

validateSourceFile(){
    if [ ! -e ${SOURCE_DIR}/${BOOTLOADER_FILE} ]; then
        printlog "[EMMC-Download]: Bootloader file: "${SOURCE_DIR}/${BOOTLOADER_FILE}" not found!"
        return 1
    fi
    
    if [ ! -e ${SOURCE_DIR}/${DTB_FILE} ]; then
        printlog "[EMMC-Download]: DTB file not found!"
        return 1
    fi
    
    if [ ! -e ${SOURCE_DIR}/${BOOT_FILE} ]; then
        printlog "[EMMC-Download]: Boot file not found!"
        return 1
    fi
    
    if [ ! -e ${SOURCE_DIR}/${ROOTFS_FILE} ]; then
        printlog "[EMMC-Download]: Rootfs file not found!"
        return 1
    fi
    return 0;
}

checksum(){
	zImage_check=$(sha256sum "/emmc/zImage" | awk '{print $1}')
	zImage_sha256=$(cat "/emmc/zImage.sha256sum")
	if [ "$zImage_check" = "$zImage_sha256" ]; then
		printlog "[EMMC-Download]:zImage verifying checksum PASS"
	else
		printlog "[EMMC-Download]:zImage verifying checksum FAIL, please check SD image"
		exit;
	fi

	uboot_check=$(sha256sum "/emmc/u-boot.imx" | awk '{print $1}')
	uboot_sha256=$(cat "/emmc/u-boot.imx.sha256sum")
	if [ "$uboot_check" = "$uboot_sha256" ]; then
		printlog "[EMMC-Download]:u-boot verifying checksum PASS"
	else
		printlog "[EMMC-Download]:u-boot verifying checksum FAIL, please check SD image"
		exit;
	fi

	dtb_check=$(sha256sum "/emmc/imx6dl-dmsse23.dtb" | awk '{print $1}')
	dtb_sha256=$(cat "/emmc/imx6dl-dmsse23.dtb.sha256sum")
	if [ "$dtb_check" = "$dtb_sha256" ]; then
		printlog "[EMMC-Download]:dtb verifying checksum PASS"
	else
		printlog "[EMMC-Download]:dtb verifying checksum FAIL, please check SD image"
		exit;
	fi

	# check rootfs spent a lot of time and checksum will change after mount
#	rootfs_check=$(sha256sum "/emmc/adv-image-qt5-imx6dl-dmsse23.ext4" | awk '{print $1}')
#	rootfs_sha256=$(cat "/emmc/adv-image-qt5-imx6dl-dmsse23.ext4.sha256sum")
#	if [ "$rootfs_check" = "$rootfs_sha256" ]; then
#		printlog "[EMMC-Download]:ext4 verifying checksum PASS"
#	else
#		printlog "[EMMC-Download]:ext4 verifying checksum FAIL, please check SD image"
#		exit;
#	fi
	return 0;
}

main(){
    # Preparing for backup block
    echo "" | tee /dev/tty0
    echo "" | tee /dev/tty0

	checksum

    printlog "[EMMC-Download]: Preparing for backup block"

    
    validateSourceFile
    if [ $? -ne 0 ]; then
        #clean
        printlog "[EMMC-Download]: Please check SD image!"
		read -rsp $'press any key...'
        return 1
    fi

    # Bootloader
    bootloader
    retval=$?
    if [ ${retval} -ne 0 ]; then
        printlog "[EMMC-Download]: Please check SD image!"
        read -rsp $'press any key...'
        return 1
    fi
    
    # Do file system

    printlog "[EMMC-Download]: Do EMMC file system..."
    dd if=/dev/zero of=${EMMC_PATH}  bs=1M  count=10

    printlog "[EMMC-Download]: Format EMMC..."
    echo -e "n\np\n1\n2048\n260096\nn\np\n2\n\n\nw" | fdisk ${EMMC_PATH}
    mkfs.vfat  ${EMMC_BOOT_PATH}
    mkfs.ext4 -F ${EMMC_ROOTFS_PATH}
    
    # Copy zImage dtb
    bootimage

    if [ $? -ne 0 ]; then
        printlog "[EMMC-Download]: Please check SD image!"
        read -rsp $'press any key...'
        return 1
    fi
    
    # Copy rootfs
    rootfs

}

main
