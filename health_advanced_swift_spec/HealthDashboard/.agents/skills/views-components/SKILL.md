---
name: views-components
description: HealthDashboard 自定义 View 组件的接口说明与使用规范。修改或新建 View 组件时自动加载。
---

# views-components · 自定义组件知识库

## HDRingProgressView · 进度环

```objc
// 关键属性
@property (nonatomic, assign) CGFloat progress;      // 0.0~1.0，驱动进度
@property (nonatomic, strong) UIColor *ringColor;    // 进度弧颜色
@property (nonatomic, assign) CGFloat lineWidth;     // 弧线粗细（默认12pt）

// 使用
self.ringView.progress = [HDHealthDataModel shared].stepsProgress;
```

## HDSleepBarView · 睡眠柱状图

```objc
// 关键属性
@property (nonatomic, strong) NSArray<NSNumber *> *sleepHours;  // 长度必须为7

// 使用
self.sleepBarView.sleepHours = [HDHealthDataModel shared].sleepHours;
// 注意：数组长度不足7时，内部自动补0
```

## HDWaterView · 喝水展示

```objc
@property (nonatomic, assign) CGFloat progress;   // 0.0~1.0
@property (nonatomic, assign) CGFloat waterML;    // 显示当前饮水量文字

// 使用
HDHealthDataModel *m = [HDHealthDataModel shared];
self.waterView.progress = m.waterProgress;
self.waterView.waterML = m.waterML;
```

## HDMoodTrendView · 心情趋势

```objc
@property (nonatomic, strong) NSArray<HDMoodRecord *> *moodRecords;

// 使用
self.moodView.moodRecords = [HDHealthDataModel shared].moodRecords;
```

## HDDashboardCardView · 卡片容器

```objc
// 通用卡片容器，负责圆角、背景色、内边距
// 将其他 View 作为 subview 添加到 contentView
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;   // 卡片标题

// 使用
HDDashboardCardView *card = [[HDDashboardCardView alloc] init];
card.titleLabel.text = @"今日步数";
[card.contentView addSubview:self.ringView];
```

## 所有 View 组件通用规则

- View 不直接访问 `[HDHealthDataModel shared]`，数据由 VC 传入
- View 需响应主题：实现 `applyTheme` 方法
- 使用语义颜色，不硬编码颜色值
- 布局使用 AutoLayout，不使用绝对 frame（除非 drawRect 绘制）
