DESCRIPTION = "Freescale Image - Adds Qt5"
LICENSE = "MIT"

#require recipes-adv/images/adv-image-qt5-validation-imx.bb

inherit core-image
inherit distro_features_check
CORE_IMAGE_EXTRA_INSTALL += " \
	advantech-emmc-download \
	e2fsprogs \
	dosfstools \
	util-linux \
    "
DISTRO_FEATURES_remove = " x11 wayland bluetooth"

IMAGE_FSTYPES += "sdcard.sha256sum"