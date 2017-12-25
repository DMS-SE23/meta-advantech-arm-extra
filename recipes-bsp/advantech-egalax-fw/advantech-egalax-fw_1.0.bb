SUMMARY = "Advantech"
DESCRIPTION = "egalax provided."
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${WORKDIR}/README;md5=5ab598e178c758bc5ddaae2ad38da34d"

SRC_URI = "file://SensorTestDefault.ini \
		file://eSensorTester_ARMhf \
		file://egalax_fw_check.sh \
		file://egalax_fw_log \
		file://eUpdate2_ARMhf \
		file://PCAP3147UI_4473_v00_test1_C000_DThqa.3147UI \
		file://README"

S = "${WORKDIR}"
TARGET_CC_ARCH += "${LDFLAGS}"
INSANE_SKIP_${PN} = "ldflags"
INSANE_SKIP_${PN}-dev = "ldflags"

do_install () {
	install -d ${D}${sysconfdir}/egalax
	install -m 0755		${WORKDIR}/egalax_fw_log				${D}${sysconfdir}/egalax/
	install -m 0755		${WORKDIR}/egalax_fw_check.sh			${D}${sysconfdir}/egalax/
	install -m 0755		${WORKDIR}/eSensorTester_ARMhf			${D}${sysconfdir}/egalax/
	install -m 0755		${WORKDIR}/SensorTestDefault.ini		${D}${sysconfdir}/egalax/
	install -m 0755		${WORKDIR}/eUpdate2_ARMhf				${D}${sysconfdir}/egalax/
	install -m 0755		${WORKDIR}/PCAP3147UI_4473_v00_test1_C000_DThqa.3147UI	${D}${sysconfdir}/egalax/
}