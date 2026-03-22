---
name: ios-objc-patterns
description: HealthDashboard 项目中使用的 iOS ObjC 设计模式。当需要实现 Delegate、单例调用、主题系统、跨VC通信时自动加载。
---

# ios-objc-patterns · ObjC 设计模式知识库

## 1. 单例模式（Singleton）

```objc
// 标准写法（HDHealthDataModel 已实现）
+ (instancetype)shared {
    static HDHealthDataModel *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
```

## 2. Delegate 模式

```objc
// 声明 Protocol（在委托方的 .h 文件）
@protocol HDQuickAddDelegate <NSObject>
- (void)quickAddDidUpdateData;
@end

// 声明 delegate 属性（必须 weak）
@property (nonatomic, weak) id<HDQuickAddDelegate> delegate;

// 调用（先判断是否响应）
if ([self.delegate respondsToSelector:@selector(quickAddDidUpdateData)]) {
    [self.delegate quickAddDidUpdateData];
}

// 设置 delegate（在 HDTabBarController 中）
quickAddVC.delegate = dashboardVC;
```

## 3. 主题系统模式

```objc
// 所有 VC 必须实现此方法
- (void)applyTheme {
    BOOL dark = [HDHealthDataModel shared].isDarkMode;
    
    // 背景色
    self.view.backgroundColor = dark
        ? [UIColor systemBackgroundColor]
        : [UIColor systemBackgroundColor];
    
    // 标题色
    self.titleLabel.textColor = dark
        ? [UIColor labelColor]
        : [UIColor labelColor];
    
    // 递归应用子 View
    [self.cardView applyTheme];
}

// TabBar 统一协调（在 HDTabBarController）
for (UIViewController *vc in self.viewControllers) {
    if ([vc respondsToSelector:@selector(applyTheme)]) {
        [(id)vc applyTheme];
    }
}
```

## 4. 数据刷新模式

```objc
// viewWillAppear 中刷新（标准写法）
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshData];
    [self applyTheme];
}

- (void)refreshData {
    HDHealthDataModel *m = [HDHealthDataModel shared];
    self.ringView.progress = m.stepsProgress;
    self.waterView.progress = m.waterProgress;
    self.sleepBarView.sleepHours = m.sleepHours;
    self.moodView.moodRecords = m.moodRecords;
}
```

## 5. NSNotification 主题广播（可选）

```objc
// 发送通知（切换主题时）
[[NSNotificationCenter defaultCenter]
    postNotificationName:@"HDThemeDidChangeNotification" object:nil];

// 监听（在需要响应的 VC 的 viewDidLoad）
[[NSNotificationCenter defaultCenter]
    addObserver:self
    selector:@selector(applyTheme)
    name:@"HDThemeDidChangeNotification"
    object:nil];

// 取消监听（在 dealloc）
[[NSNotificationCenter defaultCenter] removeObserver:self];
```

---

## 模式选择决策树

```
需要跨 VC 传递数据？
├── 一对一，单向回调 → Delegate 模式（HDQuickAddDelegate）
├── 一对多，广播通知 → NSNotification（主题切换）
└── 全局共享状态   → Singleton（HDHealthDataModel）

需要异步操作？
├── UI 更新 → dispatch_async(dispatch_get_main_queue(), ^{...})
├── 后台计算 → dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT,0), ^{...})
└── 一次性初始化 → dispatch_once

内存管理？
├── 强引用（持有）→ strong（默认）
├── 避免循环引用 → weak（delegate、block 内 self）
└── 基本类型     → assign
```

## 项目中的模式实例

| 模式 | 实例 | 位置 |
|---|---|---|
| Singleton | `[HDHealthDataModel shared]` | Models/ |
| Delegate | `HDQuickAddDelegate` | Controllers/HDQuickAdd* |
| Observer | `HDThemeDidChangeNotification` | 全局主题切换 |
| Template Method | `applyTheme` | 所有 ViewController |
