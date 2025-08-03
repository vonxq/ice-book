#!/bin/bash

# Ice Book 记账应用运行脚本

echo "🚀 启动 Ice Book 记账应用..."

# 检查Flutter是否安装
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter未安装，请先安装Flutter SDK"
    echo "📖 安装指南: https://flutter.dev/docs/get-started/install"
    exit 1
fi

# 检查Flutter版本
echo "📋 检查Flutter版本..."
flutter --version

# 获取依赖
echo "📦 获取项目依赖..."
flutter pub get

# 检查设备
echo "📱 检查可用设备..."
flutter devices

# 运行应用
echo "🎯 启动应用..."
echo "💡 提示："
echo "   - 按 'r' 热重载"
echo "   - 按 'R' 热重启"
echo "   - 按 'q' 退出"
echo ""

# 尝试在不同平台上运行
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
    echo "🖥️ 在可用设备上运行..."
    flutter run
fi 