#!/bin/bash

# Ice Book 记账应用 - iOS版本运行脚本

echo "📱 启动 Ice Book 记账应用 (iOS版本)..."

# 检查Flutter是否安装
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter未安装，请先安装Flutter SDK"
    echo "📖 安装指南: https://flutter.dev/docs/get-started/install"
    exit 1
fi

# 检查Xcode是否安装
if ! command -v xcrun &> /dev/null; then
    echo "❌ Xcode未安装，请先安装Xcode"
    echo "📖 安装指南: 从App Store安装Xcode"
    exit 1
fi

# 获取依赖
echo "📦 获取项目依赖..."
flutter pub get

# 检查iOS模拟器
echo "📱 检查iOS模拟器..."
xcrun simctl list devices

# 启动iOS模拟器
echo "🚀 启动iOS模拟器..."
open -a Simulator

# 等待模拟器启动
echo "⏳ 等待模拟器启动..."
sleep 5

# 显示可用的iOS设备
echo "📋 可用的iOS设备："
flutter devices | grep -i iphone

# 运行应用
echo "🎯 在iOS模拟器上运行应用..."
echo "💡 提示："
echo "   - 按 'r' 热重载"
echo "   - 按 'R' 热重启"
echo "   - 按 'q' 退出"
echo ""

# 尝试在iPhone 16 Pro上运行
if flutter devices | grep -q "iPhone 16 Pro"; then
    echo "📱 在iPhone 16 Pro上运行..."
    flutter run -d "iPhone 16 Pro"
elif flutter devices | grep -q "iPhone 16"; then
    echo "📱 在iPhone 16上运行..."
    flutter run -d "iPhone 16"
elif flutter devices | grep -q "iPhone"; then
    echo "📱 在可用iPhone上运行..."
    flutter run -d "iPhone"
else
    echo "❌ 未找到可用的iPhone模拟器"
    echo "💡 请确保iOS模拟器已启动"
    echo ""
    echo "📋 可用的运行命令："
    echo "  flutter run -d 'iPhone 16 Pro'"
    echo "  flutter run -d 'iPhone 16'"
    echo "  flutter run -d 'iPhone'"
fi 