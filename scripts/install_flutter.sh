#!/bin/bash

# Flutter 安装脚本
# 支持多种下载方式和镜像源

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查系统架构
check_architecture() {
    local arch=$(uname -m)
    if [[ "$arch" == "arm64" ]]; then
        FLUTTER_ARCH="arm64"
        FLUTTER_PLATFORM="macos"
    elif [[ "$arch" == "x86_64" ]]; then
        FLUTTER_ARCH="x64"
        FLUTTER_PLATFORM="macos"
    else
        log_error "不支持的架构: $arch"
        exit 1
    fi
    log_info "检测到架构: $arch"
}

# 设置Flutter版本
set_flutter_version() {
    FLUTTER_VERSION="3.32.8"
    FLUTTER_FILENAME="flutter_${FLUTTER_PLATFORM}_${FLUTTER_ARCH}_${FLUTTER_VERSION}-stable.zip"
    log_info "Flutter版本: $FLUTTER_VERSION"
}

# 设置下载目录
set_download_dir() {
    FLUTTER_DIR="$HOME/flutter"
    DOWNLOAD_DIR="$HOME/Downloads/flutter_download"
    log_info "下载目录: $DOWNLOAD_DIR"
    log_info "安装目录: $FLUTTER_DIR"
}

# 创建目录
create_directories() {
    mkdir -p "$DOWNLOAD_DIR"
    log_success "创建下载目录完成"
}

# 检查网络连接
check_network() {
    log_info "检查网络连接..."
    if curl -s --connect-timeout 5 https://www.google.com > /dev/null; then
        log_success "网络连接正常"
        return 0
    else
        log_warning "网络连接异常，将使用国内镜像"
        return 1
    fi
}

# 下载Flutter (官方源)
download_flutter_official() {
    local url="https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_${FLUTTER_PLATFORM}_${FLUTTER_ARCH}_${FLUTTER_VERSION}-stable.zip"
    local file="$DOWNLOAD_DIR/$FLUTTER_FILENAME"
    
    log_info "从官方源下载Flutter..."
    log_info "下载地址: $url"
    
    if curl -L -o "$file" --progress-bar "$url"; then
        log_success "下载完成: $file"
        return 0
    else
        log_error "官方源下载失败"
        return 1
    fi
}

# 下载Flutter (国内镜像)
download_flutter_mirror() {
    local mirrors=(
        "https://storage.flutter-io.cn/flutter_infra_release/releases/stable/macos/flutter_${FLUTTER_PLATFORM}_${FLUTTER_ARCH}_${FLUTTER_VERSION}-stable.zip"
        "https://mirrors.tuna.tsinghua.edu.cn/flutter/flutter_infra_release/releases/stable/macos/flutter_${FLUTTER_PLATFORM}_${FLUTTER_ARCH}_${FLUTTER_VERSION}-stable.zip"
        "https://mirrors.ustc.edu.cn/flutter/flutter_infra_release/releases/stable/macos/flutter_${FLUTTER_PLATFORM}_${FLUTTER_ARCH}_${FLUTTER_VERSION}-stable.zip"
    )
    
    local file="$DOWNLOAD_DIR/$FLUTTER_FILENAME"
    
    for mirror in "${mirrors[@]}"; do
        log_info "尝试从镜像下载: $mirror"
        if curl -L -o "$file" --progress-bar --connect-timeout 30 "$mirror"; then
            log_success "镜像下载完成: $file"
            return 0
        else
            log_warning "镜像下载失败，尝试下一个..."
        fi
    done
    
    log_error "所有镜像源都下载失败"
    return 1
}

# 解压Flutter
extract_flutter() {
    local file="$DOWNLOAD_DIR/$FLUTTER_FILENAME"
    local extract_dir="$HOME"
    
    log_info "解压Flutter到: $extract_dir"
    
    if unzip -q "$file" -d "$extract_dir"; then
        log_success "解压完成"
        return 0
    else
        log_error "解压失败"
        return 1
    fi
}

# 配置环境变量
setup_environment() {
    local shell_rc=""
    
    # 检测shell类型
    if [[ "$SHELL" == *"zsh"* ]]; then
        shell_rc="$HOME/.zshrc"
    elif [[ "$SHELL" == *"bash"* ]]; then
        shell_rc="$HOME/.bashrc"
    else
        shell_rc="$HOME/.profile"
    fi
    
    log_info "配置环境变量到: $shell_rc"
    
    # 检查是否已经配置
    if grep -q "flutter/bin" "$shell_rc" 2>/dev/null; then
        log_warning "Flutter环境变量已存在"
        return 0
    fi
    
    # 添加环境变量
    echo "" >> "$shell_rc"
    echo "# Flutter环境变量" >> "$shell_rc"
    echo "export PATH=\"\$PATH:\$HOME/flutter/bin\"" >> "$shell_rc"
    
    log_success "环境变量配置完成"
    
    # 提示用户
    log_info "请运行以下命令使环境变量生效:"
    echo "source $shell_rc"
}

# 验证安装
verify_installation() {
    log_info "验证Flutter安装..."
    
    # 临时添加PATH
    export PATH="$PATH:$HOME/flutter/bin"
    
    if flutter --version > /dev/null 2>&1; then
        log_success "Flutter安装成功!"
        flutter --version
        return 0
    else
        log_error "Flutter安装验证失败"
        return 1
    fi
}

# 清理下载文件
cleanup() {
    log_info "清理下载文件..."
    rm -rf "$DOWNLOAD_DIR"
    log_success "清理完成"
}

# 运行Flutter doctor
run_flutter_doctor() {
    log_info "运行Flutter doctor检查环境..."
    export PATH="$PATH:$HOME/flutter/bin"
    flutter doctor
}

# 主函数
main() {
    echo "=== Flutter 安装脚本 ==="
    echo "支持macOS ARM64/x64架构"
    echo ""
    
    # 检查是否已安装
    if command -v flutter &> /dev/null; then
        log_warning "Flutter已安装，版本信息:"
        flutter --version
        read -p "是否重新安装? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "取消安装"
            exit 0
        fi
    fi
    
    # 执行安装步骤
    check_architecture
    set_flutter_version
    set_download_dir
    create_directories
    
    # 尝试下载
    if check_network; then
        if download_flutter_official; then
            log_success "官方源下载成功"
        else
            log_warning "官方源下载失败，尝试镜像源"
            if ! download_flutter_mirror; then
                log_error "所有下载源都失败"
                exit 1
            fi
        fi
    else
        if ! download_flutter_mirror; then
            log_error "镜像源下载失败"
            exit 1
        fi
    fi
    
    # 解压和配置
    if extract_flutter && setup_environment; then
        log_success "Flutter安装完成!"
        
        # 询问是否运行flutter doctor
        read -p "是否运行flutter doctor检查环境? (Y/n): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Nn]$ ]]; then
            run_flutter_doctor
        fi
        
        # 询问是否清理下载文件
        read -p "是否清理下载文件? (Y/n): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Nn]$ ]]; then
            cleanup
        fi
        
        log_info "安装完成! 请重启终端或运行 'source ~/.zshrc' 使环境变量生效"
    else
        log_error "安装失败"
        exit 1
    fi
}

# 错误处理
trap 'log_error "脚本执行失败，请检查错误信息"; exit 1' ERR

# 运行主函数
main "$@" 