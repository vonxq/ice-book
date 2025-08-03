#!/bin/bash

# Ice Book 记账应用 - 平台选择启动脚本

echo "🎯 Ice Book 记账应用启动器"
echo "================================"
echo ""

# 检查Flutter是否安装
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter未安装，请先安装Flutter SDK"
    echo "📖 安装指南: https://flutter.dev/docs/get-started/install"
    exit 1
fi

# 显示可用设备
echo "📱 可用设备："
flutter devices
echo ""

# 显示选项
echo "请选择运行平台："
echo "1. macOS 桌面应用"
echo "2. Web 浏览器应用"
echo "3. iOS 模拟器 (需要Xcode)"
echo "4. Android 模拟器 (需要Android Studio)"
echo "5. 自动选择最佳平台"
echo ""

read -p "请输入选项 (1-5): " choice

case $choice in
    1)
        echo "🖥️ 启动macOS版本..."
        flutter run -d macos
        ;;
    2)
        echo "🌐 启动Web版本..."
        flutter run -d chrome
        ;;
    3)
        echo "📱 启动iOS版本..."
        flutter run -d "iPhone"
        ;;
    4)
        echo "🤖 启动Android版本..."
        flutter run -d "android"
        ;;
    5)
        echo "🤖 自动选择最佳平台..."
        if flutter devices | grep -q "macOS"; then
            echo "🖥️ 选择macOS平台..."
            flutter run -d macos
        elif flutter devices | grep -q "Chrome"; then
            echo "🌐 选择Web平台..."
            flutter run -d chrome
        elif flutter devices | grep -q "iPhone"; then
            echo "📱 选择iOS平台..."
            flutter run -d "iPhone"
        elif flutter devices | grep -q "android"; then
            echo "🤖 选择Android平台..."
            flutter run -d "android"
        else
            echo "❌ 未找到可用设备"
            echo "💡 请确保已连接设备或启动模拟器"
        fi
        ;;
    *)
        echo "❌ 无效选项，请重新运行脚本"
        exit 1
        ;;
esac 