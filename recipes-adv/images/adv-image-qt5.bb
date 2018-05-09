DESCRIPTION = "Freescale Image - Adds Qt5"
LICENSE = "MIT"

require recipes-adv/images/adv-image-qt5-validation-imx.bb

CORE_IMAGE_EXTRA_INSTALL += "\
    advantech-initscripts \
    advtest-burnin \
    advtest-factory \
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
