---
name: page-quickadd
description: 快速录入页面（HDQuickAddViewController）业务逻辑、Delegate 回调、底部弹窗实现规范。
---

# page-quickadd · 快速录入知识库

> 当前实现：`Controllers/HDQuickAddViewController.swift`（Swift + Combine + MVVM）

## 定位

QuickAdd 是 **FAB 底部弹窗**，不是独立 Tab。
入口：`HDDashboardViewController` 右下角 FAB 按钮 → `present(HDQuickAddViewController)`

## 架构结构

```
HDDashboardViewController（present 弹窗，conform HDQuickAddDelegate）
  └── HDQuickAddViewController（底部弹窗，FAB 入口）
        └── HDQuickAddViewModel（ObservableObject，步数显示文字）
              └── HDHealthDataModel.shared（OC 单例，写入数据）
```

## Delegate 协议

```swift
// 必须标注 @objc，让 OC 侧（如有）或 Swift 侧 Dashboard 可以 conform
@objc protocol HDQuickAddDelegate: AnyObject {
    func quickAddDidUpdateData()
}

// ViewController 中 delegate 属性必须 weak
weak var delegate: HDQuickAddDelegate?
```

## 录入规格（当前实现）

| 类型 | 交互方式 | 写入值 |
|---|---|---|
| 喝水 | 按钮一键 | 固定 +200ml |
| 步数 | 滑块 | 500～10000 步（用户拖动选择） |
| 心情 | 5 个 emoji 按钮 | level 1～5（😞😕😐😊😄） |

## ViewModel 数据写入

```swift
class HDQuickAddViewModel: ObservableObject {
    @Published var stepsDisplayText: String = "2000步"
    private let model = HDHealthDataModel.shared

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
/// ✅ 正确：先回调 delegate，再 dismiss
private func performDismiss() {
    UIView.animate(withDuration: 0.25, animations: {
        self.sheetView.transform = CGAffineTransform(translationX: 0, y: 400)
        self.view.backgroundColor = .clear
    }, completion: { _ in
        self.delegate?.quickAddDidUpdateData()   // ① 先回调
        self.dismiss(animated: false)            // ② 再 dismiss
    })
}
```

## Dashboard 侧 FAB 入口

```swift
// HDDashboardViewController
@objc private func fabTapped() {
    let vc = HDQuickAddViewController()
    vc.delegate = self                        // 必须设置 delegate
    vc.modalPresentationStyle = .overFullScreen
    vc.modalTransitionStyle   = .crossDissolve
    present(vc, animated: false)
}

extension HDDashboardViewController: HDQuickAddDelegate {
    func quickAddDidUpdateData() {
        viewModel.refreshData()               // 刷新 Dashboard 数据
    }
}
```

## 弹窗动画规范

```swift
// 弹出（viewDidAppear）
UIView.animate(
    withDuration: 0.35,
    delay: 0,
    usingSpringWithDamping: 0.85,
    initialSpringVelocity: 0.5,
    animations: { self.sheetView.transform = .identity }
)

// 收起（performDismiss）
UIView.animate(withDuration: 0.25, animations: {
    self.sheetView.transform = CGAffineTransform(translationX: 0, y: 400)
    self.view.backgroundColor = .clear
})
```

## 常见问题

**Delegate 无效**：确认 `fabTapped` 中设置了 `vc.delegate = self`，且 Dashboard conform 了 `HDQuickAddDelegate`

**dismiss 后 Dashboard 数据不刷新**：确认 `delegate?.quickAddDidUpdateData()` 在 `completion` 闭包中 `dismiss` **之前**调用

**步数显示不更新**：确认 `stepsSlider` 的 `valueChanged` 调用了 `viewModel.updateStepsDisplay(Int(slider.value))`
