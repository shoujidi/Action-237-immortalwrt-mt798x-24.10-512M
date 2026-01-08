#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# 1. 按照原作者要求，在 feeds 第一行插入最新的 Passwall 源码
sed -i '1i src-git passwall https://github.com/xiaorouji/openwrt-passwall.git;main' feeds.conf.default
sed -i '1i src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages.git;main' feeds.conf.default

# 2. 添加 OpenClash 官方源
echo 'src-git openclash https://github.com/vernesong/OpenClash.git' >>feeds.conf.default

# 3. 集成常用依赖包源 (备用)
# echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
