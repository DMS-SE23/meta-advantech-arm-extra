#FILESEXTRAPATHS_prepend_poky := "${THISDIR}/files:"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://psplash-poky-img.h \
            file://0001-DMS-SE23-modify-the-boot-logo-by-customer-s-requirme.patch"

SPLASH_IMAGES_append = "file://psplash-poky-img.h;outsuffix=default"

