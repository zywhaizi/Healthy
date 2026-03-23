---
name: page-profile
description: 个人中心页面（HDProfileViewController）的业务逻辑、主题切换、数据统计展示规范。
---

# page-profile · 个人中心知识库

## 页面职责

个人中心：健康数据统计回顾、目标设置、Dark/Light Mode 主题切换。

## 主题切换实现

```objc
- (void)didToggleTheme:(UISwitch *)sender {
    [HDHealthDataModel shared].isDarkMode = sender.isOn;
    // 通知全局刷新主题
    [[NSNotificationCenter defaultCenter]
        postNotificationName:@"HDThemeDidChangeNotification" object:nil];
    [self applyTheme];
}

- (void)applyTheme {
    BOOL dark = [HDHealthDataModel shared].isDarkMode;
    self.view.backgroundColor = UIColor.systemGroupedBackgroundColor;
    self.titleLabel.textColor = UIColor.labelColor;
    // 同步 Switch 状态
    self.themeSwitch.on = dark;
}
```

## 数据统计展示

```objc
// 7天平均睡眠
- (CGFloat)averageSleepHours {
    NSArray *hours = [HDHealthDataModel shared].sleepHours;
    if (hours.count == 0) return 0;
    CGFloat total = 0;
    for (NSNumber *h in hours) total += h.floatValue;
    return total / hours.count;
}

// 今日卡路里
- (CGFloat)todayCalories {
    HDHealthDataModel *m = [HDHealthDataModel shared];
    return [m caloryForSteps:m.todaySteps];
}

// 心情趋势（最近N条）
- (NSArray *)recentMoods:(NSInteger)count {
    NSArray *records = [HDHealthDataModel shared].moodRecords;
    if (records.count <= count) return records;
    return [records subarrayWithRange:NSMakeRange(records.count - count, count)];
}
```

## 目标设置

```objc
// 修改步数目标
- (void)updateStepsGoal:(NSInteger)goal {
    if (goal < 1000 || goal > 50000) return;  // 校验范围
    [HDHealthDataModel shared].stepsGoal = goal;
    // 不需要通知 delegate，Dashboard viewWillAppear 会自动刷新
}

// 修改喝水目标
- (void)updateWaterGoal:(CGFloat)goalML {
    if (goalML < 500 || goalML > 5000) return;
    [HDHealthDataModel shared].waterGoalML = goalML;
}
```

## 禁止事项

- 不在此页面录入新数据（录入功能在 QuickAdd）
- 不直接修改 `moodRecords` / `sleepHours` 数组
