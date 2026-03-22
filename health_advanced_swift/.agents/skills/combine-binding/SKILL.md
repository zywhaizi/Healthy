---
name: combine-binding
description: Combine 框架的数据绑定实现。当使用 Combine 进行数据绑定时自动加载。
---

# combine-binding · Combine 数据绑定（HealthDashboard 专用）

## 核心约束

- ViewModel 必须继承 `ObservableObject`，用 `@Published` 驱动 UI
- 所有订阅必须用 `.store(in: &cancellables)` 保存
- 订阅中引用 `self` 必须用 `[weak self]`
- 主线程更新 UI 必须加 `.receive(on: DispatchQueue.main)`

## 标准写法

```swift
class HDXxxViewModel: ObservableObject {
    @Published var stepsText: String = ""
    @Published var progressValue: CGFloat = 0

    private var cancellables = Set<AnyCancellable>()
    private let model = HDHealthDataModel.shared()

    init() {
        refreshData()
    }

    func refreshData() {
        // OC Model 无 @Published，直接读取属性更新
        stepsText = "\(model.todaySteps) 步"
        progressValue = model.stepsProgress
    }
}
```

## 需要响应 OC Model 变化时（KVO）

```swift
// OC Model 不是 ObservableObject，需用 KVO 观察属性变化
private var observation: NSKeyValueObservation?

func setupObservation() {
    observation = model.observe(\.todaySteps, options: [.new]) { [weak self] _, _ in
        DispatchQueue.main.async {
            self?.refreshData()
        }
    }
}
```

## 主题变化订阅

```swift
// 监听 NSNotification 主题广播
NotificationCenter.default
    .publisher(for: NSNotification.Name("HDThemeDidChangeNotification"))
    .receive(on: DispatchQueue.main)
    .sink { [weak self] _ in
        self?.applyTheme()
    }
    .store(in: &cancellables)
```

## ViewController 中绑定 ViewModel

```swift
private func setupBindings() {
    viewModel.$stepsText
        .receive(on: DispatchQueue.main)
        .sink { [weak self] text in
            self?.stepsLabel.text = text
        }
        .store(in: &cancellables)

    viewModel.$progressValue
        .receive(on: DispatchQueue.main)
        .sink { [weak self] value in
            self?.ringView.progress = value
        }
        .store(in: &cancellables)
}
```

## 常见错误

```swift
// ❌ 忘记存储 cancellable，订阅立即释放
viewModel.$stepsText.sink { print($0) }

// ❌ 强引用 self 导致循环引用
viewModel.$stepsText.sink { [self] text in self.label.text = text }

// ✅ 正确
viewModel.$stepsText
    .receive(on: DispatchQueue.main)
    .sink { [weak self] text in self?.label.text = text }
    .store(in: &cancellables)
```
