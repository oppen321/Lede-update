#!/bin/bash

# 定义菜单函数
function show_menu {
    clear
    echo "=============================="
    echo "  ZeroWrt 选项菜单"
    echo "=============================="
    echo "1. 更换 LAN 口 IP 地址"
    echo "2. 更改管理员密码"
    echo "3. 切换默认主题"
    echo "4. 一键重置配置"
    echo "0. 退出"
    echo "=============================="
    read -p "请输入您的选择 [0-4]：" choice
    case $choice in
        1) change_ip ;;
        2) change_password ;;
        3) change_theme ;;
        4) reset_config ;;
        0) exit 0 ;;
        *) echo "无效选项，请重新输入"; show_menu ;;
    esac
}

# 1. 更换 LAN 口 IP 地址
function change_ip {
    read -p "请输入新的 LAN 口 IP 地址（如 192.168.1.2）: " new_ip
    # 修改 LAN 口的 IP 配置文件（/etc/config/network）
    sed -i "s/option ipaddr.*/option ipaddr '$new_ip'/" /etc/config/network
    /etc/init.d/network restart
    echo "LAN 口 IP 已成功更改为 $new_ip"
    read -p "按 Enter 键返回菜单..."
    show_menu
}

# 2. 更改管理员密码
function change_password {
    read -p "请输入新密码: " new_password
    # 更新管理员密码
    echo "root:$new_password" | chpasswd
    echo "密码已更改成功"
    read -p "按 Enter 键返回菜单..."
    show_menu
}

# 3. 切换默认主题
function change_theme {
    # 切换主题配置（例如切换为 OpenWrt 默认主题）
    rm -rf /etc/config/luci
    opkg update
    opkg install luci-theme-bootstrap
    echo "主题已切换为 OpenWrt 默认主题"
    read -p "按 Enter 键返回菜单..."
    show_menu
}

# 4. 一键重置配置
function reset_config {
    # 删除所有配置并恢复出厂设置
    echo "正在恢复出厂设置..."
    sysupgrade -n /etc/config
    echo "系统已重置，所有配置已清除"
    read -p "按 Enter 键重启设备..."
    reboot
}

# 启动菜单
show_menu
