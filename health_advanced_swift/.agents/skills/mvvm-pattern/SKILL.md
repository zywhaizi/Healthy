---
name: mvvm-pattern
description: MVVM 设计模式的完整实现指南。当实现 MVVM 架构时自动加载。
---

# mvvm-pattern · MVVM 模式知识库

## 架构层次

```
View 层 (UIViewController)
  ↓ (持有 ViewModel，手动订阅 @Published 属性)
ViewModel 层 (@Published 属性)
  ↓ (调用方法)
Model 层 (HDHealthDataModel.shared()   ← OC 单例，非 Swift 类)
  ↓ (读写数据)
本地存储
```

## 关键约定

- `HDHealthDataModel` 是 **OC 单例**，Swift 通过 Bridging Header 访问
- Swift 侧调用：`HDHealthDataModel.shared()`（注意带括号，OC 方法）
- Model **没有** `@Published` 属性，ViewModel 需用 KVO 或手动刷新观察数据变化
- 写入数据只能用 `addWater` / `addSteps` / `addMood`，不得直接修改属性

## 标准 ViewModel 写法

```swift
class HDDashboardViewModel: ObservableObject {
    @Published var stepsText: String = ""
    @Published var progressValue: CGFloat = 0

    private let model = HDHealthDataModel.shared()
    private var cancellables = Set<AnyCancellable>()

    init() {
        refreshData()
    }

    /// 从 OC Model 读取数据，更新 @Published 属性
    func refreshData() {
        stepsText = "\(model.todaySteps)"
        progressValue = model.stepsProgress
    }

    /// 写入只通过 Model 方法
    func addSteps(_ count: Int) {
        model.addSteps(count)
        refreshData()
    }
}
```

## 标准 ViewController 写法

```swift
class HDDashboardViewController: UIViewController {
    private let viewModel = HDDashboardViewModel()
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        applyTheme()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.refreshData()   // Dashboard / Exercise 必须
        applyTheme()
    }

    private func setupBindings() {
        viewModel.$stepsText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.stepsLabel.text = text
            }
            .store(in: &cancellables)
    }

    func applyTheme() {
        view.backgroundColor = .systemBackground
        titleLabel.textColor = .label
    }
}
```

## 数据流向（必须遵守）

```
用户操作
  → ViewController 调用 ViewModel 方法
  → ViewModel 调用 HDHealthDataModel 方法（addWater / addSteps / addMood）
  → Model 修改数据
  → ViewModel.refreshData() 更新 @Published
  → UI 自动刷新
```

## 禁止事项

- ❌ 在 View 中直接访问 `HDHealthDataModel.shared()`
- ❌ 在 ViewModel 中直接修改 Model 属性（`model.todaySteps = 100`）
- ❌ 在 Model 中写 UI 代码
- ❌ ViewController 持有 ViewController 引用（除 weak delegate）
