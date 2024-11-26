#!/bin/ash

# 定义菜单函数
show_menu() {
    echo "=============================="
    echo "  ZeroWrt 选项菜单"
    echo "=============================="
    echo "1. 更换 LAN 口 IP 地址"
    echo "2. 更改管理员密码"
    echo "3. 切换默认主题"
    echo "4. 一键重置配置"
    echo "0. 退出"
    echo "=============================="
    printf "请输入您的选择 [0-4]: "
    read choice
    case "$choice" in
        1) change_ip ;;
        2) change_password ;;
        3) change_theme ;;
        4) reset_config ;;
        0) exit 0 ;;
        *) echo "无效选项，请重新输入"; show_menu ;;
    esac
}

# 1. 更换 LAN 口 IP 地址
change_ip() {
    printf "请输入新的 LAN 口 IP 地址（如 192.168.1.2）："
    read new_ip
    # 修改 LAN 口的 IP 配置文件（/etc/config/network）
    sed -i "s/option ipaddr.*/option ipaddr '$new_ip'/" /etc/config/network
    /etc/init.d/network restart
    echo "LAN 口 IP 已成功更改为 $new_ip"
    printf "按 Enter 键返回菜单..."
    read
    show_menu
}

# 2. 更改管理员密码
change_password() {
    printf "请输入新密码："
    read new_password
    # 更新管理员密码
    echo "root:$new_password" | chpasswd
    echo "密码已更改成功"
    printf "按 Enter 键返回菜单..."
    read
    show_menu
}

# 3. 切换默认主题
change_theme() {
    # 修改 luci 配置文件来切换主题
    uci set luci.main.mediaurlbase='/luci-static/bootstrap'
    uci commit luci
    echo "主题已切换为默认的 OpenWrt 主题"
    printf "按 Enter 键返回菜单..."
    read
    show_menu
}

# 4. 一键重置配置
reset_config() {
    echo "正在恢复出厂设置..."
    firstboot
    reboot
}

# 启动菜单
show_menu
