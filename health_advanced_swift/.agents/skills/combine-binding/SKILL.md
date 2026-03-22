---
name: combine-binding
description: Combine 框架的数据绑定实现。当使用 Combine 进行数据绑定时自动加载。
---

# combine-binding · Combine 数据绑定知识库

## Combine 框架概览

Combine 是 Apple 的响应式编程框架，提供声明式 API 来处理异步事件。

```
Publisher (发布者)
  ↓ 发送值
Operator (操作符)
  ↓ 转换值
Subscriber (订阅者)
  ↓ 接收值
UI 自动更新
```

## @Published 属性

### 基本用法

```swift
class HDDashboardViewModel: ObservableObject {
    @Published var stepsText: String = ""
    @Published var progressValue: CGFloat = 0.0
    @Published var isLoading: Bool = false
}
```

### 在 View 中自动订阅

```swift
struct HDDashboardView: View {
    @ObservedObject var viewModel: HDDashboardViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.stepsText)  // 自动订阅
            ProgressView(value: viewModel.progressValue)
            if viewModel.isLoading {
                ProgressView()
            }
        }
    }
}
```

## 订阅管理

### 使用 AnyCancellable

```swift
class HDDashboardViewModel: ObservableObject {
    @Published var stepsText: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    private let model = HDHealthDataModel.shared
    
    init() {
        // 订阅 Model 的数据变化
        model.$todaySteps
            .map { "\($0) 步" }
            .assign(to: &$stepsText)
    }
}
```

### 手动管理订阅

```swift
private var cancellables = Set<AnyCancellable>()

model.$todaySteps
    .sink { newValue in
        print("步数更新: \(newValue)")
    }
    .store(in: &cancellables)
```

## 常用操作符

### map（转换值）

```swift
model.$todaySteps
    .map { "\($0) 步" }
    .assign(to: &$stepsText)

// 或者
model.$todaySteps
    .map { value in
        String(format: "%,d", value)
    }
    .assign(to: &$stepsText)
```

### filter（过滤值）

```swift
model.$waterML
    .filter { $0 > 0 }
    .map { "\($0) ml" }
    .assign(to: &$waterText)
```

### removeDuplicates（去重）

```swift
model.$todaySteps
    .removeDuplicates()  // 只在值改变时发送
    .map { "\($0)" }
    .assign(to: &$stepsText)
```

### debounce（防抖）

```swift
searchTextField.textPublisher
    .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
    .sink { searchText in
        viewModel.search(searchText)
    }
    .store(in: &cancellables)
```

### throttle（节流）

```swift
model.$todaySteps
    .throttle(for: .seconds(1), scheduler: DispatchQueue.main, latest: true)
    .sink { value in
        print("每秒最多一次: \(value)")
    }
    .store(in: &cancellables)
```

## 合并多个 Publisher

### combineLatest（合并最新值）

```swift
Publishers.CombineLatest(
    model.$todaySteps,
    model.$stepsGoal
)
.map { steps, goal in
    CGFloat(steps) / CGFloat(goal)
}
.assign(to: &$progressValue)
```

### CombineLatest3（合并三个）

```swift
Publishers.CombineLatest3(
    model.$todaySteps,
    model.$waterML,
    model.$sleepHours
)
.map { steps, water, sleep in
    "步数:\(steps) 喝水:\(water)ml 睡眠:\(sleep)h"
}
.assign(to: &$summary)
```

### merge（合并多个）

```swift
let publisher1 = model.$todaySteps
let publisher2 = model.$waterML

Publishers.Merge(publisher1, publisher2)
    .sink { value in
        print("数据更新: \(value)")
    }
    .store(in: &cancellables)
```

## 错误处理

### catch（捕获错误）

```swift
func fetchData() -> AnyPublisher<[HDExerciseRecord], Never> {
    URLSession.shared.dataTaskPublisher(for: url)
        .map { $0.data }
        .decode(type: [HDExerciseRecord].self, decoder: JSONDecoder())
        .catch { error in
            print("解码错误: \(error)")
            return Just([])
        }
        .eraseToAnyPublisher()
}
```

### replaceError（替换错误）

```swift
model.$todaySteps
    .replaceError(with: 0)
    .assign(to: &$stepsText)
```

### tryMap（可能抛出错误）

```swift
model.$todaySteps
    .tryMap { value in
        guard value > 0 else { throw HDError.invalidValue }
        return value
    }
    .catch { _ in
        Just(0)
    }
    .assign(to: &$stepsText)
```

