---
name: swift-language
description: Swift 语言特性和最佳实践。当编写 Swift 代码时自动加载。
---

# swift-language · Swift 语言规范（HealthDashboard 专用）

## 可选类型（Optional）

```swift
// ✅ 安全解包
if let mood = model.latestMood {
    label.text = mood.emojiString
}

// ✅ 空合并
let steps = model.todaySteps  // 直接用，Model 保证非 nil

// ❌ 禁止强制解包
let value = optionalValue!  // 可能崩溃
```

## 闭包与内存管理

```swift
// ✅ 闭包中必须用 [weak self] 避免循环引用
model.$todaySteps
    .sink { [weak self] value in
        self?.updateLabel(value)
    }
    .store(in: &cancellables)

// ❌ 强引用 self 导致循环引用
model.$todaySteps
    .sink { [self] value in  // 错误
        self.updateLabel(value)
    }
```

## 协议与 Delegate

```swift
// Protocol 需要继承 AnyObject 支持 weak 引用
// 标注 @objc 以便跨模块使用
@objc protocol HDQuickAddDelegate: AnyObject {
    func quickAddDidUpdateData()
}

class HDQuickAddViewController: UIViewController {
    weak var delegate: HDQuickAddDelegate?
}
```

## 访问 Model

```swift
let model = HDHealthDataModel.shared()

// 写入数据只能用指定方法
model.addWater(250)
model.addSteps(1000)
model.addMood(4)

// 读取进度用 readonly 属性
let progress = model.stepsProgress  // CGFloat 0.0~1.0
```

## 主题实现

```swift
// 所有 VC 必须实现，使用系统语义色，禁止硬编码
func applyTheme() {
    view.backgroundColor = .systemBackground
    titleLabel.textColor = .label
    cardView.backgroundColor = .secondarySystemBackground
}
```
