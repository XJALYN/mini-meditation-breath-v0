# 内购配置说明

## 当前设计（推荐）

**单一产品**：¥6解锁全部模式
- Product ID: `com.xujie.breathingapp.premium`
- 类型: 非消耗型（一次购买，永久使用）
- 价格: ¥6

优点：
- 用户决策简单
- 开发维护成本低
- 购买流程简洁

---

## 如果需要多个内购产品

### 方案A：分层定价

**基础套餐** ¥3
- Product ID: `com.xujie.breathingapp.basic`
- 解锁: 减压呼吸 + 专注力呼吸（2个模式）

**完整套餐** ¥6  
- Product ID: `com.xujie.breathingapp.premium`
- 解锁: 所有高级模式（4个模式）

### 方案B：单模式购买

**单个模式** ¥1.5/个
- Product ID: 
  - `com.xujie.breathingapp.calm` (减压呼吸)
  - `com.xujie.breathingapp.focus` (专注力呼吸)
  - `com.xujie.breathingapp.energy` (活力呼吸)
  - `com.xujie.breathingapp.sleep` (助眠呼吸)

**全部套餐** ¥5（比单独买便宜）
- Product ID: `com.xujie.breathingapp.bundle`
- 解锁所有模式

---

## 如何在代码中添加多个产品

### 1. 修改 BreathingPattern.swift

为每个付费模式添加对应的productID:

```swift
struct BreathingPattern: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let phases: [Phase]
    let cycles: Int
    let isPremium: Bool
    let benefits: String
    let productID: String? // 新增：对应的内购产品ID
    
    // ... 其他代码
}

// 示例
BreathingPattern(
    id: "calm",
    name: "减压呼吸",
    // ...
    isPremium: true,
    productID: "com.xujie.breathingapp.calm" // 单模式购买
)
```

### 2. 修改 StoreManager.swift

支持多个产品：

```swift
class StoreManager: ObservableObject {
    @Published var unlockedPatterns: Set<String> = []
    
    private let allProductIDs = [
        "com.xujie.breathingapp.calm",
        "com.xujie.breathingapp.focus",
        "com.xujie.breathingapp.energy",
        "com.xujie.breathingapp.sleep",
        "com.xujie.breathingapp.bundle" // 全部套餐
    ]
    
    func loadProducts() async {
        products = try await Product.products(for: allProductIDs)
    }
    
    func isPatternUnlocked(_ pattern: BreathingPattern) -> Bool {
        if !pattern.isPremium { return true }
        return unlockedPatterns.contains(pattern.productID ?? "") ||
               unlockedPatterns.contains("com.xujie.breathingapp.bundle")
    }
}
```

### 3. 修改 PatternSelectionView.swift

显示单个购买选项：

```swift
struct PatternCard: View {
    let pattern: BreathingPattern
    
    var isLocked: Bool {
        !StoreManager.shared.isPatternUnlocked(pattern)
    }
    
    var body: some View {
        // 如果锁定，显示解锁按钮和价格
        if isLocked {
            Button("¥1.5 解锁") {
                // 购买该模式
            }
        }
    }
}
```

---

## App Store Connect 配置步骤

### 创建单个产品（当前方案）

1. **App内购买项目** → **创建**
2. 类型: **非消耗型项目**
3. 产品ID: `com.xujie.breathingapp.premium`
4. 参考: `解锁全部呼吸模式`
5. 价格: 选择对应¥6的价格等级
6. 本地化: 
   - 显示名称: `解锁全部呼吸模式`
   - 描述: `解锁所有高级呼吸模式...`

### 创建多个产品（高级方案）

重复上述步骤，为每个产品创建：
- `com.xujie.breathingapp.basic` (¥3)
- `com.xujie.breathingapp.calm` (¥1.5)
- `com.xujie.breathingapp.focus` (¥1.5)
- 等等...

---

## 测试内购

### 创建沙盒测试账号

1. App Store Connect → **用户和访问**
2. **沙盒技术测试员** → **+**
3. 创建测试账号（不要用真实Apple ID）
4. 邮箱格式: `test@example.com`

### 在设备上测试

1. 退出设备的App Store账号
2. 运行应用，点击购买
3. 使用沙盒账号登录
4. 测试购买（不会真实扣款）

---

## 建议

**推荐使用当前单一产品方案**：
- ¥6解锁全部模式
- 简单有效，降低用户决策成本
- 开发和运营成本最低
- 更符合"极简"的产品理念

如果后续想调整，可以基于数据分析：
- 如果转化率低，考虑分层定价
- 如果用户反馈想要特定模式，考虑单模式购买

---

## 快速配置清单

**需要做的事情**:
1. ✅ 在App Store Connect创建应用
2. ✅ 创建内购产品 `com.xujie.breathingapp.premium`
3. ✅ 设置价格 ¥6
4. ✅ 添加本地化信息（中文）
5. ✅ 创建沙盒测试账号
6. ✅ 在真机上测试购买流程

代码已完成，只需在App Store Connect配置即可！