#!/bin/bash

# CocoaPods 一键安装脚本 (支持 macOS Intel/Apple Silicon)
# 功能：自动检测环境，用最快的方式安装 CocoaPods
# 用法：保存为 install_cocoapods.sh，运行 chmod +x install_cocoapods.sh && ./install_cocoapods.sh

# 定义颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# 检测是否在国内网络
check_in_china() {
  if curl -m 5 -s "https://www.google.com" > /dev/null; then
    return 1 # 能访问 Google，不在国内
  else
    return 0 # 在国内
  fi
}

# 安装 Homebrew（如果未安装）
install_brew() {
  if ! command -v brew &> /dev/null; then
    echo -e "${YELLOW}正在安装 Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # 添加 Homebrew 到 PATH
    if [[ "$(uname -m)" == "arm64" ]]; then
      echo 'export PATH="/opt/homebrew/bin:$PATH"' >> ~/.zshrc
    else
      echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.zshrc
    fi
    source ~/.zshrc
  fi
}

# 通过 Homebrew 安装 CocoaPods
install_via_brew() {
  echo -e "${YELLOW}尝试通过 Homebrew 安装 CocoaPods...${NC}"
  brew install cocoapods
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}Homebrew 安装成功！${NC}"
    # 确保 pod 命令可用
    brew link --overwrite cocoapods
  else
    echo -e "${RED}Homebrew 安装失败，尝试 RubyGems...${NC}"
    install_via_gem
  fi
}

# 通过 RubyGems 安装 CocoaPods
install_via_gem() {
  echo -e "${YELLOW}正在检查 Ruby 环境...${NC}"
  # 确保使用最新 Ruby（非系统自带）
  brew install ruby
  echo 'export PATH="/usr/local/opt/ruby/bin:$PATH"' >> ~/.zshrc
  source ~/.zshrc

  # 替换 RubyGems 镜像源（国内用户）
  if check_in_china; then
    echo -e "${YELLOW}检测到国内网络，切换 RubyGems 镜像源...${NC}"
    gem sources --add https://mirrors.tuna.tsinghua.edu.cn/rubygems/ --remove https://rubygems.org/
  fi

  echo -e "${YELLOW}通过 RubyGems 安装 CocoaPods...${NC}"
  sudo gem install cocoapods -n /usr/local/bin

  # 如果 sudo 报错，尝试用户安装
  if [ $? -ne 0 ]; then
    echo -e "${YELLOW}尝试用户权限安装...${NC}"
    gem install cocoapods --user-install
    ruby_version=$(ruby -v | grep -o '\d\.\d\.\d')
    echo "export PATH=\"\$HOME/.gem/ruby/${ruby_version}/bin:\$PATH\"" >> ~/.zshrc
    source ~/.zshrc
  fi
}

# 初始化 CocoaPods
init_cocoapods() {
  echo -e "${YELLOW}正在初始化 CocoaPods...${NC}"
  # 国内用户使用镜像加速
  if check_in_china; then
    mkdir -p ~/.cocoapods/repos
    cd ~/.cocoapods/repos
    git clone --depth 1 https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git master
    cd -
    pod repo update
  else
    pod setup
  fi
}

# 主函数
main() {
  echo -e "\n${GREEN}====== CocoaPods 一键安装脚本 ======${NC}"
  
  # 1. 安装 Homebrew
  install_brew
  
  # 2. 优先尝试 Homebrew 安装
  install_via_brew
  
  # 3. 验证安装
  if command -v pod &> /dev/null; then
    echo -e "${GREEN}CocoaPods 安装成功！版本信息：${NC}"
    pod --version
    # 4. 初始化
    init_cocoapods
  else
    echo -e "${RED}安装失败，请检查错误日志！${NC}"
    exit 1
  fi
  
  echo -e "${GREEN}\n完成！请重新打开终端使配置生效。${NC}"
}

# 执行主函数
main