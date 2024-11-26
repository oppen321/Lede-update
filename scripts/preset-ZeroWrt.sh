#!/bin/bash

# 添加 ZeroWrt 脚本到 /etc/init.d
mkdir -p files/etc/init.d
mkdir -p files/bin

cat << 'EOF' > files/etc/init.d/ZeroWrt
#!/bin/ash
# ZeroWrt 菜单脚本
show_menu() {
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
    printf "请输入您的选择 [0-4]："
    read choice
    case $choice in
        1) change_ip ;;
        2) change_password ;;
        3) change_theme ;;
        4) reset_config ;;
        0) exit 0 ;;
        *) echo "无效选项，请重新输入"; show_menu ;;
    esac
}

change_ip() {
    printf "请输入新的 LAN 口 IP 地址（如 192.168.1.2）: "
    read new_ip
    sed -i "s/option ipaddr.*/option ipaddr '$new_ip'/" /etc/config/network
    /etc/init.d/network restart
    echo "LAN 口 IP 已成功更改为 $new_ip"
    sleep 2
    show_menu
}

change_password() {
    printf "请输入新密码: "
    read new_password
    (echo "$new_password"; echo "$new_password") | passwd root
    echo "密码已成功更改"
    sleep 2
    show_menu
}

change_theme() {
    uci set luci.main.mediaurlbase='/luci-static/bootstrap'
    uci commit luci
    echo "主题已切换为默认主题 luci-theme-bootstrap"
    sleep 2
    show_menu
}

reset_config() {
    echo "正在恢复出厂设置..."
    sleep 2
    firstboot
    reboot
}

show_menu
EOF

# 设置执行权限
chmod +x files/etc/init.d/ZeroWrt
ln -s /etc/init.d/ZeroWrt files/bin/ZeroWrt
chmod +x files/bin/ZeroWrt
