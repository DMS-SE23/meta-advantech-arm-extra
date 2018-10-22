SUMMARY = "Terminal"
DESCRIPTION = "Terminal"
LICENSE = "MIT"
S="${WORKDIR}"
LIC_FILES_CHKSUM = "file://${WORKDIR}/README;md5=7095758c0d380386a3317b5c3cfa3b43"
RDEPENDS_${PN} = "gnome-terminal"

SRC_URI = "file://desktop-terminal.desktop \
           file://README"

do_install () {
	install -d ${D}/${datadir}/applications
	install -m 0644 ${WORKDIR}/desktop-terminal.desktop ${D}/${datadir}/applications
}
