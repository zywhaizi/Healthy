---
name: page-dashboard
description: 仪表盘页面（HDDashboardViewController）的业务逻辑、UI 组件使用、数据展示规范。修改仪表盘相关代码时自动加载。
---

# page-dashboard · 仪表盘知识库

> ✅ 已迁移至 Swift + MVVM（2026/3/22）
> 源文件：`Controllers/HDDashboardViewController.swift`

## 页面职责

首页仪表盘，展示今日健康数据概览：步数进度环、喝水量、近7天睡眠趋势、心情记录。

## 架构结构

```
HDDashboardViewController   ← UIViewController，持有 ViewModel
  └── HDDashboardViewModel  ← ObservableObject，@Published 属性驱动 UI
        └── HDHealthDataModel.shared()  ← OC 单例，只读访问
```

## ViewModel 数据绑定

```swift
// ViewModel 通过 refreshData() 从 OC Model 读取数据
func refreshData() {
    let m = HDHealthDataModel.shared()
    stepsText = "\(m.todaySteps)"
    stepsProgress = m.stepsProgress
    waterProgress = m.waterProgress
    waterText = String(format: "%.0f/%.0fml", m.waterML, m.waterGoalML)
    sleepHours = m.sleepHours
    moodRecords = m.moodRecords
    // ...其他字段
}
```

## ViewController 绑定写法

```swift
// setupBindings() 中订阅 ViewModel @Published 属性
viewModel.$stepsText
    .receive(on: DispatchQueue.main)
    .sink { [weak self] t in self?.stepsLabel.text = t }
    .store(in: &cancellables)

viewModel.$stepsProgress
    .receive(on: DispatchQueue.main)
    .sink { [weak self] p in self?.ringView.setProgress(p, animated: true) }
    .store(in: &cancellables)
```

## HDQuickAddDelegate 实现

```swift
// Dashboard conform HDQuickAddDelegate，收到录入通知后刷新
extension HDDashboardViewController: HDQuickAddDelegate {
    func quickAddDidUpdateData() {
        viewModel.refreshData()
    }
}
```

## 刷新时机

```swift
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.refreshData()   // 必须调用
    applyTheme()
}
```

## FAB 点击弹出 QuickAdd

```swift
@objc private func fabTapped() {
    let vc = HDQuickAddViewController()  // 直接实例化 Swift 类
    vc.delegate = self
    vc.modalPresentationStyle = .overFullScreen
    vc.modalTransitionStyle   = .crossDissolve
    present(vc, animated: false)
}
```

## TabBar 入口（HDTabBarController.m）

```objc
// Dashboard 是 Swift 类，通过 NSClassFromString 动态加载
Class dashClass = NSClassFromString(@"HealthDashboard.HDDashboardViewController");
UIViewController *dash = [[dashClass alloc] init];
```

## 卡片布局规范

- 卡片间距：16pt
- 卡片圆角：12pt，内边距：16pt
- 步数卡片：全宽，进度环左侧，数字右侧
- 喝水卡片：全宽，水波动画
- 睡眠卡片：全宽，7天柱状图
- 心情卡片：全宽，折线趋势图

## OC View 组件 Swift 调用

| 组件 | Swift 调用方式 |
|---|---|
| `HDRingProgressView` | `ringView.setProgress(p, animated: true)` |
| `HDWaterView` | `waterWave.setWaterLevel(p, animated: true)` |
| `HDSleepBarView` | `sleepBar.hoursData = hours; sleepBar.reloadData()` |
| `HDMoodTrendView` | `moodTrend.records = records; moodTrend.reloadData()` |
| `HDDashboardCardView` | `HDDashboardCardView(title:iconEmoji:)` |

> 以上组件均为 OC 实现，通过 Bridging Header 在 Swift 侧调用。
> Bridging Header 路径：`Controllers/HealthDashboard-Bridging-Header.h`

## 常见问题

**数据不刷新**：检查 `viewWillAppear` 是否调用 `viewModel.refreshData()`

**进度环不动**：`ringView.setProgress(_:animated:)` 参数类型为 `CGFloat`

**sleepHours 类型**：OC `NSArray<NSNumber *>` 在 Swift 侧直接赋值给 `[NSNumber]`，无需 `as?` 转型

**moodRecords 类型**：OC `NSArray<HDMoodRecord *>` 在 Swift 侧直接赋值给 `[HDMoodRecord]`
