---
name: mvvm-pattern
description: MVVM 设计模式的完整实现指南。当实现 MVVM 架构时自动加载。
---

# mvvm-pattern · MVVM 模式知识库

## MVVM 架构概览

```
┌─────────────────────────────────────────┐
│           View 层 (UI)                   │
│  - UIViewController                     │
│  - SwiftUI View                         │
│  - 展示数据                              │
└────────────┬────────────────────────────┘
             │ 绑定 (@ObservedObject)
             ↓
┌─────────────────────────────────────────┐
│        ViewModel 层 (业务逻辑)           │
│  - @Published 属性                      │
│  - 处理用户交互                          │
│  - 调用 Model 方法                       │
└────────────┬────────────────────────────┘
             │ 调用方法
             ↓
┌─────────────────────────────────────────┐
│         Model 层 (数据)                  │
│  - HDHealthDataModel.shared             │
│  - 数据存储和计算                        │
│  - 业务逻辑                              │
└─────────────────────────────────────────┘
```

## 完整示例：仪表盘

### 1. Model 层

```swift
class HDHealthDataModel {
    static let shared = HDHealthDataModel()
    
    @Published var todaySteps: Int = 0
    @Published var stepsGoal: Int = 10000
    @Published var isDarkMode: Bool = false
    
    var stepsProgress: CGFloat {
        return CGFloat(todaySteps) / CGFloat(stepsGoal)
    }
    
    func addSteps(_ count: Int) {
        todaySteps += count
        save()
    }
    
    private func save() {
        // 保存到本地
    }
}
```

### 2. ViewModel 层

```swift
class HDDashboardViewModel: ObservableObject {
    @Published var stepsText: String = "0"
    @Published var progressValue: CGFloat = 0
    @Published var backgroundColor: Color = .white
    
    private let model = HDHealthDataModel.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupBindings()
    }
    
    private func setupBindings() {
        // 绑定步数文本
        model.$todaySteps
            .map { "\($0)" }
            .assign(to: &$stepsText)
        
        // 绑定进度
        model.$todaySteps
            .combineLatest(model.$stepsGoal)
            .map { CGFloat($0) / CGFloat($1) }
            .assign(to: &$progressValue)
        
        // 绑定背景色
        model.$isDarkMode
            .map { $0 ? Color.black : Color.white }
            .assign(to: &$backgroundColor)
    }
    
    func addSteps(_ count: Int) {
        model.addSteps(count)
    }
    
    func toggleTheme() {
        model.isDarkMode.toggle()
    }
}
```

### 3. View 层（UIKit）

```swift
class HDDashboardViewController: UIViewController {
    @StateObject var viewModel = HDDashboardViewModel()
    
    private let stepsLabel = UILabel()
    private let progressView = UIProgressView()
    private let addButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        applyTheme()
    }
    
    private func setupUI() {
        stepsLabel.font = .systemFont(ofSize: 28, weight: .bold)
        progressView.progress = 0
        addButton.setTitle("加步数", for: .normal)
        addButton.addTarget(self, action: #selector(addStepsTapped), for: .touchUpInside)
        
        view.addSubview(stepsLabel)
        view.addSubview(progressView)
        view.addSubview(addButton)
    }
    
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
                self?.progressView.progress = Float(value)
            }
            .store(in: &cancellables)
    }
    
    @objc private func addStepsTapped() {
        viewModel.addSteps(100)
    }
    
    func applyTheme() {
        let isDark = HDHealthDataModel.shared.isDarkMode
        view.backgroundColor = isDark ? .black : .white
    }
    
    private var cancellables = Set<AnyCancellable>()
}
```

### 4. View 层（SwiftUI）

```swift
struct HDDashboardView: View {
    @ObservedObject var viewModel: HDDashboardViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text(viewModel.stepsText)
                .font(.system(size: 28, weight: .bold))
            
            ProgressView(value: viewModel.progressValue)
            
            Button("加步数") {
                viewModel.addSteps(100)
            }
            
            Button("切换主题") {
                viewModel.toggleTheme()
            }
        }
        .background(viewModel.backgroundColor)
    }
}
```

