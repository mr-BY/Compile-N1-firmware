#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
sed -i 's/192.168.1.1/192.168.31.2/g' package/base-files/files/bin/config_generate

# Replace the default theme
sed -i 's#luci-theme-bootstrap#luci-theme-argon#g' feeds/luci/collections/luci/Makefile

# Read cpufreq for aarch64
sed -i 's/LUCI_DEPENDS.*/LUCI_DEPENDS:=\@\(arm\|\|aarch64\)/g' package/lean/luci-app-cpufreq/Makefile

# Add luci-theme-argon
rm -rf ./package/lean/luci-theme-argon
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone https://github.com/jerrykuku/luci-app-argon-config.git package/luci-app-argon-config

# Add luci-app-amlogic
svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-amlogic

# Add po2lmo
git clone https://github.com/openwrt-dev/po2lmo.git
pushd po2lmo
make && sudo make install
popd

# Add OpenClash
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/luci-app-openclash

# Add luci-app-jd-dailybonus
rm -rf ./package/lean/luci-app-jd-dailybonus
git clone https://github.com/jerrykuku/luci-app-jd-dailybonus.git package/luci-app-jd-dailybonus

# Add luci-app-dockerman
rm -rf ./package/lean/luci-app-docker
rm -rf ./package/lean/luci-lib-docker
svn co https://github.com/lisaac/luci-app-dockerman/trunk/applications/luci-app-dockerman package/luci-app-dockerman
svn co https://github.com/lisaac/luci-lib-docker/trunk/collections/luci-lib-docker package/luci-lib-docker
if [ -e feeds/packages/utils/docker-ce ];then
	sed -i '/dockerd/d' package/luci-app-dockerman/Makefile
	sed -i 's/+docker/+docker-ce/g' package/luci-app-dockerman/Makefile
fi

# Add openwrt-passwall & luci-app-ssr-plus
git clone https://github.com/xiaorouji/openwrt-passwall.git package/openwrt-passwall
svn co https://github.com/fw876/helloworld/trunk/luci-app-ssr-plus package/openwrt-passwall/luci-app-ssr-plus

# Add luci-app-serverchan
git clone https://github.com/tty228/luci-app-serverchan.git package/luci-app-serverchan

# update && install
./scripts/feeds update -a
./scripts/feeds install -a
