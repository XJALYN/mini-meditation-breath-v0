# Xcode项目配置指南

## 步骤1：创建Xcode项目

1. 打开 Xcode (需要 14.0 或更高版本)
2. 选择 `File` → `New` → `Project`
3. 选择 `iOS` → `App`，点击 `Next`
4. 配置项目信息：
   - **Product Name**: `BreathingApp`
   - **Team**: 选择你的开发团队
   - **Organization Identifier**: `com.yourname` (自定义)
   - **Interface**: `SwiftUI`
   - **Language**: `Swift`
   - **Storage**: `None` (不需要 Core Data)
5. 选择保存位置（选择此项目的父目录）
6. 点击 `Create`

## 步骤2：删除默认文件

Xcode会创建一些默认文件，我们需要替换它们：

1. 在项目导航器中，删除以下文件（移动到废纸篓）：
   - `BreathingAppApp.swift` (默认的App入口文件)
   - `ContentView.swift` (默认的内容视图)
   - `Assets.xcassets` (默认的资源文件)
   
2. 删除 `Preview Content` 文件夹

## 步骤3：导入源代码

### 方法1：拖放导入（推荐）

1. 在 Finder 中打开本项目的 `BreathingApp/BreathingApp` 文件夹
2. 将以下文件夹拖入 Xcode 项目导航器：
   - `Models/`
   - `Views/`
   - `Services/`
   - `Resources/`
   - `Info.plist`
   - `BreathingAppApp.swift`

3. 在弹出的对话框中：
   - ✅ 勾选 `Copy items if needed`
   - ✅ 勾选 `Create groups`
   - ✅ 勾选你的项目 target
   - 点击 `Finish`

### 方法2：手动添加文件

1. 右键点击项目导航器中的项目文件夹
2. 选择 `Add Files to "BreathingApp"...`
3. 导航到源代码位置，选择文件夹和文件
4. 确保勾选：
   - ✅ `Copy items if needed`
   - ✅ `Create groups`
   - ✅ 项目 target

## 步骤4：配置应用内购买

### 4.1 在 Xcode 中添加 Capability

1. 选择项目 target
2. 点击 `Signing & Capabilities` 标签
3. 点击 `+ Capability`
4. 搜索并添加 `In-App Purchase`
5. 确保 Bundle ID 正确配置

### 4.2 在 App Store Connect 中创建产品

