SUMMARY = "Advantechgroup-systeminfo"
DESCRIPTION = "systeminfo."
LICENSE = "MIT"
S="${WORKDIR}"
LIC_FILES_CHKSUM = "file://${WORKDIR}/README;md5=7095758c0d380386a3317b5c3cfa3b43"
RDEPENDS_${PN} = "gnome-terminal"
RDEPENDS_${PN} += "bash"

SRC_URI = "file://version.desktop \
           file://version.sh \
           file://README"

do_install () {
	install -d ${D}/${datadir}/applications
	install -m 0644 ${WORKDIR}/version.desktop ${D}/${datadir}/applications

	install -d ${D}/${sysconfdir}
	install -m 0777 ${WORKDIR}/version.sh ${D}/${sysconfdir}/version.sh
}

