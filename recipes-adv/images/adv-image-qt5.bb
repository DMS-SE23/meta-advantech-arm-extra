DESCRIPTION = "Freescale Image - Adds Qt5"
LICENSE = "MIT"

require recipes-adv/images/adv-image-qt5-validation-imx.bb

CORE_IMAGE_EXTRA_INSTALL += "\
    advantech-initscripts \
    "

CORE_IMAGE_EXTRA_INSTALL += "\
    advantech-autobrightness \
    "

CORE_IMAGE_EXTRA_INSTALL += "\
    advantech-hpattern \
    iperf \
    fbida \
    parted \
    stress \
    "
