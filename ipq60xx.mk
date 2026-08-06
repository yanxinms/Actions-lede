DTS_DIR := $(DTS_DIR)/qcom
DEVICE_VARS += TPLINK_SUPPORT_STRING

define Build/wax610-netgear-tar
	mkdir $@.tmp
	mv $@ $@.tmp/nand-ipq6018-apps.img
	md5sum $@.tmp/nand-ipq6018-apps.img | cut -c 1-32 > $@.tmp/nand-ipq6018-apps.md5sum
	echo "WAX610" > $@.tmp/metadata.txt
	echo "WAX610-610Y_V99.9.9.9" > $@.tmp/version
	tar -C $@.tmp/ -cf $@ .
	rm -rf $@.tmp
endef

define Build/netgear-rbx350-qsdk-ipq-factory
	$(CP) $(FLASH_SCRIPT) $(KDIR_TMP)/

	echo "VERSION : V5.0.0.0_$(LINUX_VERSION)" > $@.metadata
	echo "MODEL_ID : $(DEVICE_MODEL)" >> $@.metadata

	$(TOPDIR)/scripts/mkits-qsdk-ipq-image.sh $@.its $(FLASH_SCRIPT) txt $@.metadata ubi $@
	PATH=$(LINUX_DIR)/scripts/dtc:$(PATH) mkimage -f $@.its $@.new
	@mv $@.new $@
endef


define Device/jdcloud_re-cs-02
	$(call Device/FitImage)
	$(call Device/EmmcImage)
	DEVICE_VENDOR := JDCloud
	DEVICE_MODEL := RE-CS-02
	KERNEL_SIZE := 6144k
	SOC := ipq6010
	DEVICE_DTS_CONFIG := config@cp03-c3
	DEVICE_PACKAGES := ipq-wifi-jdcloud_re-cs-02 ath11k-firmware-qcn9074-ddwrt luci-app-athena-led luci-i18n-athena-led-zh-cn
	IMAGE/factory.bin := append-kernel | pad-to $$(KERNEL_SIZE) | append-rootfs | append-metadata
endef
TARGET_DEVICES += jdcloud_re-cs-02

define Device/nand-common
	$(call Device/FitImage)
	$(call Device/UbiFit)
	BLOCKSIZE := 128k
	PAGESIZE := 2048
endef

define Device/emmc-common
	$(call Device/FitImage)
	$(call Device/EmmcImage)
	KERNEL_SIZE := 6144k
	IMAGE/factory.bin := append-kernel | pad-to $$(KERNEL_SIZE) | append-rootfs | append-metadata
endef

