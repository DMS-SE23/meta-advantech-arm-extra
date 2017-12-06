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

bootloader(){
    echo -e "[EMMC-Download]: Downloading booloader...\c" | tee /dev/kmsg | tee /dev/tty0
    retval=1
    BOOTLOADER_PATH=${SOURCE_DIR}/${BOOTLOADER_FILE}
    SPI_ROM=/dev/mtdblock0

    if [ ! -e ${BOOTLOADER_PATH} ]; then
        echo "[EMMC-Download]: Bootloader file not found!" | tee /dev/kmsg | tee /dev/tty0
        retval=1
    fi

    if [ ! -e ${SPI_ROM} ]; then
        echo "[EMMC-Download]: SPI_ROM device not found!" | tee /dev/kmsg | tee /dev/tty0
        retval=1
    else
        retval=0
    fi

    if [ ${retval} -eq 0 ]; then
        for i in ${TRY_ERROR}
        do
            dd if=${BOOTLOADER_PATH} of=${SPI_ROM} bs=512 seek=2
            if [ $? -ne 0 ]; then
                echo "[EMMC-Download]: dd failed\n" | tee /dev/kmsg | tee /dev/tty0
            else
                echo "[EMMC-Download]: u-boot download OK." | tee /dev/kmsg | tee /dev/tty0

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
    echo -e "[EMMC-Download]: Coping boot files...\c" | tee /dev/kmsg | tee /dev/tty0
    TARGET_DIR=p1
    retval=1
    
    if [ ! -e ${EMMC_BOOT_PATH} ]; then
        echo "[EMMC-Download]:Bootloader file not found!" | tee /dev/kmsg | tee /dev/tty0
        return 1
    fi
    
    mkdir ${TARGET_DIR}
    mount -t vfat ${EMMC_BOOT_PATH} ${TARGET_DIR}
    if [ $? -ne 0 ]; then
        echo "[EMMC-Download]: Fail to mount emmc boot partition!" | tee /dev/kmsg | tee /dev/tty0
        return 1
    fi
    
    for i in ${TRY_ERROR}
    do
        cp ${SOURCE_DIR}/${DTB_FILE} ${TARGET_DIR}/
        if [ $? -ne 0 ] || [ ! -e "${TARGET_DIR}/${DTB_FILE}" ]; then
            echo -e "[EMMC-Download]: Copy boot dtb file failed\c" | tee /dev/kmsg | tee /dev/tty0
        else
            echo -e "[EMMC-Download]: copy dtb OK.\c" | tee /dev/kmsg | tee /dev/tty0
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
            echo "[EMMC-Download]: Copy boot file failed" | tee /dev/kmsg | tee /dev/tty0
        else
            echo "[EMMC-Download]: copy boot file OK." | tee /dev/kmsg | tee /dev/tty0
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
    echo "[EMMC-Download]: Copy bootfs..." | tee /dev/kmsg | tee /dev/tty0
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
        echo "[EMMC-Download]: File not found:"${EMMC_ROOTFS_PATH} | tee /dev/kmsg | tee /dev/tty0
        return 1
    fi
    
    mount -t ext4 ${EMMC_ROOTFS_PATH} ${TARGET_PATH}
    if [ $? -ne 0 ]; then
        echo "[EMMC-Download]: EMMC partition mount failed" | tee /dev/kmsg | tee /dev/tty0
        return 1
    fi
    
    mount ${SOURCE_DIR}/${ROOTFS_FILE} ${SOURCE_PATH}
    if [ $? -ne 0 ]; then
        umount ${TARGET_PATH}
        echo "[EMMC-Download]: Rootfs file mount failed" | tee /dev/kmsg | tee /dev/tty0
        return 1
    fi
    
    
    for i in ${TRY_ERROR}
    do
        cp -R ${SOURCE_PATH}/* ${TARGET_PATH}/
        if [ $? -ne 0 ]; then
            echo "[EMMC-Download]: Copy rootfs file failed\n" | tee /dev/kmsg | tee /dev/tty0
        else
            echo "[EMMC-Download]: Copy rootfs ok!" | tee /dev/kmsg | tee /dev/tty0
			echo "[EMMC-Download]: Done and Success!" | tee /dev/kmsg | tee /dev/tty0
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
        echo "EMMC-Download]: Bootloader file: "${SOURCE_DIR}/${BOOTLOADER_FILE}" not found!" | tee /dev/kmsg | tee /dev/tty0
        return 1
    fi
    
    if [ ! -e ${SOURCE_DIR}/${DTB_FILE} ]; then
        echo "EMMC-Download]: DTB file not found!" | tee /dev/kmsg | tee /dev/tty0
        return 1
    fi
    
    if [ ! -e ${SOURCE_DIR}/${BOOT_FILE} ]; then
        echo "EMMC-Download]: Boot file not found!" | tee /dev/kmsg | tee /dev/tty0
        return 1
    fi
    
    if [ ! -e ${SOURCE_DIR}/${ROOTFS_FILE} ]; then
        echo "EMMC-Download: Rootfs file not found!" | tee /dev/kmsg | tee /dev/tty0
        return 1
    fi
    return 0;
}

main(){
    # Preparing for backup block

    echo "[EMMC-Download]: Preparing for backup block" | tee /dev/kmsg | tee /dev/tty0

    
    validateSourceFile
    if [ $? -ne 0 ]; then
        #clean
        return 1
    fi

    # Bootloader
    bootloader
    retval=$?
    if [ ${retval} -ne 0 ]; then
        return 1
    fi
    
    # Do file system

    echo "[EMMC-Download]: Do EMMC file system..." | tee /dev/kmsg | tee /dev/tty0
	dd if=/dev/zero of=${EMMC_PATH}  bs=1M  count=10
	
    echo "[Do EMMC file system]..." | tee /dev/kmsg | tee /dev/tty0
    echo -e "n\np\n1\n2048\n260096\nn\np\n2\n\n\nw" | fdisk ${EMMC_PATH}
    mkfs.vfat ${EMMC_BOOT_PATH}
    mkfs.ext4  ${EMMC_ROOTFS_PATH}
    
    # Copy zImage dtb
    bootimage
	
    if [ $? -ne 0 ]; then
        return 1
    fi
    
    # Copy rootfs
    rootfs
	
}

main
