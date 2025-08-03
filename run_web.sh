#!/bin/bash

# Ice Book 记账应用 - Web版本运行脚本

echo "🌐 启动 Ice Book 记账应用 (Web版本)..."

# 检查Flutter是否安装
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter未安装，请先安装Flutter SDK"
    echo "📖 安装指南: https://flutter.dev/docs/get-started/install"
    exit 1
fi

# 获取依赖
echo "📦 获取项目依赖..."
flutter pub get

# 构建Web版本
echo "🔨 构建Web版本..."
flutter build web

# 启动本地服务器
echo "🚀 启动本地服务器..."
echo "📱 应用将在浏览器中打开: http://localhost:8080"
echo "💡 提示：按 Ctrl+C 停止服务器"
echo ""

# 使用Python的简单HTTP服务器
if command -v python3 &> /dev/null; then
    cd build/web && python3 -m http.server 8080
elif command -v python &> /dev/null; then
    cd build/web && python -m http.server 8080
else
    echo "❌ 未找到Python，请手动打开 build/web/index.html"
    echo "💡 或者安装Python后重新运行此脚本"
fi 