---
name: page-exercise
description: 运动模块（HDExerciseTypeViewController、HDExerciseSettingViewController、HDExerciseTimerViewController、HDExerciseSummaryViewController）的业务逻辑与实现规范。
---

# page-exercise · 运动模块知识库

> 当前实现：`Controllers/HDExercise*.swift`（Swift + UIKit + Combine）

## 页面职责

| 页面 | 职责 |
|---|---|
| `HDExerciseTypeViewController` | 运动入口选择（目标跑 / 自由跑） |
| `HDExerciseSettingViewController` | 目标跑参数设置（距离/时间） |
| `HDExerciseTimerViewController` | 实时计时、配速、卡路里计算 |
| `HDExerciseSummaryViewController` | 展示本次运动结果并返回根页面 |

## 当前数据链路

```swift
// 计时结束后保存记录
let record = HDExerciseRecord()
record.type = exerciseType
record.durationSeconds = elapsedSeconds
record.distanceKM = currentDistance
record.caloriesBurned = Int(Double(elapsedSeconds) * 0.1)
record.timestamp = Date()

HDHealthDataModel.shared.saveExerciseRecord(record)
```

## 设置页规则

```swift
// 目标设置写入模型配置
let model = HDHealthDataModel.shared
model.targetRunDistanceKM = distance   // 1~50
model.targetRunMinutes = time          // 1~180
```

## 计时器规则（当前实现）

```swift
timer = Timer.scheduledTimer(
    timeInterval: 1.0,
    target: self,
    selector: #selector(updateTimer),
    userInfo: nil,
    repeats: true
)

// 结束或暂停时必须释放
timer?.invalidate()
timer = nil
```

> 说明：当前实现使用 `Timer`，符合页面需求。重点是保证生命周期正确，避免泄漏。

## 主题切换规范

四个页面都需订阅：

```swift
HDHealthDataModel.shared.$isDarkMode
    .receive(on: DispatchQueue.main)
    .sink { [weak self] _ in self?.applyTheme() }
    .store(in: &cancellables)
```

## 禁止事项

- 禁止在 View 中直接读写 Model
- 禁止硬编码颜色值
- 禁止遗漏 `timer?.invalidate()`
- 禁止在计时回调中做耗时操作

## 常见问题

**计时器重复触发**：确认恢复计时时没有重复创建多个 `Timer`。

**目标跑进度不变化**：检查 `targetRunDistanceKM` 是否大于 0 且 `progressView.progress` 使用了 `currentDistance / targetDist`。

**总结页数据为空**：确认进入总结页前赋值了 `vc.exerciseRecord = record`。
