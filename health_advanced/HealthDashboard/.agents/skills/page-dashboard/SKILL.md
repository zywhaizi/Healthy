---
name: page-dashboard
description: 仪表盘页面（HDDashboardViewController）的业务逻辑、UI 组件使用、数据展示规范。修改仪表盘相关代码时自动加载。
---

# page-dashboard · 仪表盘知识库

## 页面职责

首页仪表盘，展示今日健康数据概览：步数进度环、喝水量、近7天睡眠趋势、心情记录。

## UI 组件与数据绑定

```objc
- (void)refreshData {
    HDHealthDataModel *m = [HDHealthDataModel shared];

    // 步数进度环
    self.ringView.progress = m.stepsProgress;        // 0.0~1.0
    self.stepsLabel.text = [NSString stringWithFormat:@"%ld", m.todaySteps];
    self.stepsGoalLabel.text = [NSString stringWithFormat:@"目标 %ld 步", m.stepsGoal];

    // 喝水
    self.waterView.progress = m.waterProgress;
    self.waterLabel.text = [NSString stringWithFormat:@"%.0f ml", m.waterML];

    // 睡眠（近7天）
    self.sleepBarView.sleepHours = m.sleepHours;

    // 心情
    self.moodView.moodRecords = m.moodRecords;
    HDMoodRecord *latest = m.latestMood;
    if (latest) {
        self.moodLabel.text = latest.emojiString;
    }

    // 卡路里
    CGFloat cal = [m caloryForSteps:m.todaySteps];
    self.caloriesLabel.text = [NSString stringWithFormat:@"%.0f kcal", cal];
}
```

## HDQuickAddDelegate 实现

```objc
// Dashboard 实现此协议，在 TabBar 中被设为 QuickAdd 的 delegate
- (void)quickAddDidUpdateData {
    [self refreshData];  // 收到录入通知，刷新所有数据
}
```

## 刷新时机

```objc
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshData];
    [self applyTheme];
}
```

## 卡片布局规范

- 卡片间距：16pt
- 卡片圆角：12pt，内边距：16pt
- 步数卡片：全宽，进度环居中
- 喝水 + 心情：并排两列
- 睡眠：全宽，7天柱状图

## 常见问题

**数据不刷新**：检查 `viewWillAppear` 是否调用 `refreshData`

**进度环不动**：检查 `HDRingProgressView.progress` 是否为 CGFloat（不是 NSInteger）

**睡眠数据显示异常**：检查 `sleepHours` 数组长度是否为 7，不足时补 0
