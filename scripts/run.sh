#!/bin/bash

# Ice Book 记账应用运行脚本

echo "=== Ice Book 记账应用 ==="
echo "正在检查环境..."

# 检查Flutter是否安装
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter未安装"
    echo "选择安装方式:"
    echo "1. 使用快速安装脚本 (推荐，使用国内镜像)"
    echo "2. 使用完整安装脚本"
    echo "3. 手动安装"
    
    read -p "请选择 (1-3): " choice
    
    case $choice in
        1)
            echo "使用快速安装脚本..."
            if [ -f "./quick_install_flutter.sh" ]; then
                ./quick_install_flutter.sh
            elif [ -f "../scripts/quick_install_flutter.sh" ]; then
                ../scripts/quick_install_flutter.sh
            else
                echo "❌ 快速安装脚本不存在"
                exit 1
            fi
            ;;
        2)
            echo "使用完整安装脚本..."
            if [ -f "./install_flutter.sh" ]; then
                ./install_flutter.sh
            elif [ -f "../scripts/install_flutter.sh" ]; then
                ../scripts/install_flutter.sh
            else
                echo "❌ 完整安装脚本不存在"
                exit 1
            fi
            ;;
        3)
            echo "请手动安装Flutter:"
            echo "1. 访问: https://flutter.dev/docs/get-started/install"
            echo "2. 或使用Homebrew: brew install flutter"
            exit 1
            ;;
        *)
            echo "无效选择，退出"
            exit 1
            ;;
    esac
    
    # 重新检查Flutter是否安装成功
    if ! command -v flutter &> /dev/null; then
        echo "❌ Flutter安装失败，请检查安装过程"
        exit 1
    fi
fi

echo "✅ Flutter已安装"

# 检查Flutter环境
echo "正在检查Flutter环境..."
flutter doctor

# 获取依赖
echo "正在获取依赖..."
flutter pub get

# 检查是否有可用的设备
echo "正在检查可用设备..."
flutter devices

# 运行应用
echo "正在启动应用..."
echo "选择运行平台:"
echo "1. iOS模拟器"
echo "2. Android模拟器"
echo "3. Chrome浏览器"
echo "4. 自动选择"

read -p "请选择 (1-4): " choice

case $choice in
    1)
        echo "启动iOS模拟器..."
        flutter run -d ios
        ;;
    2)
        echo "启动Android模拟器..."
        flutter run -d android
        ;;
    3)
        echo "启动Chrome浏览器..."
        flutter run -d chrome
        ;;
    4)
        echo "自动选择设备..."
        flutter run
        ;;
    *)
        echo "无效选择，使用自动选择..."
        flutter run
        ;;
esac 