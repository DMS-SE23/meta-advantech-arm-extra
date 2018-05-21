SUMMARY = "Advantech emmc download scripts"
DESCRIPTION = "Initscripts provided by advantech for board support package."
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${WORKDIR}/README;md5=3d14358d5cb9cd537bab2028270080bc"

DEPENDS += "initscripts"

SRC_URI = "file://emmc-download.sh \
           file://README"
		   
		   
		   
inherit update-alternatives systemd
DEPENDS_append = " update-rc.d-native"
DEPENDS_append = " ${@bb.utils.contains('DISTRO_FEATURES','systemd','systemd-systemctl-native','',d)}"



do_install () {


	
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
	install -m 0775    ${WORKDIR}/emmc-download.sh	${D}${sysconfdir}/init.d
	
# Create runlevel links
	update-rc.d -r ${D} emmc-download.sh start 99 2 3 4 5 .
	
	
}
FILES_${PN} = "${sysconfdir}/*"
FILES_${PN} += "/emmc/* "
