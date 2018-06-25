SUMMARY = "Advantech autobrightness"
DESCRIPTION = "autobrightness provided by advantech for board support package."
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${WORKDIR}/README;md5=64c3d2c96e6ad9941bde3924ddfd1416"

SRC_URI = "file://light_range.conf \
		file://light_lux200.conf \
		file://light_levels.conf \
		file://light_controlbl.conf \
		file://light_autobl.conf \
		file://auto_brightness_self_test.sh \
		file://auto_brightness_flash_test.sh \
		file://auto_brightness_level_mapping.sh \
		file://init_auto_brightness \
		file://README"

FILES_${PN} = "${sysconfdir}/*"

do_install () {
#
# install device conf
#
	install -d ${D}${sysconfdir}/
	install -m 0644    ${WORKDIR}/light_range.conf			${D}${sysconfdir}/
	install -m 0644    ${WORKDIR}/light_lux200.conf			${D}${sysconfdir}/
	install -m 0644    ${WORKDIR}/light_levels.conf			${D}${sysconfdir}/
	install -m 0644    ${WORKDIR}/light_controlbl.conf		${D}${sysconfdir}/
	install -m 0644    ${WORKDIR}/light_autobl.conf			${D}${sysconfdir}/

	install -m 755 ${WORKDIR}/auto_brightness_self_test.sh ${D}/${sysconfdir}/
	install -m 755 ${WORKDIR}/auto_brightness_flash_test.sh ${D}/${sysconfdir}/
	install -m 755 ${WORKDIR}/auto_brightness_level_mapping.sh ${D}/${sysconfdir}/

	install -d ${D}${sysconfdir}/init.d
	install -m 0777    ${WORKDIR}/init_auto_brightness ${D}${sysconfdir}/init_auto_brightness
	install -m 0777    ${WORKDIR}/init_auto_brightness ${D}${sysconfdir}/init.d/init_auto_brightness

	update-rc.d -r ${D} init_auto_brightness start 99 2 3 4 5 .
}

 