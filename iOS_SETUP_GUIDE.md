# iOS 开发环境设置指南

## 🍎 在iOS上运行Ice Book记账应用

要在iOS上运行应用，您需要安装以下工具：

### 1. 安装Xcode

#### 方法一：从App Store安装（推荐）
1. 打开 **App Store**
2. 搜索 "Xcode"
3. 点击安装（大约需要10-15GB空间）
4. 安装完成后启动Xcode一次

#### 方法二：从Apple开发者网站下载
1. 访问 https://developer.apple.com/xcode/
2. 下载最新版本的Xcode
3. 安装并启动Xcode

### 2. 配置Xcode命令行工具

安装Xcode后，运行以下命令：

```bash
# 设置Xcode命令行工具路径
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer

# 运行首次启动配置
sudo xcodebuild -runFirstLaunch
```

### 3. 安装CocoaPods

CocoaPods是iOS开发必需的包管理器：

```bash
# 安装CocoaPods
sudo gem install cocoapods

# 设置CocoaPods
pod setup
```

### 4. 启动iOS模拟器

```bash
# 查看可用的iOS模拟器
xcrun simctl list devices

# 启动iOS模拟器
open -a Simulator
```

### 5. 运行应用

环境配置完成后，您可以使用以下方式运行应用：

#### 方式一：使用平台选择启动器
```bash
./start.sh
```
然后选择 "3. iOS 模拟器"

#### 方式二：直接运行
```bash
# 在iOS模拟器上运行
flutter run -d "iPhone"

# 或者指定具体的模拟器
flutter run -d "iPhone 15 Pro"
```

#### 方式三：快速演示
```bash
./demo_quick.sh
```

## 🔧 故障排除

### 问题1：Xcode未安装
**错误信息：** `xcrun: error: unable to find utility "xcodebuild"`

**解决方案：**
1. 从App Store安装Xcode
2. 安装完成后运行：
   ```bash
   sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
   sudo xcodebuild -runFirstLaunch
   ```

### 问题2：CocoaPods未安装
**错误信息：** `CocoaPods not installed`

**解决方案：**
```bash
sudo gem install cocoapods
pod setup
```

### 问题3：iOS模拟器无法启动
**解决方案：**
1. 确保Xcode已正确安装
2. 启动Xcode并接受许可协议
3. 运行：
   ```bash
   open -a Simulator
   ```

### 问题4：网络连接问题
**解决方案：**
```bash
# 检查网络连接
flutter doctor --android-licenses

# 如果网络有问题，可以跳过网络检查
flutter doctor --no-network
```

## 📱 可用的iOS模拟器

运行以下命令查看可用的iOS模拟器：

```bash
xcrun simctl list devices
```

常见的模拟器包括：
- iPhone 15 Pro
- iPhone 15
- iPhone 14 Pro
- iPhone 14
- iPhone SE (3rd generation)
- iPad Pro (12.9-inch) (6th generation)

## 🚀 快速启动iOS版本

完成环境设置后，您可以使用以下命令快速启动：

```bash
# 1. 检查环境
flutter doctor

# 2. 获取依赖
flutter pub get

# 3. 启动iOS模拟器
open -a Simulator

# 4. 运行应用
flutter run -d "iPhone 15 Pro"
```

## 📋 环境检查清单

在运行iOS应用之前，请确保：

- ✅ Xcode已安装并配置
- ✅ CocoaPods已安装
- ✅ iOS模拟器可用
- ✅ Flutter doctor显示iOS工具链正常

运行以下命令检查环境：

```bash
flutter doctor -v
```

如果所有项目都显示 ✓，那么您就可以在iOS上运行应用了！

## 🎯 下一步

环境配置完成后，您可以：

1. **运行应用** - 使用 `./start.sh` 选择iOS平台
2. **开发调试** - 使用热重载功能 `flutter run -d "iPhone" --hot`
3. **测试功能** - 体验完整的记账应用功能
4. **自定义开发** - 根据需求修改和扩展功能

---

**提示：** 首次安装Xcode可能需要较长时间，请耐心等待。安装完成后，您就可以享受完整的iOS开发体验了！ 