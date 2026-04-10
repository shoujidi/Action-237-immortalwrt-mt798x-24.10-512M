#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# 1. 修改默认 IP (已保留你的设置)
sed -i 's/192.168.1.1/192.168.6.1/g' package/base-files/files/bin/config_generate

# 2. 修改主机名 (修正语法错误)
# 使用 bash 的日期变量，确保写入文件的是最终生成的字符串，而不是 Makefile 脚本代码
date_version=$(date +"%y%m%d")
sed -i "s/hostname='ImmortalWrt'/hostname='360T7-PW2-$date_version'/g" package/base-files/files/bin/config_generate

# 3. 修改固件生成后的文件名 (增加日期前缀)
# 这个在 include/image.mk 里可以使用 Makefile 语法，保留但优化了格式
sed -i "s/IMG_PREFIX:=/IMG_PREFIX:=$(date +'%Y%m%d')-360T7-PW2-/" include/image.mk

# 4. (可选) 强制 Passwall 2 使用固定的依赖，防止编译时版本冲突
# 如果你在 .yml 里已经处理了冲突，这里不需要额外操作
