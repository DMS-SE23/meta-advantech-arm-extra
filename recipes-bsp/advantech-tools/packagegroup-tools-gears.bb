SUMMARY = "Advantechgroup-gears"
DESCRIPTION = "support gears application."
LICENSE = "MIT"
S="${WORKDIR}"
LIC_FILES_CHKSUM = "file://${WORKDIR}/README;md5=7095758c0d380386a3317b5c3cfa3b43"

RDEPENDS_${PN} = "bash"
RDEPENDS_${PN} += "mesa-demos"

SRC_URI = "file://gears.desktop \
           file://README"

do_install () {
	install -d ${D}/${datadir}/applications
	install -m 0644 ${WORKDIR}/gears.desktop ${D}/${datadir}/applications
}

