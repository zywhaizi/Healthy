---
name: page-profile
description: 个人中心页面（HDProfileViewController）的业务逻辑、主题切换、数据统计展示规范。
---

# page-profile · 个人中心知识库

> 当前实现：`Controllers/HDProfileViewController.swift`（Swift + Combine + MVVM）

## 页面职责

个人中心：展示今日数据摘要、目标配置（步数/喝水）、主题切换。

## 架构结构

```
HDProfileViewController
  └── HDProfileViewModel（@Published UI 状态）
        └── HDHealthDataModel.shared（数据源）
```

## 主题切换实现（实际写法）

```swift
@objc private func themeSwitchChanged() {
    HDHealthDataModel.shared.isDarkMode.toggle()
    applyTheme()
}

HDHealthDataModel.shared.$isDarkMode
    .receive(on: DispatchQueue.main)
    .sink { [weak self] _ in
        self?.refreshData()
        self?.applyTheme()
    }
    .store(in: &cancellables)
```

## 数据读取与展示

```swift
private func refreshData() {
    let model = HDHealthDataModel.shared
    viewModel.todayStepsText = "\(model.todaySteps)"
    viewModel.waterMLText = String(format: "%.0fml", model.waterML)
    viewModel.sleepHoursText = String(format: "%.1fh", model.sleepHours.last ?? 0)
    viewModel.stepsGoalText = "\(model.stepsGoal)"
    viewModel.waterGoalText = String(format: "%.0f", model.waterGoalML)
    viewModel.isDarkMode = model.isDarkMode
    viewModel.updateThemeColors()
}
```

## 目标设置规则

- 步数目标来源：`HDHealthDataModel.shared.stepsGoal`
- 喝水目标来源：`HDHealthDataModel.shared.waterGoalML`
- 不直接修改：`sleepHours`、`moodRecords`

## applyTheme 责任

```swift
@objc func applyTheme() {
    view.backgroundColor = viewModel.backgroundColor
    scrollView.backgroundColor = viewModel.backgroundColor
    contentView.backgroundColor = viewModel.backgroundColor
    titleLabel?.textColor = viewModel.textColor
    nameLabel?.textColor = viewModel.textColor
    themeCard?.backgroundColor = viewModel.cardBackgroundColor
    goalCard?.backgroundColor = viewModel.cardBackgroundColor
}
```

## 常见问题

**主题切换后部分颜色不刷新**：检查 `applyTheme()` 是否覆盖所有缓存的 UI 引用（`titleLabel`、`themeCard`、`goalCard`）。

**统计不更新**：检查 `setupBindings()` 是否订阅了 `todaySteps`、`waterML`、`sleepHours`。
