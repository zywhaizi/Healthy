---
name: page-tabbar
description: TabBar 控制器（HDTabBarController）的结构、主题协调、Delegate 配置规范。
---

# page-tabbar · TabBar 知识库

## Tab 结构（顺序不得变更）

```
Tab 0: HDDashboardViewController   首页仪表盘
Tab 1: HDQuickAddViewController    快速录入
Tab 2: HDProfileViewController     个人中心
```

## viewDidLoad 必须完成的配置

```objc
- (void)viewDidLoad {
    [super viewDidLoad];

    // 1. 设置 QuickAdd 的 delegate 为 Dashboard
    HDQuickAddViewController *quickAdd = self.viewControllers[1];
    HDDashboardViewController *dashboard = self.viewControllers[0];
    quickAdd.delegate = dashboard;

    // 2. 监听主题变化
    [[NSNotificationCenter defaultCenter]
        addObserver:self
        selector:@selector(applyTheme)
        name:@"HDThemeDidChangeNotification"
        object:nil];

    // 3. 应用初始主题
    [self applyTheme];
}
```

## 主题协调

```objc
- (void)applyTheme {
    BOOL dark = [HDHealthDataModel shared].isDarkMode;
    self.tabBar.barTintColor = UIColor.systemBackgroundColor;
    self.tabBar.tintColor = dark ? UIColor.systemBlueColor : UIColor.systemBlueColor;

    for (UIViewController *vc in self.viewControllers) {
        if ([vc respondsToSelector:@selector(applyTheme)]) {
            [(id)vc applyTheme];
        }
    }
}
```

## 角标规范

```objc
- (void)updateBadges {
    HDHealthDataModel *m = [HDHealthDataModel shared];

    // 步数角标：未完成时显示剩余步数
    if (m.stepsProgress < 1.0) {
        NSInteger remaining = m.stepsGoal - m.todaySteps;
        self.viewControllers[0].tabBarItem.badgeValue =
            [NSString stringWithFormat:@"%ld", MIN(remaining, 999)];
    } else {
        self.viewControllers[0].tabBarItem.badgeValue = nil;
    }
}
```

## 禁止事项

- TabBar 不处理业务逻辑，只做协调
- Tab 顺序/数量变更需人工确认
- 不在 TabBar 中直接操作数据
