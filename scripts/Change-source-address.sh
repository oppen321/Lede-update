#!/bin/bash

mkdir -p files/etc/opkg

# 设置新的源地址
NEW_SOURCES="
src/gz openwrt_base https://mirrors.tencent.com/lede/releases/18.06.9/packages/x86_64/base
src/gz openwrt_luci https://mirrors.tencent.com/lede/releases/18.06.9/packages/x86_64/luci
src/gz openwrt_packages https://mirrors.tencent.com/lede/releases/18.06.9/packages/x86_64/packages
src/gz openwrt_routing https://mirrors.tencent.com/lede/releases/18.06.9/packages/x86_64/routing
src/gz openwrt_telephony https://mirrors.tencent.com/lede/releases/18.06.9/packages/x86_64/telephony
"

# 创建 opkg 配置文件并写入源地址
echo "$NEW_SOURCES" > files/etc/opkg/distfeeds.conf

chmod +x files/etc/opkg/distfeeds.conf
