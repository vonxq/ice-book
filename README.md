# 记账应用 - Flutter跨平台记账软件

## 项目简介

记账应用是一款基于Flutter的跨平台记账软件，支持iOS、Android、Web等多端运行。应用提供完整的记账功能，包括收入支出记录、分类管理、数据统计、资产管理等，帮助用户全面管理个人财务。

## 功能特性

### 核心功能
- 📝 **智能记账**: 快速记录收入支出，支持分类管理
- 📊 **数据统计**: 月度/年度收支统计，分类分析
- 📈 **图表展示**: 饼图、柱状图、折线图数据可视化
- 💰 **资产管理**: 现金、银行卡、投资账户等全面管理
- 📅 **日期选择**: 灵活选择记账日期
- 📋 **分类管理**: 预设分类和自定义分类

### 跨平台特性
- 📱 **多端支持**: iOS、Android、Web、Desktop
- ☁️ **云端同步**: Firebase实时数据同步
- 🔒 **数据安全**: 本地加密存储，保护用户隐私
- 📤 **数据导出**: 支持CSV格式导出
- 🎨 **主题切换**: 支持深色/浅色主题

## 技术架构

- **开发框架**: Flutter 3.0+
- **编程语言**: Dart 3.0+
- **状态管理**: Riverpod / Bloc
- **数据存储**: SQLite / Hive / Cloud Firestore
- **UI框架**: Material Design 3 / Cupertino
- **最低支持**: iOS 12.0+, Android 6.0+
- **目标平台**: iOS, Android, Web, Desktop

## 项目结构

```
expense_tracker/
├── lib/                    # 主要代码目录
│   ├── app/               # 应用配置
│   ├── models/            # 数据模型
│   ├── views/             # 视图层
│   ├── providers/         # 状态管理
│   ├── services/          # 业务服务
│   ├── utils/             # 工具类
│   └── resources/         # 资源文件
├── android/               # Android平台配置
├── ios/                   # iOS平台配置
├── web/                   # Web平台配置
├── windows/               # Windows平台配置
├── macos/                 # macOS平台配置
└── linux/                 # Linux平台配置
```

## 开发环境要求

- Flutter 3.0+
- Dart 3.0+
- Android Studio / VS Code
- Xcode (iOS开发)
- Firebase项目 (云端功能)

## 安装和运行

1. 克隆项目
```bash
git clone git@github.com:vonxq/ice-book.git
cd ice-book
```

2. 安装依赖
```bash
flutter pub get
```

3. 配置Firebase (可选)
```bash
flutterfire configure
```

4. 运行项目
```bash
# iOS
flutter run -d ios

# Android
flutter run -d android

# Web
flutter run -d chrome

# Desktop
flutter run -d windows
flutter run -d macos
flutter run -d linux
```

## 开发计划

### 第一阶段 (MVP) - 进行中
- [x] 项目基础架构搭建
- [x] 设计文档完成
- [ ] 数据模型和枚举定义
- [ ] 主页UI实现
- [ ] 记账功能实现

### 第二阶段 (功能完善)
- [ ] 分类管理功能
- [ ] 统计图表功能
- [ ] 日期选择功能
- [ ] 资产管家功能

### 第三阶段 (高级功能)
- [ ] 云端同步实现
- [ ] 数据导出功能
- [ ] 通知提醒功能
- [ ] 多端适配

### 第四阶段 (优化发布)
- [ ] 性能优化
- [ ] 用户体验优化
- [ ] 测试和调试
- [ ] 应用商店发布

## 主要页面

### 记账主页
- 收支概览
- 快速记账按钮
- 最近记录列表
- 功能导航入口

### 记账功能
- 记账弹窗
- 分类选择
- 金额输入
- 日期选择
- 备注输入

### 统计图表
- 收支统计图表
- 分类分析
- 时间筛选
- 数据导出

### 资产管家
- 总资产概览
- 账户列表管理
- 余额调整功能
- 资产详情查看

## 功能模块

### 记账模块
- 收入/支出记录
- 分类管理
- 日期选择
- 备注功能

### 统计模块
- 收支统计
- 分类分析
- 图表展示
- 趋势分析

### 资产模块
- 账户管理
- 余额调整
- 资产统计
- 资产详情

### 设置模块
- 应用设置
- 数据备份
- 主题切换
- 安全设置

## 跨平台特性

### 平台适配
- **iOS**: Cupertino风格UI，原生体验
- **Android**: Material Design 3，现代化界面
- **Web**: 响应式设计，浏览器访问
- **Desktop**: 桌面应用体验，键盘快捷键

### 数据同步
- **实时同步**: Firebase Firestore实时数据同步
- **离线支持**: 本地SQLite/Hive数据缓存
- **多端一致**: 跨设备数据自动同步

### 性能优化
- **懒加载**: 分页数据加载
- **缓存机制**: 图片和数据缓存
- **内存管理**: 及时释放资源

## 技术栈详解

### 状态管理
- **Riverpod**: 现代化状态管理
- **Bloc**: 复杂状态管理
- **Provider**: 简单状态管理

### 数据存储
- **SQLite**: 结构化数据存储
- **Hive**: 键值对和对象存储
- **SharedPreferences**: 设置存储
- **Firebase Firestore**: 云端数据同步

### UI框架
- **Material Design 3**: Android风格
- **Cupertino**: iOS风格
- **自定义组件**: 跨平台统一体验

## 贡献指南

1. Fork 项目
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开 Pull Request

## 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情

## 联系方式

- 项目维护者: vonxq
- 邮箱: [your-email@example.com]
- 项目链接: [https://github.com/vonxq/ice-book](https://github.com/vonxq/ice-book)

## 致谢

感谢所有为这个项目做出贡献的开发者和设计师。

---

**注意**: 这是一个正在开发中的项目，功能可能会发生变化。请关注项目更新。 