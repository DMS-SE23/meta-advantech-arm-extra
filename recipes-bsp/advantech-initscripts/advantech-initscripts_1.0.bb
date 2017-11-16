SUMMARY = "Advantech init scripts"
DESCRIPTION = "Initscripts provided by advantech for board support package."
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${WORKDIR}/README;md5=3d14358d5cb9cd537bab2028270080bc"

DEPENDS += "initscripts"

SRC_URI = "file://vpm-keyevent.sh \
		   file://bootcount.sh \
           file://README"

inherit update-alternatives
DEPENDS_append = " update-rc.d-native"
DEPENDS_append = " ${@bb.utils.contains('DISTRO_FEATURES','systemd','systemd-systemctl-native','',d)}"

FILES_${PN} = "${sysconfdir}/*"

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

	install -m 0644    ${WORKDIR}/vpm-keyevent.sh	${D}${sysconfdir}/init.d
	install -m 0644    ${WORKDIR}/bootcount.sh	${D}${sysconfdir}/init.d

#
# Create runlevel links
#
	update-rc.d -r ${D} vpm-keyevent.sh start 99 2 3 4 5 .
	update-rc.d -r ${D} bootcount.sh start 99 2 3 4 5 .
}

