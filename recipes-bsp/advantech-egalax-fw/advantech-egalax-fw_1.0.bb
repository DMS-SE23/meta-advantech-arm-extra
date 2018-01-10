SUMMARY = "Advantech"
DESCRIPTION = "egalax provided."
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${WORKDIR}/README;md5=7b2150497ffe3be59e34b6f0c074186f"

SRC_URI = "file://SensorTestDefault.ini \
		file://eSensorTester_ARMhf \
		file://egalax_fw_check.sh \
		file://egalax_fw_log \
		file://eUpdate2_ARMhf \
		file://4000_RawBase.csv \
		file://PCAP3146I_4000_v00T3_EP1010MLN6A0G_DThqa_E2.3146I \
		file://README"

S = "${WORKDIR}"
TARGET_CC_ARCH += "${LDFLAGS}"
INSANE_SKIP_${PN} = "ldflags"
INSANE_SKIP_${PN}-dev = "ldflags"

do_install () {
	install -d ${D}${sysconfdir}/egalax
	install -m 0755		${WORKDIR}/README				${D}${sysconfdir}/egalax/
	install -m 0755		${WORKDIR}/egalax_fw_log				${D}${sysconfdir}/egalax/
	install -m 0755		${WORKDIR}/egalax_fw_check.sh			${D}${sysconfdir}/egalax/
	install -m 0755		${WORKDIR}/eSensorTester_ARMhf			${D}${sysconfdir}/egalax/
	install -m 0755		${WORKDIR}/SensorTestDefault.ini		${D}${sysconfdir}/egalax/
	install -m 0755		${WORKDIR}/eUpdate2_ARMhf				${D}${sysconfdir}/egalax/
	install -m 0755		${WORKDIR}/4000_RawBase.csv				${D}${sysconfdir}/egalax/
	install -m 0755		${WORKDIR}/PCAP3146I_4000_v00T3_EP1010MLN6A0G_DThqa_E2.3146I	${D}${sysconfdir}/egalax/
}