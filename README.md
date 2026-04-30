# 便携微冥想呼吸器

一款极简的呼吸冥想应用，专注于1分钟快速焦虑疏导和专注力恢复。

## 功能特性

### 呼吸模式
- **4-7-8 呼吸法**（免费）：经典放松呼吸法，帮助快速入睡和缓解焦虑
- **箱式呼吸**（免费）：海豹突击队使用的压力管理呼吸法
- **减压呼吸**（付费）：温和的呼吸节奏，适合日常放松
- **专注力呼吸**（付费）：快速提升专注力和警觉性
- **活力呼吸**（付费）：快速提升能量和活力
- **助眠呼吸**（付费）：深度放松，帮助入睡

### 核心功能
- 流畅的圆形扩张/收缩动画引导
- 触感震动节奏提示
- 实时倒计时显示
- 自动循环计数
- 极简深色主题设计

### 变现模式
- 免费模式包含2种基础呼吸法
- 6元一次性购买解锁所有呼吸模式

## 技术栈

- **SwiftUI** - 现代化UI框架
- **Core Animation** - 流畅动画
- **UIFeedbackGenerator** - 触感反馈
- **StoreKit 2** - 应用内购买

## 项目结构

```
BreathingApp/
├── BreathingApp/
│   ├── Models/
│   │   └── BreathingPattern.swift      # 呼吸模式数据模型
│   ├── Views/
│   │   ├── BreathingAnimationView.swift # 呼吸动画组件
│   │   ├── BreathingView.swift         # 呼吸练习主界面
│   │   └── PatternSelectionView.swift  # 模式选择界面
│   ├── Services/
│   │   ├── HapticFeedback.swift        # 震动反馈服务
│   │   └── StoreManager.swift          # 应用内购买管理
│   ├── Resources/
│   └── Info.plist                      # 应用配置
└── README.md
```

## 快速开始

### 1. 创建Xcode项目

由于SwiftUI项目需要Xcode项目文件，请按以下步骤创建：

1. 打开 Xcode
2. 选择 "Create a new Xcode project"
3. 选择 "App" 模板
4. 配置项目：
   - Product Name: `BreathingApp`
   - Team: 选择你的开发团队
   - Organization Identifier: `com.yourcompany`
   - Interface: `SwiftUI`
   - Language: `Swift`
   - Storage: `None`（不需要Core Data）

### 2. 导入源代码

将以下文件夹拖入Xcode项目中：
- `Models/`
- `Views/`
- `Services/`

确保勾选 "Copy items if needed" 和 "Create groups"

### 3. 配置应用内购买

1. 在 App Store Connect 中创建应用内购买项目：
   - Product ID: `com.breathingapp.premium`
   - Reference Name: `解锁全部呼吸模式`
   - Price: `¥6.00`

2. 在 Xcode 中启用应用内购买测试：
   - 选择项目 target
   - 点击 "Signing & Capabilities"
   - 确认使用正确 Team 与 Bundle ID
   - **不要**添加 `com.apple.developer.in-app-payments` entitlement；它属于 Apple Pay，不是应用内购买

### 4. 配置权限

在 `Info.plist` 中添加：
```xml
<key>UIUserInterfaceStyle</key>
<string>Dark</string>
```

### 5. 运行项目

选择目标设备（iPhone模拟器或真机），点击运行按钮。

## 使用说明

### 免费模式
1. 打开应用，看到呼吸模式列表
2. 选择 "4-7-8 呼吸法" 或 "箱式呼吸"
3. 点击 "开始练习"
4. 跟随动画引导和震动提示进行呼吸

### 解锁付费模式
1. 在主界面底部找到 "解锁全部呼吸模式" 卡片
2. 点击购买按钮
3. 完成 ¥6.00 支付
4. 所有呼吸模式自动解锁

## 设计理念

- **极简主义**：无任何废话引导，1分钟极速体验
- **视觉引导**：流畅动画替代音频/视频引导
- **触感反馈**：静音环境下也能有效使用
- **即时可用**：无需下载额外资源，打开即用

## 目标用户

- 高强度脑力劳动者
- 考试考证焦虑人群
- 情绪易波动群体
- 需要快速专注恢复的用户

## 未来优化方向

- [ ] 添加每日练习提醒
- [ ] 练习历史统计
- [ ] 自定义呼吸模式
- [ ] Apple Watch 支持
- [ ] Widget 快速启动
- [ ] Siri Shortcuts 集成

## 许可证

本项目仅供学习和参考使用。

---

**注意**：此项目代码需要导入到 Xcode 项目中才能正常运行。请确保你的开发环境满足以下要求：
- Xcode 14.0+
- iOS 16.0+
- Swift 5.7+