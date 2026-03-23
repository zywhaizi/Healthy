---
name: page-quickadd
description: 快速录入页面（HDQuickAddViewController）业务逻辑、Delegate 回调、表单校验 SOP。
---

# page-quickadd · 快速录入知识库

> ✅ 已迁移至 Swift + MVVM（2026/3/22）
> 源文件：`Controllers/HDQuickAddViewController.swift`

## 架构结构

```
HDQuickAddViewController   ← UIViewController，底部弹窗样式
  └── HDQuickAddViewModel  ← ObservableObject，步数显示文字
        └── HDHealthDataModel.shared()  ← OC 单例，写入数据
```

## Delegate 协议

```swift
// 声明为 @objc protocol，让 OC 侧（Dashboard）可以 conform
@objc protocol HDQuickAddDelegate: AnyObject {
    func quickAddDidUpdateData()
}

// delegate 属性必须 weak + @objc
@objc weak var delegate: HDQuickAddDelegate?
```

## 完整录入 SOP

```
1. 用户点击 FAB → Dashboard present QuickAdd
2. 底部弹窗弹出动画（spring）
3. 用户选择操作（喝水 / 步数滑块 / 心情 emoji）
4. ViewModel 调用 Model 方法写入数据
5. performDismiss() → 收起动画 → delegate 回调 → dismiss
```

## ViewModel 数据写入

```swift
class HDQuickAddViewModel: ObservableObject {
    private let model = HDHealthDataModel.shared()

    func addWater()          { model.addWater(200) }
    func addSteps()          { model.addSteps(stepsValue) }
    func addMood(_ level: Int) { model.addMood(level) }

    func updateStepsDisplay(_ steps: Int) {
        stepsValue = steps
        let cal = model.calory(forSteps: steps)
        stepsDisplayText = String(format: "%d步 %.0f卡", steps, cal)
    }
}
```

## dismiss 时序（必须遵守）

```swift
/// 收起动画 → 调用 delegate → dismiss
private func performDismiss() {
    UIView.animate(withDuration: 0.25, animations: {
        self.sheetView.transform = CGAffineTransform(translationX: 0, y: 400)
        self.view.backgroundColor = .clear
    }, completion: { _ in
        self.delegate?.quickAddDidUpdateData()  // ① 先回调
        self.dismiss(animated: false, completion: nil)  // ② 再 dismiss
    })
}
```

## TabBar 入口（HDTabBarController.m 中 不适用）

QuickAdd **不是独立 Tab**，而是 Dashboard 的 FAB 浮层弹窗。
入口在 `HDDashboardViewController.swift` 的 `fabTapped()`：

```swift
@objc private func fabTapped() {
    let vc = HDQuickAddViewController()  // 直接实例化 Swift 类
    vc.delegate = self                   // self 为 Dashboard，conform HDQuickAddDelegate
    vc.modalPresentationStyle = .overFullScreen
    vc.modalTransitionStyle   = .crossDissolve
    present(vc, animated: false)
}
```

## 校验规则

| 类型 | 最小值 | 最大值 | 单位 |
|---|---|---|---|
| 喝水 | 固定 200 | 固定 200 | ml |
| 步数 | 500（滑块） | 10000（滑块） | 步 |
| 心情 | 1 | 5 | 级 |

## 心情 emoji 与 level 对应

```swift
let emojis = ["😞", "😕", "😐", "😊", "😄"]
// btn.tag = 100 + i + 1 → level 1~5
let level = sender.tag - 100
```

## 常见问题

**Delegate 无效**：检查 `delegate` 是否声明为 `@objc weak`，Dashboard 是否在 `fabTapped` 中设置 `vc.delegate = self`

**dismiss 过早**：确保 `delegate?.quickAddDidUpdateData()` 在 `dismiss` **之前**调用（在 completion 闭包中）

**OC 侧找不到 delegate 属性**：Swift VC 的 `delegate` 属性必须加 `@objc` 修饰
