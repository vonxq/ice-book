# Flutter 安装说明

## 问题描述

在macOS上通过Homebrew安装Flutter时，经常会遇到网络下载卡住的问题，这是因为官方源在国内访问较慢。

## 解决方案

我们提供了三个安装脚本来解决这个问题：

### 1. 快速安装脚本 (推荐)

**文件名**: `quick_install_flutter.sh`

**特点**:
- 使用国内镜像源
- 自动重试多个镜像
- 简化安装流程
- 适合网络环境较差的情况

**使用方法**:
```bash
chmod +x quick_install_flutter.sh
./quick_install_flutter.sh
```

### 2. 完整安装脚本

**文件名**: `install_flutter.sh`

**特点**:
- 支持官方源和镜像源
- 智能网络检测
- 详细的安装日志
- 完整的错误处理

**使用方法**:
```bash
chmod +x install_flutter.sh
./install_flutter.sh
```

### 3. 自动运行脚本

**文件名**: `run.sh`

**特点**:
- 自动检测Flutter是否安装
- 提供多种安装选择
- 自动运行应用

**使用方法**:
```bash
chmod +x run.sh
./run.sh
```

## 镜像源说明

### 国内镜像源
1. **Flutter中国镜像**: `https://storage.flutter-io.cn/`
2. **清华大学镜像**: `https://mirrors.tuna.tsinghua.edu.cn/flutter/`
3. **中科大镜像**: `https://mirrors.ustc.edu.cn/flutter/`

### 官方源
- **Google官方**: `https://storage.googleapis.com/flutter_infra_release/`

## 安装步骤

### 方法一：使用快速安装脚本

1. **下载脚本**:
   ```bash
   # 脚本已包含在项目中
   ls -la *.sh
   ```

2. **执行安装**:
   ```bash
   ./quick_install_flutter.sh
   ```

3. **验证安装**:
   ```bash
   source ~/.zshrc  # 或 source ~/.bashrc
   flutter --version
   ```

### 方法二：使用完整安装脚本

1. **执行安装**:
   ```bash
   ./install_flutter.sh
   ```

2. **按提示操作**:
   - 选择是否重新安装
   - 选择是否运行flutter doctor
   - 选择是否清理下载文件

### 方法三：使用自动运行脚本

1. **运行应用**:
   ```bash
   ./run.sh
   ```

2. **如果Flutter未安装**:
   - 选择安装方式
   - 按提示完成安装
   - 自动运行应用

## 网络配置

### 设置代理 (如果需要)

```bash
# 设置HTTP代理
export http_proxy=http://127.0.0.1:7890
export https_proxy=http://127.0.0.1:7890
export all_proxy=socks5://127.0.0.1:7890

# 设置Flutter镜像
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
```

### 永久设置代理

将以下内容添加到 `~/.zshrc` 或 `~/.bashrc`:

```bash
# Flutter镜像设置
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn

# 代理设置 (根据实际情况修改)
# export http_proxy=http://127.0.0.1:7890
# export https_proxy=http://127.0.0.1:7890
# export all_proxy=socks5://127.0.0.1:7890
```

## 常见问题

### Q1: 下载速度很慢
**A**: 使用快速安装脚本，它会自动尝试多个国内镜像源。

### Q2: 下载中断
**A**: 重新运行脚本，它会自动重试不同的镜像源。

### Q3: 解压失败
**A**: 检查磁盘空间是否充足，确保有至少2GB可用空间。

### Q4: 环境变量不生效
**A**: 重启终端或运行 `source ~/.zshrc`。

### Q5: flutter doctor 报错
**A**: 根据错误信息安装相应的开发工具：
- iOS开发：安装Xcode
- Android开发：安装Android Studio

## 验证安装

安装完成后，运行以下命令验证：

```bash
# 检查Flutter版本
flutter --version

# 检查环境
flutter doctor

# 测试项目
flutter pub get
flutter run
```

## 脚本功能对比

| 功能 | 快速安装 | 完整安装 | 自动运行 |
|------|----------|----------|----------|
| 国内镜像 | ✅ | ✅ | ✅ |
| 官方源 | ❌ | ✅ | ✅ |
| 网络检测 | ❌ | ✅ | ❌ |
| 详细日志 | ❌ | ✅ | ❌ |
| 自动重试 | ✅ | ✅ | ✅ |
| 环境配置 | ✅ | ✅ | ✅ |
| 应用运行 | ❌ | ❌ | ✅ |

## 推荐使用流程

1. **首次安装**: 使用 `quick_install_flutter.sh`
2. **日常使用**: 使用 `run.sh`
3. **问题排查**: 使用 `install_flutter.sh`

## 技术支持

如果遇到问题，请：
1. 检查网络连接
2. 查看脚本输出的错误信息
3. 尝试不同的镜像源
4. 确保系统权限正确

---

**注意**: 这些脚本专门为macOS设计，其他系统请参考Flutter官方文档。 