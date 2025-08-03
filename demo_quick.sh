#!/bin/bash

# Ice Book 记账应用 - 快速演示脚本

echo "🎯 Ice Book 记账应用快速演示"
echo "================================"
echo ""

# 检查Flutter
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter未安装"
    exit 1
fi

# 获取依赖
echo "📦 获取依赖..."
flutter pub get

# 显示项目信息
echo ""
echo "📊 项目信息："
echo "- 应用名称：Ice Book 智能记账"
echo "- 开发框架：Flutter 3.0+"
echo "- 支持平台：iOS、Android、macOS、Web"
echo "- 主要功能：记账、分类、统计、资产管理"
echo ""

# 显示可用设备
echo "📱 可用设备："
flutter devices
echo ""

# 自动选择最佳平台运行
echo "🚀 自动启动应用..."
if flutter devices | grep -q "macOS"; then
    echo "🖥️ 在macOS上运行..."
    flutter run -d macos
elif flutter devices | grep -q "Chrome"; then
    echo "🌐 在Chrome浏览器上运行..."
    flutter run -d chrome
elif flutter devices | grep -q "iPhone"; then
    echo "📱 在iOS模拟器上运行..."
    flutter run -d "iPhone"
elif flutter devices | grep -q "android"; then
    echo "🤖 在Android模拟器上运行..."
    flutter run -d "android"
else
    echo "❌ 未找到可用设备"
    echo "💡 请确保已连接设备或启动模拟器"
    echo ""
    echo "📋 可用的运行命令："
    echo "  flutter run -d macos    # macOS桌面应用"
    echo "  flutter run -d chrome   # Web浏览器应用"
    echo "  flutter run -d iPhone   # iOS模拟器"
    echo "  flutter run -d android  # Android模拟器"
fi 