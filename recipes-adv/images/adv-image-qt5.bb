DESCRIPTION = "Freescale Image - Adds Qt5"
LICENSE = "MIT"

require recipes-adv/images/adv-image-qt5-validation-imx.bb

CORE_IMAGE_EXTRA_INSTALL += "\
    advantech-initscripts \
    advantech-netboot \
    packagegroup-tools-gears \
    packagegroup-tools-systeminfo \
    packagegroup-tools-networkinfo \
    packagegroup-tools-terminal \
    u-boot-fw-utils \
    "

CORE_IMAGE_EXTRA_INSTALL += "\
    advantech-autobrightness \
    advantech-egalax-fw \
    "

CORE_IMAGE_EXTRA_INSTALL += "\
    advantech-hpattern \
    iperf \
    fbida \
    parted \
    stress \
    dhcp-server \
    dhcp-client \
    "
CORE_IMAGE_EXTRA_INSTALL += "\
	xterm \
	twm \
	xserver-xorg \
	xclock \
	xserver-nodm-init \
	xsetroot \
	"
IMAGE_OVERHEAD_FACTOR = "1.6"