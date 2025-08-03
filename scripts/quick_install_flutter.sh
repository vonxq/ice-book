#!/bin/bash

# Flutter 快速安装脚本
# 使用国内镜像源，解决网络问题

echo "=== Flutter 快速安装脚本 ==="
echo "使用国内镜像源，解决网络下载问题"
echo ""

# 检查架构
ARCH=$(uname -m)
if [[ "$ARCH" == "arm64" ]]; then
    FLUTTER_ARCH="arm64"
elif [[ "$ARCH" == "x86_64" ]]; then
    FLUTTER_ARCH="x64"
else
    echo "❌ 不支持的架构: $ARCH"
    exit 1
fi

echo "✅ 检测到架构: $ARCH"

# 设置变量
FLUTTER_VERSION="3.32.8"
FLUTTER_FILENAME="flutter_macos_${FLUTTER_ARCH}_${FLUTTER_VERSION}-stable.zip"
DOWNLOAD_DIR="$HOME/Downloads/flutter_download"
FLUTTER_DIR="$HOME/flutter"

# 创建下载目录
mkdir -p "$DOWNLOAD_DIR"
echo "✅ 创建下载目录: $DOWNLOAD_DIR"

# 国内镜像源列表
MIRRORS=(
    "https://storage.flutter-io.cn/flutter_infra_release/releases/stable/macos/${FLUTTER_FILENAME}"
    "https://mirrors.tuna.tsinghua.edu.cn/flutter/flutter_infra_release/releases/stable/macos/${FLUTTER_FILENAME}"
    "https://mirrors.ustc.edu.cn/flutter/flutter_infra_release/releases/stable/macos/${FLUTTER_FILENAME}"
)

# 下载函数
download_flutter() {
    local file="$DOWNLOAD_DIR/$FLUTTER_FILENAME"
    
    for mirror in "${MIRRORS[@]}"; do
        echo "🔄 尝试从镜像下载: $(basename $mirror)"
        if curl -L -o "$file" --progress-bar --connect-timeout 30 "$mirror"; then
            echo "✅ 下载成功: $file"
            return 0
        else
            echo "❌ 下载失败，尝试下一个镜像..."
        fi
    done
    
    echo "❌ 所有镜像源都下载失败"
    return 1
}

# 解压函数
extract_flutter() {
    local file="$DOWNLOAD_DIR/$FLUTTER_FILENAME"
    echo "📦 解压Flutter到: $HOME"
    
    if unzip -q "$file" -d "$HOME"; then
        echo "✅ 解压完成"
        return 0
    else
        echo "❌ 解压失败"
        return 1
    fi
}

# 配置环境变量
setup_environment() {
    local shell_rc=""
    
    if [[ "$SHELL" == *"zsh"* ]]; then
        shell_rc="$HOME/.zshrc"
    elif [[ "$SHELL" == *"bash"* ]]; then
        shell_rc="$HOME/.bashrc"
    else
        shell_rc="$HOME/.profile"
    fi
    
    echo "🔧 配置环境变量到: $shell_rc"
    
    # 检查是否已配置
    if grep -q "flutter/bin" "$shell_rc" 2>/dev/null; then
        echo "⚠️  Flutter环境变量已存在"
        return 0
    fi
    
    # 添加环境变量
    echo "" >> "$shell_rc"
    echo "# Flutter环境变量" >> "$shell_rc"
    echo "export PATH=\"\$PATH:\$HOME/flutter/bin\"" >> "$shell_rc"
    
    echo "✅ 环境变量配置完成"
}

# 验证安装
verify_installation() {
    echo "🔍 验证Flutter安装..."
    export PATH="$PATH:$HOME/flutter/bin"
    
    if flutter --version > /dev/null 2>&1; then
        echo "✅ Flutter安装成功!"
        flutter --version
        return 0
    else
        echo "❌ Flutter安装验证失败"
        return 1
    fi
}

# 清理文件
cleanup() {
    echo "🧹 清理下载文件..."
    rm -rf "$DOWNLOAD_DIR"
    echo "✅ 清理完成"
}

# 主流程
echo "🚀 开始安装Flutter..."

# 检查是否已安装
if command -v flutter &> /dev/null; then
    echo "⚠️  Flutter已安装:"
    flutter --version
    read -p "是否重新安装? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "取消安装"
        exit 0
    fi
fi

# 执行安装
if download_flutter && extract_flutter && setup_environment; then
    echo "🎉 Flutter安装完成!"
    
    # 验证安装
    if verify_installation; then
        echo ""
        echo "📋 安装完成! 请执行以下命令:"
        echo "1. 重启终端 或 运行: source ~/.zshrc"
        echo "2. 运行: flutter doctor"
        echo "3. 运行: flutter pub get"
        echo "4. 运行: ./run.sh"
        
        # 询问是否清理
        read -p "是否清理下载文件? (Y/n): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Nn]$ ]]; then
            cleanup
        fi
    else
        echo "❌ 安装验证失败"
        exit 1
    fi
else
    echo "❌ 安装失败"
    exit 1
fi 