## 数据流向示例

### 场景：用户点击"加步数"按钮

```
1. View 层
   Button("加步数") {
       viewModel.addSteps(100)  // 调用 ViewModel
   }

2. ViewModel 层
   func addSteps(_ count: Int) {
       model.addSteps(count)    // 调用 Model
   }

3. Model 层
   func addSteps(_ count: Int) {
       todaySteps += count      // 修改数据
       save()                   // 保存
   }

4. Combine 绑定自动触发
   model.$todaySteps
       .map { "\($0)" }
       .assign(to: &$stepsText)  // 更新 @Published

5. View 自动刷新
   Text(viewModel.stepsText)  // 显示新值
```

## 常见模式

### 模式 1：简单数据绑定

```swift
class ViewModel: ObservableObject {
    @Published var text: String = ""
    
    private let model = Model.shared
    
    init() {
        model.$data
            .map { $0.description }
            .assign(to: &$text)
    }
}
```

### 模式 2：数据转换

```swift
class ViewModel: ObservableObject {
    @Published var displayText: String = ""
    
    init() {
        model.$value
            .map { value in
                String(format: "%.2f", value)
            }
            .assign(to: &$displayText)
    }
}
```

### 模式 3：多数据合并

```swift
class ViewModel: ObservableObject {
    @Published var summary: String = ""
    
    init() {
        Publishers.CombineLatest3(
            model.$steps,
            model.$water,
            model.$sleep
        )
        .map { steps, water, sleep in
            "步数:\(steps) 喝水:\(water)ml 睡眠:\(sleep)h"
        }
        .assign(to: &$summary)
    }
}
```

### 模式 4：用户交互

```swift
class ViewModel: ObservableObject {
    func handleButtonTap() {
        model.addSteps(100)
    }
    
    func handleTextInput(_ text: String) {
        model.updateName(text)
    }
    
    func handleToggle(_ isOn: Bool) {
        model.isDarkMode = isOn
    }
}
```

## 最佳实践

### ✅ 正确做法

1. **Model 只负责数据**
   ```swift
   class Model {
       @Published var data: String = ""
       func updateData(_ value: String) {
           data = value
       }
   }
   ```

2. **ViewModel 负责业务逻辑**
   ```swift
   class ViewModel: ObservableObject {
       @Published var displayText: String = ""
       
       func handleUserInput(_ input: String) {
           model.updateData(input)
       }
   }
   ```

3. **View 只负责展示**
   ```swift
   struct View: View {
       @ObservedObject var viewModel: ViewModel
       
       var body: some View {
           Text(viewModel.displayText)
       }
   }
   ```

### ❌ 常见错误

1. **在 View 中访问 Model**
   ```swift
   Text(HDHealthDataModel.shared.todaySteps)  // 错误
   ```

2. **在 ViewModel 中写 UI 代码**
   ```swift
   class ViewModel {
       func updateUI() {
           UIView.animate { }  // 错误
       }
   }
   ```

3. **在 Model 中调用 ViewController**
   ```swift
   class Model {
       func showAlert() {
           UIAlertController()  // 错误
       }
   }
   ```

## 测试

### 测试 ViewModel

```swift
class HDDashboardViewModelTests: XCTestCase {
    var viewModel: HDDashboardViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = HDDashboardViewModel()
    }
    
    func testAddSteps() {
        viewModel.addSteps(100)
        XCTAssertEqual(viewModel.stepsText, "100")
    }
}
```

### 测试 Model

```swift
class HDHealthDataModelTests: XCTestCase {
    func testAddSteps() {
        let model = HDHealthDataModel.shared
        let initialSteps = model.todaySteps
        model.addSteps(100)
        XCTAssertEqual(model.todaySteps, initialSteps + 100)
    }
}
```
