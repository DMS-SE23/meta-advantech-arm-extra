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

	# Copy normal boot image
	install -d ${D}/emmc
	install -m 0644    ${DEPLOY_DIR_IMAGE}/u-boot.imx	${D}/emmc/u-boot.imx
	install -m 0644    ${DEPLOY_DIR_IMAGE}/zImage	${D}/emmc/zImage
	install -m 0644    ${DEPLOY_DIR_IMAGE}/zImage-imx6dl-dmsse23.dtb	${D}/emmc/imx6dl-dmsse23.dtb
	install -m 0644    ${DEPLOY_DIR_IMAGE}/adv-image-qt5-imx6dl-dmsse23.ext4	${D}/emmc/adv-image-qt5-imx6dl-dmsse23.ext4

	sha256sum ${D}/emmc/u-boot.imx | awk '{print $1}' > ${D}/emmc/u-boot.imx.sha256sum
	sha256sum ${D}/emmc/zImage | awk '{print $1}' > ${D}/emmc/zImage.sha256sum
	sha256sum ${D}/emmc/imx6dl-dmsse23.dtb | awk '{print $1}' > ${D}/emmc/imx6dl-dmsse23.dtb.sha256sum
	sha256sum ${D}/emmc/adv-image-qt5-imx6dl-dmsse23.ext4 | awk '{print $1}' > ${D}/emmc/adv-image-qt5-imx6dl-dmsse23.ext4.sha256sum

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
