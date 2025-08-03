# Ice Book 记账应用

一个基于 Flutter 开发的跨平台记账应用，支持 iOS、Android 和 Web 平台。

## 🚀 快速开始

### 一键启动
```bash
chmod +x start.sh
./start.sh
```

选择菜单中的选项：
- `1` - 快速安装Flutter (推荐)
- `3` - 运行记账应用

## 📁 项目结构

```
ice-book/
├── start.sh                    # 主运行脚本
├── scripts/                    # 脚本文件夹
│   ├── quick_install_flutter.sh    # 快速安装Flutter
│   ├── install_flutter.sh          # 完整安装Flutter
│   ├── run.sh                      # 运行应用脚本
│   └── Flutter安装说明.md          # 安装说明文档
├── lib/                       # 应用源代码
│   ├── models/                # 数据模型
│   ├── providers/             # 状态管理
│   ├── screens/               # 页面
│   ├── services/              # 服务层
│   ├── utils/                 # 工具类
│   └── main.dart              # 应用入口
├── assets/                    # 资源文件
├── pubspec.yaml               # 项目配置
└── 系统使用文档.md            # 详细使用文档
```

## 🛠️ 环境要求

- **macOS**: 10.15+ (推荐 macOS 12+)
- **内存**: 8GB+ RAM
- **存储**: 至少 2GB 可用空间

## 📦 安装方式

### 方式一：使用主脚本 (推荐)
```bash
./start.sh
```

### 方式二：直接使用脚本
```bash
# 快速安装Flutter
./scripts/quick_install_flutter.sh

# 运行应用
./scripts/run.sh
```

### 方式三：手动安装
```bash
# 安装Flutter
brew install flutter

# 获取依赖
flutter pub get

# 运行应用
flutter run
```

## 🎯 功能特性

### 核心功能
- ✅ 收入支出记录管理
- ✅ 多账户支持（现金、银行、信用卡、投资）
- ✅ 分类统计和图表展示
- ✅ 月度收支统计
- ✅ 本地数据存储
- ✅ 响应式UI设计

### 技术特性
- 🎯 Flutter 3.0+ 跨平台开发
- 📊 SQLite 本地数据库
- 🎨 Material Design 3 UI
- 📈 图表可视化
- 🔄 Provider 状态管理

## 📱 使用指南

### 记账功能
1. 点击主页面右下角的 "+" 按钮
2. 选择交易类型（收入/支出）
3. 选择分类（餐饮、交通、购物等）
4. 输入金额和备注
5. 选择账户（可选）
6. 点击"保存"

### 统计功能
- 切换到"统计"标签页
- 查看月度收支汇总
- 查看支出分类饼图
- 查看分类详细列表

### 账户管理
- 切换到"账户"标签页
- 添加不同类型的账户
- 管理账户余额和设置

## 🔧 开发指南

### 项目结构说明
- `lib/models/` - 数据模型定义
- `lib/providers/` - 状态管理
- `lib/screens/` - 页面组件
- `lib/services/` - 业务逻辑
- `lib/utils/` - 工具函数

### 添加新功能
1. 在 `lib/models/` 中添加数据模型
2. 在 `lib/providers/` 中添加状态管理
3. 在 `lib/screens/` 中添加页面
4. 在 `lib/services/` 中添加服务逻辑

### 代码规范
- 使用 Dart 官方代码规范
- 类名使用 PascalCase
- 变量名使用 camelCase
- 文件名使用 snake_case

## 🐛 常见问题

### Q1: Flutter安装失败
**A**: 使用快速安装脚本，它会自动尝试多个国内镜像源。

### Q2: 应用运行缓慢
**A**: 
- 检查设备性能
- 关闭不必要的后台应用
- 使用 Release 模式运行：`flutter run --release`

### Q3: 数据库错误
**A**: 
- 清除应用数据：`flutter clean`
- 重新获取依赖：`flutter pub get`

### Q4: 网络下载问题
**A**: 使用 `./scripts/quick_install_flutter.sh` 脚本，它使用国内镜像源。

## 📚 文档

- [系统使用文档](系统使用文档.md) - 详细的使用说明
- [Flutter安装说明](scripts/Flutter安装说明.md) - Flutter安装指南
- [设计文档](Flutter记账应用设计文档.md) - 应用设计文档

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可证

MIT License

---

**注意**: 本项目专门为macOS设计，其他系统请参考Flutter官方文档。 