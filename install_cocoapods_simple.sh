#!/bin/bash

# 简单的 CocoaPods 安装脚本
# 避免权限问题，使用用户级安装

echo "🍎 开始安装 CocoaPods..."

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# 检查是否已经安装
if command -v pod &> /dev/null; then
    echo -e "${GREEN}✅ CocoaPods 已经安装${NC}"
    pod --version
    exit 0
fi

# 方法1: 尝试用户级安装
echo -e "${YELLOW}📦 尝试用户级安装 CocoaPods...${NC}"

# 确保使用用户目录
export GEM_HOME="$HOME/.gem"
export PATH="$GEM_HOME/bin:$PATH"

# 安装 CocoaPods
gem install cocoapods --user-install

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ 用户级安装成功${NC}"
    
    # 添加到 PATH
    echo 'export PATH="$HOME/.gem/bin:$PATH"' >> ~/.zshrc
    source ~/.zshrc
    
    # 验证安装
    if command -v pod &> /dev/null; then
        echo -e "${GREEN}✅ CocoaPods 安装验证成功${NC}"
        pod --version
        
        # 设置 CocoaPods
        echo -e "${YELLOW}⚙️  设置 CocoaPods...${NC}"
        pod setup --verbose
        
        echo -e "${GREEN}🎉 CocoaPods 安装完成！${NC}"
        echo -e "${YELLOW}💡 请重新打开终端或运行: source ~/.zshrc${NC}"
        exit 0
    else
        echo -e "${RED}❌ 安装验证失败${NC}"
        exit 1
    fi
else
    echo -e "${RED}❌ 用户级安装失败${NC}"
    echo -e "${YELLOW}💡 尝试其他方法...${NC}"
    
    # 方法2: 尝试使用 Homebrew
    if command -v brew &> /dev/null; then
        echo -e "${YELLOW}🍺 尝试使用 Homebrew 安装...${NC}"
        brew install cocoapods
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ Homebrew 安装成功${NC}"
            pod --version
            exit 0
        fi
    fi
    
    echo -e "${RED}❌ 所有安装方法都失败了${NC}"
    echo -e "${YELLOW}💡 请手动安装 CocoaPods:${NC}"
    echo "1. 访问 https://cocoapods.org/"
    echo "2. 按照官方文档安装"
    exit 1
fi 