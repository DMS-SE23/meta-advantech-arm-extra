DESCRIPTION = "Freescale Image - Adds Qt5"
LICENSE = "MIT"

#require recipes-adv/images/adv-image-qt5-validation-imx.bb

inherit core-image
inherit distro_features_check
ROOTFS_POSTPROCESS_COMMAND += "install_emmc_download_images"
CORE_IMAGE_EXTRA_INSTALL += " \
	advantech-emmc-download \
	e2fsprogs \
	dosfstools \
	util-linux \
    "
install_emmc_download_images() {
	install -d ${IMAGE_ROOTFS}/emmc
	
	install -m 0644 ${DEPLOY_DIR_IMAGE}/u-boot.imx ${IMAGE_ROOTFS}/emmc/u-boot.imx
	install -m 0644 ${DEPLOY_DIR_IMAGE}/zImage ${IMAGE_ROOTFS}/emmc/zImage
	install -m 0644 ${DEPLOY_DIR_IMAGE}/zImage-imx6dl-dmsse23.dtb ${IMAGE_ROOTFS}/emmc/imx6dl-dmsse23.dtb
	install -m 0644 ${DEPLOY_DIR_IMAGE}/adv-image-qt5-imx6dl-dmsse23.ext4	${IMAGE_ROOTFS}/emmc/adv-image-qt5-imx6dl-dmsse23.ext4

	sha256sum ${IMAGE_ROOTFS}/emmc/u-boot.imx | awk '{print $1}' > ${IMAGE_ROOTFS}/emmc/u-boot.imx.sha256sum
	sha256sum ${IMAGE_ROOTFS}/emmc/zImage | awk '{print $1}' > ${IMAGE_ROOTFS}/emmc/zImage.sha256sum
	sha256sum ${IMAGE_ROOTFS}/emmc/imx6dl-dmsse23.dtb | awk '{print $1}' > ${IMAGE_ROOTFS}/emmc/imx6dl-dmsse23.dtb.sha256sum
	sha256sum ${IMAGE_ROOTFS}/emmc/adv-image-qt5-imx6dl-dmsse23.ext4 | awk '{print $1}' > ${IMAGE_ROOTFS}/emmc/adv-image-qt5-imx6dl-dmsse23.ext4.sha256sum

}

DISTRO_FEATURES_remove = " x11 wayland bluetooth"
IMAGE_OVERHEAD_FACTOR = "1.6"