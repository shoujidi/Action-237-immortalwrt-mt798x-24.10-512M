#!/bin/bash
# ============================================================
# gen-passwall2-config.sh
# 用途：将 2410-6.6-360t7-passwall.config 转换为
#        2410-6.6-360t7-passwall2.config
# 使用方法：
#   chmod +x gen-passwall2-config.sh
#   ./gen-passwall2-config.sh
#
# 前提：仓库根目录需有 2410-6.6-360t7-passwall.config
#       （从 ATang007ZH/Action-237-immortalwrt-mt798x-24.10 复制）
# ============================================================

SRC="2410-6.6-360t7-passwall.config"
DST="2410-6.6-360t7-passwall2.config"

if [ ! -f "$SRC" ]; then
    echo "[错误] 找不到源文件: $SRC"
    echo "请先将上游仓库的 2410-6.6-360t7-passwall.config 放到同目录再运行。"
    echo "下载地址："
    echo "  https://github.com/ATang007ZH/Action-237-immortalwrt-mt798x-24.10/raw/main/2410-6.6-360t7-passwall.config"
    exit 1
fi

cp "$SRC" "$DST"
echo "[信息] 已复制 $SRC -> $DST，开始替换..."

# ---- 1. 禁用 luci-app-passwall 相关 ----
sed -i 's/^CONFIG_PACKAGE_luci-app-passwall=y/# CONFIG_PACKAGE_luci-app-passwall is not set/' "$DST"
# 禁用 passwall 的所有 INCLUDE 子选项
sed -i '/^CONFIG_PACKAGE_luci-app-passwall_INCLUDE_/s/^/# /' "$DST"
sed -i 's/^# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_\(.*\)=y/# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_\1 is not set/' "$DST"

# ---- 2. 启用 luci-app-passwall2 ----
# 如果文件中已有 passwall2 的 not set 行，将其激活
sed -i 's/^# CONFIG_PACKAGE_luci-app-passwall2 is not set/CONFIG_PACKAGE_luci-app-passwall2=y/' "$DST"

# 若文件中完全没有 passwall2 记录，追加到末尾
if ! grep -q "luci-app-passwall2" "$DST"; then
    cat >> "$DST" << 'EOF'

# Passwall2
CONFIG_PACKAGE_luci-app-passwall2=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Xray=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Hysteria=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_ShadowsocksR_Libev_Client=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_ShadowsocksR_Libev_Server=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Shadowsocks_Rust_Client=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Shadowsocks_Rust_Server=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_tuic_client=y
EOF
fi

echo ""
echo "[完成] 已生成: $DST"
echo ""
echo "--- passwall2 相关配置预览 ---"
grep "passwall2" "$DST"
echo "------------------------------"
echo "确认无误后，将 $DST 推入仓库根目录即可触发编译。"
