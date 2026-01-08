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

# 1. 修改默认 IP 为 192.168.0.1 (符合你的要求)
sed -i 's/192.168.1.1/192.168.0.1/g' package/base-files/files/bin/config_generate

# 2. 修改主机名，加入日期和 512M 标识
sed -i 's/ImmortalWrt/360-T7-512M/g' package/base-files/files/bin/config_generate

# 3. 针对 512M Flash (D99XV) 的核心适配 (5.4内核 360T7 专用)
# 修改设备树物理寻址：128M -> 512M
sed -i 's/0x8000000/0x20000000/g' target/linux/mediatek/dts/mt7981-360-t7-108M.dts

# 修改 UBI 逻辑分区：释放全部 512M 空间给存储
sed -i '/partition@1100000 {/,/};/ s/reg = <0x1100000 0x6900000>/reg = <0x1100000 0x1ef00000>/' target/linux/mediatek/dts/mt7981-360-t7-108M.dts

# 解除编译输出文件的容量校验限制
sed -i 's/IMAGE_SIZE := 108M/IMAGE_SIZE := 500M/g' target/linux/mediatek/image/mt7981.mk

# 4. 根据你的 config 内容进行强制修正
# 你的 config 默认是 128M 分区，这里强制改为 512M
sed -i 's/CONFIG_TARGET_KERNEL_PARTSIZE=128/CONFIG_TARGET_KERNEL_PARTSIZE=512/g' .config

# 强制注入 OpenClash 和 文件传输 (Filetransfer) 插件
echo "CONFIG_PACKAGE_luci-app-openclash=y" >> .config
echo "CONFIG_PACKAGE_luci-i18n-openclash-zh-cn=y" >> .config
echo "CONFIG_PACKAGE_luci-app-filetransfer=y" >> .config
echo "CONFIG_PACKAGE_luci-i18n-filetransfer-zh-cn=y" >> .config

# 确保依赖库完整 (避免 OpenClash 启动失败)
echo "CONFIG_PACKAGE_curl=y" >> .config
echo "CONFIG_PACKAGE_ca-bundle=y" >> .config
echo "CONFIG_PACKAGE_libcap=y" >> .config
echo "CONFIG_PACKAGE_libcap-bin=y" >> .config

# 5. 修改固件文件名前缀，方便识别
sed -i "s|IMG_PREFIX:=|IMG_PREFIX:=$(date +'%Y%m%d')-512M-360T7-|" include/image.mk
