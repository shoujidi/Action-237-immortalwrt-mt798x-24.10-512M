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

# 1. 修改默认管理 IP 为 192.168.0.1
sed -i 's/192.168.1.1/192.168.0.1/g' package/base-files/files/bin/config_generate

# 2. 修改默认主机名为 360-T7-512M (可选，方便识别)
sed -i 's/OpenWrt/360-T7-512M/g' package/base-files/files/bin/config_generate

# --- 512M Flash 适配开始 ---

# 3. 扩充物理寻址：将寻址范围从 128M (0x8000000) 改为 512M (0x20000000)
# 注意：此命令会搜索所有匹配的 128M 地址并替换为 512M
sed -i 's/0x8000000/0x20000000/g' target/linux/mediatek/dts/mt7981-360-t7-108M.dts

# 4. 扩充逻辑分区：修改 UBI 分区寄存器定义，将 size 从 108M 对应的长度拉伸到 512M 对应的长度
# 这里的 0x1ef00000 是给 UBI 预留约 495MB 的空间
sed -i '/partition@1100000 {/,/};/ s/reg = <0x1100000 0x6900000>/reg = <0x1100000 0x1ef00000>/' target/linux/mediatek/dts/mt7981-360-t7-108M.dts

# 5. 解除编译镜像大小限制：将原本 108M 的镜像限制放宽，防止编译程序报错
sed -i 's/IMAGE_SIZE := 108M/IMAGE_SIZE := 500M/g' target/linux/mediatek/image/mt7981.mk

# --- 512M Flash 适配结束 ---
