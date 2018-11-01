SUMMARY = "Advantech netboot scripts"
DESCRIPTION = "Initscripts provided by advantech for board support package."
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${WORKDIR}/README;md5=3d14358d5cb9cd537bab2028270080bc"
DEPENDS += "u-boot-imx"
DEPENDS += "initscripts"
RDEPENDS_${PN} += "bash"
SRC_URI = "git://github.com/DMS-SE23/uboot-imx.git;protocol=http;branch=DMS-SE23 \
           file://emmcboot.sh \
           file://netboot.sh \
           file://README"

inherit update-alternatives systemd
DEPENDS_append = " update-rc.d-native"
DEPENDS_append = " ${@bb.utils.contains('DISTRO_FEATURES','systemd','systemd-systemctl-native','',d)}"

SRCREV = "${AUTOREV}"

do_compile() {
	unset LDFLAGS
	unset CFLAGS
	unset CPPFLAGS
cd ..
cd git
export LOADADDR=0x10008000
export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabi-
make distclean
make mx6dldmsse23_netboot_defconfig
make -j1
cp u-boot.imx ../netboot.imx

export LOADADDR=0x10008000
export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabi-
make distclean
make mx6dldmsse23_defconfig
make -j1
cp u-boot.imx ../u-boot.imx
}

do_install () {

	install -d ${D}/${bindir}
	install -m 0777		${WORKDIR}/netboot.sh		${D}/${bindir}/netboot

	install -d ${D}/${sysconfdir}/uboot
	install -m 0777		${WORKDIR}/netboot.imx		${D}${sysconfdir}/uboot
	install -m 0777		${WORKDIR}/u-boot.imx 		${D}${sysconfdir}/uboot
#
# Create directories and install device independent scripts
#
	install -d ${D}${sysconfdir}/init.d
	install -d ${D}${sysconfdir}/rcS.d
	install -d ${D}${sysconfdir}/rc0.d
	install -d ${D}${sysconfdir}/rc1.d
	install -d ${D}${sysconfdir}/rc2.d
	install -d ${D}${sysconfdir}/rc3.d
	install -d ${D}${sysconfdir}/rc4.d
	install -d ${D}${sysconfdir}/rc5.d
	install -d ${D}${sysconfdir}/rc6.d
	install -m 0775    ${WORKDIR}/emmcboot.sh	${D}${sysconfdir}/init.d

# Create runlevel links
	update-rc.d -r ${D} emmcboot.sh start 99 2 3 4 5 .

}
FILES_${PN} = "${sysconfdir}/* \
			/emmc/*  \
			${sysconfdir}/uboot/* \
			${bindir}/netboot "
