---
name: swift-language
description: Swift 语言特性和最佳实践。当编写 Swift 代码时自动加载。
---

# swift-language · Swift 语言知识库

## 基本语法

### 变量和常量

```swift
// 常量（推荐）
let name = "张三"
let age: Int = 25

// 变量
var count = 0
count += 1

// 类型推断
let pi = 3.14  // Double
let flag = true  // Bool
```

### 可选类型

```swift
// 声明可选
var optionalName: String? = nil
var optionalAge: Int? = 25

// 解包
if let name = optionalName {
    print(name)
}

// 强制解包（不推荐）
let name = optionalName!

// 可选链
let length = optionalName?.count

// 空合并
let name = optionalName ?? "未知"
```

## 类和结构体

### 类（引用类型）

```swift
class HDDashboardViewController: UIViewController {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    func viewDidLoad() {
        super.viewDidLoad()
    }
}
```

### 结构体（值类型）

```swift
struct HDExerciseRecord {
    let type: String
    let duration: Int
    let calories: Double
}
```

### 属性观察器

```swift
class HDDashboardViewModel: ObservableObject {
    var stepsCount: Int = 0 {
        willSet {
            print("即将改变为 \(newValue)")
        }
        didSet {
            print("已改变，旧值 \(oldValue)")
        }
    }
}
```

## 协议和扩展

### 协议定义

```swift
protocol HDExerciseDelegate {
    func exerciseDidComplete(_ record: HDExerciseRecord)
    func exerciseDidCancel()
}
```

### 协议遵守

```swift
class HDDashboardViewController: UIViewController, HDExerciseDelegate {
    func exerciseDidComplete(_ record: HDExerciseRecord) {
        print("运动完成")
    }
    
    func exerciseDidCancel() {
        print("运动取消")
    }
}
```

### 扩展

```swift
extension String {
    var isValidEmail: Bool {
        // 邮箱验证逻辑
        return self.contains("@")
    }
}

let email = "test@example.com"
if email.isValidEmail {
    print("有效邮箱")
}
```

## 闭包

### 基本闭包

```swift
let add: (Int, Int) -> Int = { a, b in
    return a + b
}

let result = add(5, 3)  // 8
```

### 尾随闭包

```swift
func performAction(completion: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        completion()
    }
}

performAction {
    print("完成")
}
```

### 捕获列表

```swift
var count = 0
let closure = { [count] in  // 捕获 count 的值
    print(count)
}
```

## 高阶函数

### map（转换）

```swift
let numbers = [1, 2, 3, 4, 5]
let doubled = numbers.map { $0 * 2 }  // [2, 4, 6, 8, 10]
```

### filter（过滤）

```swift
let numbers = [1, 2, 3, 4, 5]
let evens = numbers.filter { $0 % 2 == 0 }  // [2, 4]
```

### reduce（聚合）

```swift
let numbers = [1, 2, 3, 4, 5]
let sum = numbers.reduce(0) { $0 + $1 }  // 15
```

## 错误处理

### 定义错误

```swift
enum HDError: Error {
    case invalidInput
    case networkError
    case decodingError
}
```

### 抛出错误

```swift
func fetchData() throws -> [HDExerciseRecord] {
    guard let url = URL(string: "https://api.example.com") else {
        throw HDError.invalidInput
    }
    // 获取数据
    return []
}
```

### 捕获错误

```swift
do {
    let records = try fetchData()
    print(records)
} catch HDError.invalidInput {
    print("输入无效")
} catch HDError.networkError {
    print("网络错误")
} catch {
    print("未知错误")
}
```

## 泛型

### 泛型函数

```swift
func swap<T>(_ a: inout T, _ b: inout T) {
    let temp = a
    a = b
    b = temp
}

var x = 5, y = 10
swap(&x, &y)  // x = 10, y = 5
```

### 泛型类

```swift
class Stack<Element> {
    private var items: [Element] = []
    
    func push(_ item: Element) {
        items.append(item)
    }
    
    func pop() -> Element? {
        return items.popLast()
    }
}
```

## 常用库

### Foundation

```swift
import Foundation

// 日期
let now = Date()
let formatter = DateFormatter()
formatter.dateFormat = "yyyy-MM-dd"
let dateString = formatter.string(from: now)

// URL
let url = URL(string: "https://example.com")
let request = URLRequest(url: url!)
```

### Combine

```swift
import Combine

class HDViewModel: ObservableObject {
    @Published var data: String = ""
    
    private var cancellables = Set<AnyCancellable>()
}
```

### UIKit

```swift
import UIKit

class HDViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}
```

## 常见错误

### ❌ 错误：强制解包

```swift
let value = optionalValue!  // 可能崩溃
```

### ✅ 正确：安全解包

```swift
if let value = optionalValue {
    print(value)
}
```

### ❌ 错误：循环引用

```swift
class ViewController {
    var closure: (() -> Void)?
    
    func setup() {
        closure = {
            self.doSomething()  // 循环引用
        }
    }
}
```

### ✅ 正确：使用捕获列表

```swift
closure = { [weak self] in
    self?.doSomething()  // 避免循环引用
}
```
