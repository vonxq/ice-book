#!/bin/bash

# iOS 环境检查脚本

echo "🔍 检查iOS开发环境..."
echo "================================"
echo ""

# 检查Flutter
echo "📋 检查Flutter..."
if command -v flutter &> /dev/null; then
    echo "✅ Flutter已安装"
    flutter --version | head -1
else
    echo "❌ Flutter未安装"
    echo "💡 请访问 https://flutter.dev/docs/get-started/install"
fi
echo ""

# 检查Xcode
echo "📋 检查Xcode..."
if command -v xcrun &> /dev/null; then
    echo "✅ Xcode命令行工具可用"
    xcodebuild -version | head -1
else
    echo "❌ Xcode未安装或未配置"
    echo "💡 请从App Store安装Xcode"
fi
echo ""

# 检查CocoaPods
echo "📋 检查CocoaPods..."
if command -v pod &> /dev/null; then
    echo "✅ CocoaPods已安装"
    pod --version
else
    echo "❌ CocoaPods未安装"
    echo "💡 运行: sudo gem install cocoapods"
fi
echo ""

# 检查iOS模拟器
echo "📋 检查iOS模拟器..."
if xcrun simctl list devices | grep -q "iPhone"; then
    echo "✅ iOS模拟器可用"
    echo "📱 可用的iPhone模拟器："
    xcrun simctl list devices | grep "iPhone" | head -5
else
    echo "❌ 未找到iOS模拟器"
    echo "💡 请确保Xcode已正确安装"
fi
echo ""

# 检查Flutter iOS工具链
echo "📋 检查Flutter iOS工具链..."
flutter doctor | grep -A 5 -B 5 "Xcode"

echo ""
echo "🎯 运行状态："

# 检查是否可以运行iOS应用
if command -v flutter &> /dev/null && command -v xcrun &> /dev/null; then
    echo "✅ 环境配置完成，可以运行iOS应用"
    echo ""
    echo "🚀 运行命令："
    echo "  ./run_ios.sh          # iOS专用启动脚本"
    echo "  ./start.sh            # 平台选择启动器"
    echo "  flutter run -d 'iPhone 16 Pro'  # 直接运行"
else
    echo "❌ 环境配置不完整，请按照提示安装缺失的工具"
    echo ""
    echo "📖 详细安装指南请查看：iOS_SETUP_GUIDE.md"
fi 