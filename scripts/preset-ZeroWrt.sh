#!/bin/bash

# 创建文件夹结构
mkdir -p files/bin

# 创建脚本文件
cat << 'EOF' > files/bin/ZeroWrt
#!/bin/ash

# 显示菜单
show_menu() {
    echo -e "\e[35m+--------------------------------------------------+\e[0m"
    echo -e "\e[35m|                                                  |\e[0m"
    echo -e "\e[31m|                ZeroWrt 选项菜单                  |\e[0m"
    echo -e "\e[35m|                                                  |\e[0m"
    echo -e "\e[35m|                     博客地址:www.kejizero.online |\e[0m"
    echo -e "\e[35m+--------------------------------------------------+\e[0m"
    echo "1. 更换 LAN 口 IP 地址"
    echo "2. 更改管理员密码"
    echo "3. 切换默认主题"
    echo "4. 一键重置配置"
    echo "5. IPv6 设置"
    echo "0. 退出"
    echo "=============================="
    printf "请输入您的选择 [0-5]: "
    read choice
    case "$choice" in
        1) change_ip ;;
        2) change_password ;;
        3) change_theme ;;
        4) reset_config ;;
        5) ipv6_settings ;;
        0) exit 0 ;;
        *) echo "无效选项，请重新输入"; show_menu ;;
    esac
}

# 1. 更换 LAN 口 IP 地址
change_ip() {
    printf "请输入新的 LAN 口 IP 地址（如 192.168.1.2）："
    read new_ip
    if [ -n "$new_ip" ]; then
        uci set network.lan.ipaddr="$new_ip"
        uci commit network
        /etc/init.d/network restart
        echo "LAN 口 IP 已成功更改为 $new_ip"
    else
        echo "未输入有效的 IP 地址，操作取消。"
    fi
    printf "按 Enter 键返回菜单..."
    read
    show_menu
}

# 2. 更改管理员密码
change_password() {
    printf "请输入新密码："
    read new_password
    if [ -n "$new_password" ]; then
        echo -e "$new_password\n$new_password" | passwd root
        echo "管理员密码已成功更改。"
    else
        echo "未输入有效密码，操作取消。"
    fi
    printf "按 Enter 键返回菜单..."
    read
    show_menu
}

# 3. 切换默认主题
change_theme() {
    uci set luci.main.mediaurlbase='/luci-static/bootstrap'
    uci commit luci
    echo "主题已切换为默认的 OpenWrt 主题（luci-theme-bootstrap）。"
    printf "按 Enter 键返回菜单..."
    read
    show_menu
}

# 4. 一键重置配置
reset_config() {
    echo "正在恢复出厂设置..."
    firstboot -y
    echo "设备将在 5 秒后重启..."
    sleep 5
    reboot
}

# 5. IPv6 设置
ipv6_settings() {
    echo "=============================="
    echo "  IPv6 设置"
    echo "=============================="
    echo "1. 开启 IPv6"
    echo "2. 关闭 IPv6"
    echo "0. 返回上一级"
    echo "=============================="
    printf "请输入您的选择 [0-2]: "
    read ipv6_choice
    case "$ipv6_choice" in
        1) enable_ipv6 ;;
        2) disable_ipv6 ;;
        0) show_menu ;;
        *) echo "无效选项，请重新输入"; ipv6_settings ;;
    esac
}

# 开启 IPv6
enable_ipv6() {
    echo "正在开启 IPv6..."
    # 开启 IPv6 分配长度、路由通告、DHCPv6 服务
    uci set network.lan.ip6assign='64'
    uci set dhcp.lan.ra='server'
    uci set dhcp.lan.dhcpv6='server'
    
    # 启用解析 IPv6 DNS 记录
    if ! uci show dhcp.@dnsmasq[0].filter_aaaa >/dev/null 2>&1; then
        uci add_list dhcp.@dnsmasq[0].filter_aaaa='0'
    fi

    uci commit
    /etc/init.d/network restart
    echo "IPv6 功能已开启。"
    printf "按 Enter 键返回菜单..."
    read
    show_menu
}

# 关闭 IPv6
disable_ipv6() {
    echo "正在关闭 IPv6..."
    # 禁用 IPv6 分配长度、路由通告、DHCPv6 服务
    if uci show network.lan.ip6assign >/dev/null 2>&1; then
        uci delete network.lan.ip6assign
    fi
    uci set dhcp.lan.ra='disabled'
    uci set dhcp.lan.dhcpv6='disabled'

    # 禁用解析 IPv6 DNS 记录
    uci set dhcp.@dnsmasq[0].filter_aaaa='1'

    uci commit
    /etc/init.d/network restart
    echo "IPv6 功能已关闭。"
    printf "按 Enter 键返回菜单..."
    read
    show_menu
}

# 启动菜单
show_menu
EOF

# 设置脚本权限
chmod +x files/bin/ZeroWrt
