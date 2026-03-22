---
name: page-exercise
description: 运动模块（HDExerciseTypeViewController、HDExerciseTimerViewController、HDExerciseSummaryViewController、HDExerciseSettingViewController）的业务逻辑、Delegate 通信、计时器实现规范。
---

# page-exercise · 运动模块知识库

## 页面职责

运动模块：运动类型选择 → 实时计时 → 统计展示 → 目标设置

| 页面 | 职责 |
|---|---|
| HDExerciseTypeViewController | 展示6种运动类型供用户选择 |
| HDExerciseTimerViewController | 实时计时、暂停/继续、完成运动 |
| HDExerciseSummaryViewController | 展示本次运动的统计数据（时长、卡路里等） |
| HDExerciseSettingViewController | 设置每日运动目标 |

## 必做清单

```
每个 ViewController:
  ☐ viewWillAppear 中调用 refreshData() 和 applyTheme()
  ☐ 实现 applyTheme 方法
  ☐ NS_ASSUME_NONNULL_BEGIN/END 包裹
  ☐ HD 前缀命名

数据操作:
  ☐ 写入: [[HDHealthDataModel shared] addExercise:record]
  ☐ 读取: Model 的 readonly 属性
  ☐ 禁止直接修改 Model 属性
  ☐ 禁止在 View 中访问 Model

计时器:
  ☐ 使用 dispatch_source_create（不用 NSTimer）
  ☐ dealloc 中调用 dispatch_source_cancel
  ☐ 不阻塞主线程

Delegate:
  ☐ delegate 属性声明为 weak
  ☐ 运动完成后调用 exerciseDidComplete:
  ☐ 在 TabBarController 中设置 delegate
```

## Delegate 通信

```objc
@protocol HDExerciseDelegate <NSObject>
- (void)exerciseDidComplete:(HDExerciseRecord *)record;
- (void)exerciseDidCancel;
@end

// 在 HDExerciseTimerViewController 中
- (void)finishExercise {
    HDExerciseRecord *record = [HDExerciseRecord new];
    record.exerciseType = self.selectedType;
    record.durationMinutes = self.elapsedSeconds / 60;
    record.caloriesBurned = [self calculateCalories];
    
    [[HDHealthDataModel shared] addExercise:record];
    
    if ([self.delegate respondsToSelector:@selector(exerciseDidComplete:)]) {
        [self.delegate exerciseDidComplete:record];
    }
}
```

## 计时器实现（dispatch_source）

```objc
@property dispatch_source_t timerSource;

- (void)startTimer {
    self.timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(self.timerSource, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.timerSource, ^{
        self.elapsedSeconds++;
        [self updateTimerDisplay];
    });
    dispatch_resume(self.timerSource);
}

- (void)stopTimer {
    if (self.timerSource) {
        dispatch_source_cancel(self.timerSource);
        self.timerSource = nil;
    }
}

- (void)dealloc {
    [self stopTimer];
}
```

## 卡路里计算

```objc
- (CGFloat)calculateCaloriesForType:(HDExerciseType)type duration:(NSInteger)minutes {
    CGFloat caloriesPerMinute = 0;
    switch (type) {
        case HDExerciseTypeRunning:     caloriesPerMinute = 10.0;  break;
        case HDExerciseTypeCycling:     caloriesPerMinute = 8.0;   break;
        case HDExerciseTypeSwimming:    caloriesPerMinute = 11.0;  break;
        case HDExerciseTypeWalking:     caloriesPerMinute = 4.0;   break;
        case HDExerciseTypeYoga:        caloriesPerMinute = 3.5;   break;
        case HDExerciseTypeStrength:    caloriesPerMinute = 6.0;   break;
    }
    return caloriesPerMinute * minutes;
}
```

## 主题适配

```objc
- (void)applyTheme {
    BOOL dark = [HDHealthDataModel shared].isDarkMode;
    UIColor *bg = dark ? [UIColor colorWithRed:0.06 green:0.08 blue:0.14 alpha:1.0]
                       : [UIColor colorWithRed:0.93 green:0.95 blue:0.97 alpha:1.0];
    self.view.backgroundColor = bg;
    // 更新其他 UI 元素颜色
}
```

## 禁止事项

- 禁止直接修改 Model 数据（如 `model.todayExerciseMinutes = 60`）
- 禁止在 View 中访问 `[HDHealthDataModel shared]`
- 禁止硬编码颜色值（使用语义色）
- 禁止使用 NSTimer（会阻塞主线程）
- 禁止使用 performSelector

## 常见问题

**Q: 如何在计时器中更新 UI？**
A: 使用 `dispatch_source_create` 在主线程更新：
```objc
dispatch_source_set_event_handler(self.timerSource, ^{
    self.elapsedSeconds++;
    [self updateTimerDisplay];  // 主线程更新 UI
});
```

**Q: 如何避免循环引用？**
A: Delegate 必须声明为 `weak`：
```objc
@property (nonatomic, weak) id<HDExerciseDelegate> delegate;
```

**Q: 如何响应主题切换？**
A: 在 `viewWillAppear:` 中调用 `applyTheme`

## 详细参考

- **UI 规格**: `references/ui-spec.md` - 4个页面的布局、颜色、字体、间距
- **数据模型**: `references/data-model.md` - Model 接口、Record 结构、计算方法
- **质量检查**: `scripts/validate.sh` - 6项自动检查
- **行为约束**: `.cursor/rules/page-exercise.mdc` - 禁止事项、必须遵守
