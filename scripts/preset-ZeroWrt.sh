mkdir -p files/bin

cat << 'EOF' > files/bin/ZeroWrt
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

change_ip() { ... }  # 同原脚本逻辑
change_password() { ... }
change_theme() { ... }
reset_config() { ... }
show_menu
EOF

chmod +x files/bin/ZeroWrt
