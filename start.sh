#!/bin/bash

# Ice Book 记账应用 - 主运行脚本
# 统一管理所有脚本和配置

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 脚本目录
SCRIPT_DIR="scripts"

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

# 检查脚本目录
check_script_dir() {
    if [ ! -d "$SCRIPT_DIR" ]; then
        log_error "脚本目录不存在: $SCRIPT_DIR"
        exit 1
    fi
}

# 显示菜单
show_menu() {
    echo ""
    echo "=== Ice Book 记账应用 ==="
    echo "请选择要执行的操作:"
    echo ""
    echo "1. 🚀 快速安装Flutter (推荐)"
    echo "2. 📦 完整安装Flutter"
    echo "3. 🎯 运行记账应用"
    echo "4. 📋 查看安装说明"
    echo "5. 🔧 检查环境"
    echo "6. 🧹 清理缓存"
    echo "0. ❌ 退出"
    echo ""
}

# 快速安装Flutter
quick_install_flutter() {
    log_info "执行快速安装Flutter..."
    if [ -f "$SCRIPT_DIR/quick_install_flutter.sh" ]; then
        chmod +x "$SCRIPT_DIR/quick_install_flutter.sh"
        "$SCRIPT_DIR/quick_install_flutter.sh"
    else
        log_error "快速安装脚本不存在"
        exit 1
    fi
}

# 完整安装Flutter
full_install_flutter() {
    log_info "执行完整安装Flutter..."
    if [ -f "$SCRIPT_DIR/install_flutter.sh" ]; then
        chmod +x "$SCRIPT_DIR/install_flutter.sh"
        "$SCRIPT_DIR/install_flutter.sh"
    else
        log_error "完整安装脚本不存在"
        exit 1
    fi
}

# 运行应用
run_app() {
    log_info "运行记账应用..."
    if [ -f "$SCRIPT_DIR/run.sh" ]; then
        chmod +x "$SCRIPT_DIR/run.sh"
        "$SCRIPT_DIR/run.sh"
    else
        log_error "运行脚本不存在"
        exit 1
    fi
}

# 查看安装说明
show_install_guide() {
    log_info "显示安装说明..."
    if [ -f "$SCRIPT_DIR/Flutter安装说明.md" ]; then
        cat "$SCRIPT_DIR/Flutter安装说明.md"
    else
        log_error "安装说明文件不存在"
        exit 1
    fi
}

# 检查环境
check_environment() {
    log_info "检查Flutter环境..."
    
    # 检查Flutter是否安装
    if command -v flutter &> /dev/null; then
        log_success "Flutter已安装"
        flutter --version
    else
        log_warning "Flutter未安装"
    fi
    
    # 检查Flutter环境
    if command -v flutter &> /dev/null; then
        log_info "运行flutter doctor..."
        flutter doctor
    fi
    
    # 检查项目依赖
    if [ -f "pubspec.yaml" ]; then
        log_info "检查项目依赖..."
        flutter pub get
    fi
}

# 清理缓存
clean_cache() {
    log_info "清理Flutter缓存..."
    
    # 清理Flutter缓存
    if command -v flutter &> /dev/null; then
        flutter clean
        flutter pub get
        log_success "Flutter缓存清理完成"
    else
        log_warning "Flutter未安装，跳过清理"
    fi
    
    # 清理下载目录
    if [ -d "$HOME/Downloads/flutter_download" ]; then
        rm -rf "$HOME/Downloads/flutter_download"
        log_success "下载目录清理完成"
    fi
}

# 主函数
main() {
    check_script_dir
    
    while true; do
        show_menu
        read -p "请输入选项 (0-6): " choice
        
        case $choice in
            1)
                quick_install_flutter
                ;;
            2)
                full_install_flutter
                ;;
            3)
                run_app
                ;;
            4)
                show_install_guide
                ;;
            5)
                check_environment
                ;;
            6)
                clean_cache
                ;;
            0)
                log_info "退出程序"
                exit 0
                ;;
            *)
                log_error "无效选项，请重新选择"
                ;;
        esac
        
        echo ""
        read -p "按回车键继续..."
    done
}

# 错误处理
trap 'log_error "脚本执行失败，请检查错误信息"; exit 1' ERR

# 运行主函数
main "$@" 