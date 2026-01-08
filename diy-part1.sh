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

# 1. 添加 OpenClash 官方源
echo 'src-git openclash https://github.com/vernesong/OpenClash.git' >>feeds.conf.default

# 2. (可选) 添加 Passwall 源（如果你也想尝试这个的话）
echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default
echo 'src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages' >>feeds.conf.default

# 3. 集成常用依赖包源
# echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
