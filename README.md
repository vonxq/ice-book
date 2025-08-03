# 记账应用 - iOS智能记账软件

## 项目简介

记账应用是一款现代化的iOS原生记账软件，采用SwiftUI开发，支持iCloud数据同步。应用提供完整的记账功能，包括收入支出记录、分类管理、数据统计、资产管理等，帮助用户全面管理个人财务。

## 功能特性

### 核心功能
- 📝 **智能记账**: 快速记录收入支出，支持分类管理
- 📊 **数据统计**: 月度/年度收支统计，分类分析
- 📈 **图表展示**: 饼图、柱状图、折线图数据可视化
- 💰 **资产管理**: 现金、银行卡、投资账户等全面管理
- 📅 **日期选择**: 灵活选择记账日期
- 📋 **分类管理**: 预设分类和自定义分类

### 辅助功能
- 📱 **现代化UI**: 基于SwiftUI的流畅界面
- ☁️ **云端同步**: iCloud自动同步，多设备数据一致
- 🔒 **数据安全**: 本地加密存储，保护用户隐私
- 📤 **数据导出**: 支持CSV格式导出
- 🎨 **主题切换**: 支持深色/浅色主题

## 技术架构

- **开发语言**: Swift 5.0+
- **UI框架**: SwiftUI
- **数据存储**: Core Data + CloudKit
- **最低支持**: iOS 15.0+
- **目标设备**: iPhone, iPad

## 项目结构

```
ExpenseTracker/
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
open ExpenseTracker.xcodeproj
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
- [ ] 主页UI实现
- [ ] 记账功能实现

### 第二阶段 (功能完善)
- [ ] 分类管理功能
- [ ] 统计图表功能
- [ ] 日期选择功能
- [ ] 资产管家功能

### 第三阶段 (高级功能)
- [ ] CloudKit 同步实现
- [ ] 数据导出功能
- [ ] 通知提醒功能
- [ ] 安全设置功能

### 第四阶段 (优化发布)
- [ ] 性能优化
- [ ] 用户体验优化
- [ ] 测试和调试
- [ ] App Store 发布准备

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