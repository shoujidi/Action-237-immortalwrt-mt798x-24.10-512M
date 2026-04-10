#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: 2410-6.6-diy-part2-6-1-pw2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# 1. 修改默认 IP
sed -i 's/192.168.1.1/192.168.0.1/g' package/base-files/files/bin/config_generate

# 2. 修改主机名
sed -i "s/hostname='ImmortalWrt'/hostname='360T7'/g" package/base-files/files/bin/config_generate

# 3. 修改固件生成后的文件名 (增加日期前缀)
sed -i "s/IMG_PREFIX:=/IMG_PREFIX:=$(date +'%Y%m%d')-360T7-PW2-/" include/image.mk

# 4. 【核心：共存修复】处理 OpenClash 与 Passwall2 的依赖冲突
# 强制删除 feeds 目录中与自定义 package 目录重复的包，防止编译时出现 Error 1 或 2
rm -rf feeds/packages/net/xray-core
rm -rf feeds/packages/net/sing-box
rm -rf feeds/packages/net/v2ray-geodata
rm -rf feeds/luci/applications/luci-app-passwall
rm -rf feeds/luci/applications/luci-app-openclash

# 5. 【修正】有些时候 feeds 会自动拉取旧版依赖，强制删除它们以使用我们手动 clone 的版本
rm -rf package/feeds/packages/xray-core
rm -rf package/feeds/luci/luci-app-openclash

# 1. 强制开启 Luci 兼容补丁 (2026年环境共存必须)
echo "CONFIG_PACKAGE_luci-compat=y" >> .config

# 2. 确保 OpenClash 使用其核心，防止被系统自带的旧版覆盖
echo "CONFIG_PACKAGE_luci-app-openclash=y" >> .config

# 3. 针对 360T7 的 6.6 内核优化 nftables 转发
echo "CONFIG_PACKAGE_kmod-nft-tproxy=y" >> .config
