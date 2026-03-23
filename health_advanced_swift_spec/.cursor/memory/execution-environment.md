---
name: execution-environment
type: long-term
description: HealthDashboard 项目的执行环境约束和工具调用规范
last-updated: 2026/3/23
---

# 执行环境与工具调用规范

## 项目技术栈（当前状态）

```
语言：Swift 5.x
框架：UIKit + Combine
架构：MVVM（ObservableObject / @Published / AnyCancellable）
IDE：Xcode 13+
iOS 最低版本：12.0
数据层：HDHealthDataModel（shared() 单例）
```

## 代码执行约束

### 线程约束

```swift
// ✅ UI 操作必须在主线程
publisher
    .receive(on: DispatchQueue.main)
    .sink { [weak self] value in
        self?.label.text = value   // 主线程更新 UI
    }
    .store(in: &cancellables)

// ✅ 耗时操作在后台线程
DispatchQueue.global(qos: .userInitiated).async {
    // 耗时计算
    DispatchQueue.main.async {
        // 更新 UI
    }
}
```

### 内存管理约束

```swift
// ✅ Combine 订阅必须用 [weak self] + store
publisher
    .sink { [weak self] value in self?.update(value) }
    .store(in: &cancellables)

// ✅ Delegate 必须声明为 weak
weak var delegate: HDQuickAddDelegate?

// ❌ 禁止强引用导致循环引用
publisher.sink { [self] value in self.update(value) }  // 错误
```

### 数据操作约束

```swift
// ✅ 写入只能用 Model 方法
HDHealthDataModel.shared.addWater(200)
HDHealthDataModel.shared.addSteps(1000)
HDHealthDataModel.shared.addMood(4)

// ✅ 配置类属性可以直接修改
HDHealthDataModel.shared.isDarkMode = true
HDHealthDataModel.shared.stepsGoal = 8000
HDHealthDataModel.shared.waterGoalML = 2500

// ❌ 禁止直接修改业务数据属性
HDHealthDataModel.shared.todaySteps = 5000  // 错误
HDHealthDataModel.shared.waterML = 1000     // 错误
```

### 禁止事项（硬限制）

- 禁止在主线程做耗时操作（> 100ms）
- 禁止使用第三方库（除非明确确认）
- 禁止修改 `Info.plist` 关键字段
- 禁止硬编码颜色值和字符串
- 禁止删除现有的 `applyTheme` 实现
- 禁止使用 NSNotification 监听主题变化（改用 `$isDarkMode` Combine 订阅）

## 工具调用规范

### Hooks 脚本说明

| 脚本 | 触发时机 | 职责 |
|---|---|---|
| `guard.sh` | Shell 命令执行前 | 拦截 `rm -rf` 等危险命令 |
| `block-sensitive.sh` | 文件读取前 | 屏蔽 `.env`、证书等敏感文件 |
| `format.sh` | 代码编辑后 | 自动格式化 |
| `quality-gate.sh` | 提交前 / Agent 完成时 | 质量检查 |

### Git Hook 配置

```bash
# 创建 .git/hooks/pre-commit
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
.cursor/hooks/quality-gate.sh
if [ $? -ne 0 ]; then
    echo "❌ 质量检查失败，无法提交"
    exit 1
fi
EOF
chmod +x .git/hooks/pre-commit
```

## Xcode 工程约束

### Swift 文件加入工程

新建 `.swift` 文件后，必须手动在 Xcode 中加入 Target：
> 选中文件 → File Inspector（右侧面板）→ Target Membership → 勾选 `HealthDashboard`

### 清除 Xcode 缓存

```bash
killall Xcode && rm -rf ~/Library/Developer/Xcode/DerivedData/*
```

## 常见问题

**Q: `Cannot find 'HDHealthDataModel' in scope`**
A: `Cmd+Shift+K` 清理后重新编译，确认文件已加入 Target。

**Q: Swift 文件编译找不到类**
A: File Inspector → Target Membership → 勾选 `HealthDashboard`。

**Q: Combine 订阅不触发**
A: 检查是否调用了 `.store(in: &cancellables)`，订阅未存储会立即被释放。

**Q: 主题切换后 UI 不刷新**
A: 检查 ViewController 的 `viewDidLoad` 中是否订阅了 `HDHealthDataModel.shared.$isDarkMode`。