## 主题切换示例

### 完整示例

```swift
class HDDashboardViewModel: ObservableObject {
    @Published var backgroundColor: Color = .white
    @Published var textColor: Color = .black
    @Published var borderColor: Color = .gray
    
    private var cancellables = Set<AnyCancellable>()
    private let model = HDHealthDataModel.shared
    
    init() {
        setupThemeBindings()
    }
    
    private func setupThemeBindings() {
        // 背景色
        model.$isDarkMode
            .map { isDark in
                isDark ? Color.black : Color.white
            }
            .assign(to: &$backgroundColor)
        
        // 文字色
        model.$isDarkMode
            .map { isDark in
                isDark ? Color.white : Color.black
            }
            .assign(to: &$textColor)
        
        // 边框色
        model.$isDarkMode
            .map { isDark in
                isDark ? Color.gray : Color.lightGray
            }
            .assign(to: &$borderColor)
    }
}
```

## 性能优化

### 避免过度订阅

```swift
// ❌ 错误：每次都创建新的订阅
var body: some View {
    Text(viewModel.stepsText)
        .onReceive(model.$todaySteps) { _ in
            viewModel.refreshData()
        }
}

// ✅ 正确：在 init 中订阅一次
init() {
    model.$todaySteps
        .sink { _ in
            self.refreshData()
        }
        .store(in: &cancellables)
}
```

### 使用 receive(on:)

```swift
model.$todaySteps
    .receive(on: DispatchQueue.main)  // 在主线程更新 UI
    .map { "\($0)" }
    .assign(to: &$stepsText)
```

### 使用 subscribe(on:)

```swift
URLSession.shared.dataTaskPublisher(for: url)
    .subscribe(on: DispatchQueue.global())  // 在后台线程执行
    .receive(on: DispatchQueue.main)        // 在主线程更新 UI
    .sink { completion, value in
        // 处理结果
    }
    .store(in: &cancellables)
```

## 常见错误

### ❌ 错误：忘记存储 cancellable

```swift
model.$todaySteps
    .sink { print($0) }
    // 没有 .store(in: &cancellables)
    // 订阅会立即被释放
```

### ✅ 正确：存储 cancellable

```swift
model.$todaySteps
    .sink { print($0) }
    .store(in: &cancellables)
```

### ❌ 错误：在 View 中创建 ViewModel

```swift
struct HDDashboardView: View {
    @State var viewModel = HDDashboardViewModel()  // 错误
}
```

### ✅ 正确：在 ViewController 中创建

```swift
class HDDashboardViewController: UIViewController {
    @StateObject var viewModel = HDDashboardViewModel()  // 正确
}
```

### ❌ 错误：循环引用

```swift
init() {
    model.$todaySteps
        .sink { [self] value in  // 强引用 self
            self.updateUI(value)
        }
        .store(in: &cancellables)
}
```

### ✅ 正确：使用 weak self

```swift
init() {
    model.$todaySteps
        .sink { [weak self] value in  // 弱引用 self
            self?.updateUI(value)
        }
        .store(in: &cancellables)
}
```

## 调试技巧

### 打印所有事件

```swift
model.$todaySteps
    .print("步数")  // 打印订阅、值、完成等所有事件
    .map { "\($0)" }
    .assign(to: &$stepsText)
```

### 使用 handleEvents

```swift
model.$todaySteps
    .handleEvents(
        receiveSubscription: { _ in
            print("订阅开始")
        },
        receiveOutput: { value in
            print("收到值: \(value)")
        },
        receiveCompletion: { completion in
            print("完成: \(completion)")
        },
        receiveCancel: {
            print("订阅取消")
        }
    )
    .assign(to: &$stepsText)
```

## 测试

### 测试 Publisher

```swift
class HDDashboardViewModelTests: XCTestCase {
    var viewModel: HDDashboardViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        viewModel = HDDashboardViewModel()
        cancellables = Set<AnyCancellable>()
    }
    
    func testStepsTextBinding() {
        let expectation = XCTestExpectation(description: "stepsText updated")
        
        viewModel.$stepsText
            .dropFirst()  // 跳过初始值
            .sink { text in
                XCTAssertEqual(text, "100")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.addSteps(100)
        
        wait(for: [expectation], timeout: 1.0)
    }
}
```
