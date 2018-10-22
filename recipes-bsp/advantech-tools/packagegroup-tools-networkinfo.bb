SUMMARY = "Advantechgroup-networkinfo"
DESCRIPTION = "networkinfo."
LICENSE = "MIT"
S="${WORKDIR}"
LIC_FILES_CHKSUM = "file://${WORKDIR}/README;md5=7095758c0d380386a3317b5c3cfa3b43"
RDEPENDS_${PN} = "gnome-terminal"
RDEPENDS_${PN} += "bash"

SRC_URI = "file://networkinfo.desktop \
           file://networkinfo.sh \
           file://README"

do_install () {
	install -d ${D}/${datadir}/applications
	install -m 0644 ${WORKDIR}/networkinfo.desktop ${D}/${datadir}/applications

	install -d ${D}/${sysconfdir}
	install -m 0777 ${WORKDIR}/networkinfo.sh ${D}/${sysconfdir}/networkinfo.sh
}

