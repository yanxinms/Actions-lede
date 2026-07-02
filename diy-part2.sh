#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
find ./ | grep Makefile | grep v2ray-geodata | xargs rm -f
find ./ | grep Makefile | grep mosdns | xargs rm -f
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata

git clone --depth=1 --single-branch --branch master https://github.com/vernesong/OpenClash.git openclash_repo
mv openclash_repo/luci-app-openclash package/
rm -rf openclash_repo

rm -f feeds/qmodem/application/qmodem/Makefile

# 直接将新的内容写入目标路径
cat << 'EOF' > feeds/qmodem/application/qmodem/Makefile
include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

# Include unified version
include ../../version.mk

PKG_NAME:=qmodem
PKG_RELEASE:=$(QMODEM_RELEASE)
PKG_VERSION:=$(QMODEM_VERSION)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=QModem scripts
  DEPENDS:= \
        +kmod-usb2 +kmod-usb3 \
        +kmod-usb-serial +kmod-usb-serial-option +kmod-usb-serial-qualcomm \
        +kmod-usb-net +kmod-usb-acm \
        +kmod-usb-wdm \
        +kmod-usb-net-cdc-ether \
        +kmod-usb-net-cdc-mbim \
        +kmod-usb-net-rndis \
        +kmod-usb-net-cdc-ncm +kmod-usb-net-huawei-cdc-ncm \
        +ubus-at-daemon +tom_modem +terminfo +sms-tool_q \
        +modem_scan \
        +jq +bc\
        +coreutils +coreutils-stat \
        +usbutils \
        +PACKAGE_luci-app-qmodem_INCLUDE_rdisc6:rdisc6 \
        +PACKAGE_luci-app-qmodem_INCLUDE_ndisc6:ndisc6 \
        +PACKAGE_luci-app-qmodem_INCLUDE_ADD_PCI_SUPPORT:pciutils \
        +PACKAGE_luci-app-qmodem_INCLUDE_ADD_MTK_T7XX_SUPPORT:umbim
endef

define Package/$(PKG_NAME)/description
	QModem scripts
endef

define Build/Prepare
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
EOF

echo "qmodem Makefile 替换成功！"


# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

# Modify default theme
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate
