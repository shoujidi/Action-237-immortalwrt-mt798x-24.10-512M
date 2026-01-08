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

# 2. 修改默认主机名为 360-T7
sed -i 's/OpenWrt/360-T7/g' package/base-files/files/bin/config_generate

# --- 512M Flash 适配开始 ---

# 3. 扩充物理寻址：将 128M (0x8000000) 改为 512M (0x20000000)
sed -i 's/0x8000000/0x20000000/g' target/linux/mediatek/dts/mt7981-360-t7-108M.dts

# 4. 扩充逻辑分区：将 UBI 分区寄存器长度拉伸到 512M (0x1ef00000)
sed -i '/partition@1100000 {/,/};/ s/reg = <0x1100000 0x6900000>/reg = <0x1100000 0x1ef00000>/' target/linux/mediatek/dts/mt7981-360-t7-108M.dts

# 5. 解除编译镜像大小限制：防止生成固件时报错
sed -i 's/IMAGE_SIZE := 108M/IMAGE_SIZE := 500M/g' target/linux/mediatek/image/mt7981.mk

# --- 512M Flash 适配结束 ---

# --- 强制注入插件配置开始 ---

# 6. 同时向 .config 和 360t7.config 注入 OpenClash 配置
# 这样无论 Actions 加载哪一个配置文件，都能保证 OpenClash 被选上
for config_file in .config 360t7.config; do
    if [ -f "$config_file" ]; then
        echo "正在向 $config_file 注入 OpenClash 配置..."
        # 删除可能存在的未选中标识，并追加选中配置
        sed -i '/CONFIG_PACKAGE_luci-app-openclash/d' $config_file
        echo "CONFIG_PACKAGE_luci-app-openclash=y" >> $config_file
        echo "CONFIG_PACKAGE_luci-i18n-openclash-zh-cn=y" >> $config_file
        # 注入必要依赖
        echo "CONFIG_PACKAGE_curl=y" >> $config_file
        echo "CONFIG_PACKAGE_ca-bundle=y" >> $config_file
        echo "CONFIG_PACKAGE_libcap=y" >> $config_file
        echo "CONFIG_PACKAGE_libcap-bin=y" >> $config_file
    fi
done

# --- 强制注入插件配置结束 ---