1. 访问 [App Store Connect](https://appstoreconnect.apple.com)
2. 选择你的应用（或创建新应用）
3. 进入 `功能` → `App 内购买项目`
4. 点击 `+` 创建新的购买项：
   - **类型**: `非消耗型项目`
   - **产品 ID**: `com.breathingapp.premium`
   - **参考名称**: `解锁全部呼吸模式`
   - **价格**: `¥6` (选择合适的价格等级)
   
5. 添加本地化信息：
   - **显示名称**: `解锁全部呼吸模式`
   - **描述**: `解锁所有高级呼吸模式，享受完整的冥想体验`

## 步骤5：配置应用图标

1. 准备一个 1024x1024 的应用图标（PNG格式）
2. 在 Xcode 中打开 `Assets.xcassets`
3. 选择 `AppIcon`
4. 将图标拖入 `App Store iOS 1024pt` 位置
5. 或者使用工具自动生成不同尺寸：
   ```bash
   # 如果你有 icon.png
   # 可以使用在线工具如:
   # https://appicon.co/
   ```

## 步骤6：配置启动屏幕

项目已配置深色背景的启动屏幕，无需额外配置。

如果需要自定义：

1. 打开 `Info.plist`
2. 找到 `UILaunchScreen` → `UIColorName`
3. 修改颜色名称或在 `Assets.xcassets` 中添加新颜色

## 步骤7：调整项目设置

### 7.1 部署目标

1. 选择项目 target
2. 在 `General` 标签中
3. 设置 `Minimum Deployments` 为 `iOS 16.0`

### 7.2 设备方向

1. 在项目设置中
2. 确保 `iPhone` 只勾选 `Portrait`
3. `iPad` 可以勾选所有方向（可选）

### 7.3 状态栏样式

已在 `Info.plist` 中配置为深色模式，状态栏会自动显示为浅色。

## 步骤8：测试应用

### 8.1 在模拟器中测试

1. 选择 `iPhone 15 Pro` 或更高版本的模拟器
2. 点击 `Run` 按钮 (⌘R)
3. 测试以下功能：
   - [ ] 主界面显示呼吸模式列表
   - [ ] 点击模式进入练习界面
   - [ ] 动画流畅运行
   - [ ] 震动反馈正常（真机测试）
   - [ ] 计时器倒计时正确
   - [ ] 完成提示正常显示

### 8.2 在真机中测试

1. 连接 iPhone
2. 选择你的设备
3. 运行应用
4. 额外测试：
   - [ ] 震动反馈
   - [ ] 应用内购买流程（沙盒环境）

## 步骤9：配置应用内购买测试

### 9.1 创建沙盒测试账号

1. 访问 App Store Connect
2. 进入 `用户和访问` → `沙盒技术测试员`
3. 点击 `+` 创建测试账号
4. 使用这个账号在设备上测试购买

### 9.2 在设备上配置

1. 在测试设备上退出 App Store 账号
2. 在应用中触发购买时
3. 使用沙盒测试账号登录
4. 测试购买流程（不会真实扣款）

## 步骤10：准备上架

### 10.1 截图准备

需要准备以下尺寸的截图：

**iPhone 6.7" (iPhone 15 Pro Max)**
- 1290 x 2796 像素

**iPhone 6.5" (iPhone 14 Plus)**
- 1284 x 2778 像素

**iPhone 5.5" (iPhone 8 Plus)**
- 1242 x 2208 像素

### 10.2 应用描述

```
便携微冥想呼吸器 - 1分钟极速焦虑疏导

【核心功能】
✨ 流畅动画引导 - 无需音频，视觉呼吸引导
📳 触感震动提示 - 静音环境也能有效使用
⏱️ 即时开启 - 无需下载，打开即用
🎯 多种模式 - 4-7-8、箱式呼吸等专业方法

【适合人群】
• 高强度脑力劳动者
• 考试考证焦虑人群  
• 情绪易波动群体
• 需要快速专注恢复的用户

【呼吸模式】
🆓 4-7-8 呼吸法（免费）- 快速入睡、缓解焦虑
🆓 箱式呼吸（免费）- 提升专注、稳定情绪
💎 减压呼吸（付费）- 日常放松、缓解紧张
💎 专注力呼吸（付费）- 提升警觉、清醒头脑
💎 活力呼吸（付费）- 提升活力、快速清醒
💎 助眠呼吸（付费）- 深度放松、改善睡眠

【特色】
• 极简设计，无广告干扰
• 纯本地运行，保护隐私
• 仅需6元解锁全部模式
• 一次购买，永久使用

立即下载，开启你的微冥想之旅！
```

### 10.3 关键词

```
呼吸,冥想,放松,焦虑,专注,减压,助眠,冥想引导,呼吸训练,正念
```

### 10.4 技术支持URL

提供一个简单的网页或联系方式

## 常见问题

### Q: 编译错误 "Cannot find 'XXX' in scope"

A: 确保所有文件都已正确添加到项目 target：
1. 选择文件
2. 在右侧面板中检查 Target Membership
3. 勾选你的项目 target

### Q: 应用内购买无法测试

A: 检查以下内容：
1. 确保设备已登录沙盒测试账号
2. 确保产品ID与代码中一致
3. 检查 App Store Connect 中产品状态

### Q: 震动不工作

A: 震动功能需要：
1. 真机测试（模拟器不支持）
2. 确保设备没有关闭震动
3. 检查代码中的 UIFeedbackGenerator 实现

### Q: 动画不流畅

A: 优化建议：
1. 减少 blur 效果
2. 使用 withAnimation 而不是 .animation
3. 确保在主线程更新 UI

## 下一步

- [ ] 添加应用图标
- [ ] 准备应用截图
- [ ] 编写应用描述
- [ ] 测试应用内购买
- [ ] 提交审核

---

如有问题，请参考 Apple 官方文档：
- [SwiftUI 文档](https://developer.apple.com/documentation/swiftui)
- [StoreKit 2 文档](https://developer.apple.com/documentation/storekit)