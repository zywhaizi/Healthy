---
name: ios-design-patterns
description: HealthDashboard 项目中使用的 iOS 设计模式（Swift）。当需要实现 Delegate、单例调用、主题系统、跨VC通信时自动加载。
---

# iOS 设计模式知识库（Swift）

## 1. 单例访问（HDHealthDataModel）

```swift
// 标准写法
let model = HDHealthDataModel.shared()

// 读取数据
let steps = model.todaySteps
let progress = model.stepsProgress   // 0.0~1.0，直接使用，无需手动计算

// 写入数据（只能用指定方法）
model.addWater(200)
model.addSteps(1000)
model.addMood(4)
```

## 2. Delegate 模式

```swift
// 声明 Protocol（必须继承 AnyObject 以支持 weak）
@objc protocol HDQuickAddDelegate: AnyObject {
    func quickAddDidUpdateData()
}

// 委托方持有 delegate（必须 weak）
class HDQuickAddViewController: UIViewController {
    weak var delegate: HDQuickAddDelegate?

    func finish() {
        // 先回调，再 dismiss
        delegate?.quickAddDidUpdateData()
        dismiss(animated: true)
    }
}

// 设置 delegate
let vc = HDQuickAddViewController()
vc.delegate = self   // self 须 conform HDQuickAddDelegate
```

## 3. 主题系统

```swift
// 所有 VC 必须实现
func applyTheme() {
    // 语义色自动适配 Dark Mode，无需手动判断
    view.backgroundColor = .systemBackground
    titleLabel.textColor = .label
    cardView.backgroundColor = .secondarySystemBackground
}

// 订阅主题变化（在 viewDidLoad 中）
private func setupThemeBinding() {
    HDHealthDataModel.shared().$isDarkMode
        .receive(on: DispatchQueue.main)
        .sink { [weak self] _ in self?.applyTheme() }
        .store(in: &cancellables)
}
```

## 4. 数据刷新模式

```swift
// viewWillAppear 中刷新
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.refreshData()
    applyTheme()
}
```

## 5. 跨 VC 通信决策树

```
需要跨 VC 传递数据？
├── 一对一，单向回调  → Delegate（HDQuickAddDelegate）
├── 一对多，广播通知  → Combine／NotificationCenter
└── 全局共享状态     → Singleton（HDHealthDataModel）

内存管理？
├── 持有关系  → strong（默认）
├── 循环引用  → weak（delegate、闭包内 self）
└── 基本类型  → 值语义，无需特殊处理
```

## 项目中的模式实例

| 模式 | 实例 | 位置 |
|---|---|---|
| Singleton | `HDHealthDataModel.shared()` | Models/ |
| Delegate | `HDQuickAddDelegate` | Controllers/HDQuickAdd* |
| Delegate | `HDExerciseDelegate` | Controllers/HDExercise* |
| Combine | `$isDarkMode` 主题订阅 | 所有 ViewController |
| Template Method | `applyTheme` | 所有 ViewController |
