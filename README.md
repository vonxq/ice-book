# Ice Book - iOS记账应用

## 项目简介

Ice Book 是一款现代化的iOS原生记账应用，采用SwiftUI开发，支持iCloud数据同步。应用提供简洁易用的记账功能，帮助用户更好地管理个人财务。

## 功能特性

### 核心功能
- 📝 **智能记账**: 快速记录收入支出，支持分类管理
- 📊 **数据统计**: 月度/年度收支统计，分类分析
- 💳 **账户管理**: 多账户支持，余额管理
- 💰 **预算管理**: 月度预算设置，超支提醒
- ☁️ **云端同步**: iCloud自动同步，多设备数据一致

### 辅助功能
- 📱 **现代化UI**: 基于SwiftUI的流畅界面
- 🎨 **主题切换**: 支持深色/浅色主题
- 📤 **数据导出**: 支持CSV格式导出
- 🔔 **通知提醒**: 预算超支提醒
- 🔒 **数据安全**: 本地加密存储

## 技术架构

- **开发语言**: Swift 5.0+
- **UI框架**: SwiftUI
- **数据存储**: Core Data + CloudKit
- **最低支持**: iOS 15.0+
- **目标设备**: iPhone, iPad

## 项目结构

```
IceBook/
├── App/                    # 应用入口
├── Views/                  # 视图层
│   ├── Main/              # 主要页面
│   ├── Components/         # 可复用组件
│   └── Modals/            # 弹窗页面
├── Models/                 # 数据模型
│   ├── CoreData/          # Core Data模型
│   └── ViewModels/        # 视图模型
├── Services/               # 业务服务
├── Utils/                  # 工具类
└── Resources/              # 资源文件
```

## 开发环境要求

- Xcode 14.0+
- iOS 15.0+ SDK
- macOS 12.0+
- Apple Developer Account (用于CloudKit)

## 安装和运行

1. 克隆项目
```bash
git clone git@github.com:vonxq/ice-book.git
cd ice-book
```

2. 打开项目
```bash
open IceBook.xcodeproj
```

3. 配置开发者账号
   - 在Xcode中选择项目
   - 在Signing & Capabilities中配置开发者账号
   - 启用iCloud和CloudKit功能

4. 运行项目
   - 选择目标设备或模拟器
   - 点击运行按钮或使用快捷键 `Cmd+R`

## 开发计划

### 第一阶段 (MVP) - 进行中
- [x] 项目基础架构搭建
- [x] 设计文档完成
- [ ] Core Data 模型设计
- [ ] 基础UI页面实现
- [ ] 记账功能实现

### 第二阶段 (功能完善)
- [ ] 统计功能实现
- [ ] 账户管理功能
- [ ] 分类管理功能
- [ ] 预算功能实现

### 第三阶段 (高级功能)
- [ ] CloudKit 同步实现
- [ ] 数据导出功能
- [ ] 通知提醒功能
- [ ] 主题切换功能

### 第四阶段 (优化发布)
- [ ] 性能优化
- [ ] 用户体验优化
- [ ] 测试和调试
- [ ] App Store 发布准备

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