---
name: health-data-model
description: HDHealthDataModel 全局数据单例的完整说明。当需要读写健康数据、理解数据结构、使用步数/喝水/睡眠/心情数据时自动加载。
---

# health-data-model · 数据模型知识库

## HDHealthDataModel 完整接口

```objc
// 获取单例
+ (instancetype)shared;

// ── 步数 ──
@property NSInteger todaySteps;        // 今日步数（读写）
@property NSInteger stepsGoal;         // 目标步数（读写，默认10000）
@property (readonly) CGFloat stepsProgress;  // 完成进度 0.0~1.0

// ── 喝水 ──
@property CGFloat waterML;             // 今日饮水量 ml（读写）
@property CGFloat waterGoalML;         // 目标饮水量 ml（读写，默认2000）
@property (readonly) CGFloat waterProgress;  // 完成进度 0.0~1.0

// ── 睡眠 ──
@property NSArray<NSNumber *> *sleepHours;  // 近7天睡眠小时数

// ── 心情 ──
@property NSArray<HDMoodRecord *> *moodRecords;  // 历史心情记录
@property (readonly, nullable) HDMoodRecord *latestMood;  // 最新心情

// ── 主题 ──
@property BOOL isDarkMode;             // 深色模式开关

// ── 写入方法（必须用这些方法写入，不得直接赋值）──
- (void)addWater:(CGFloat)ml;          // 添加饮水记录
- (void)addSteps:(NSInteger)steps;     // 添加步数
- (void)addMood:(NSInteger)level;      // 添加心情（1-5）

// ── 计算方法 ──
- (CGFloat)caloryForSteps:(NSInteger)steps;  // 步数换算卡路里
```

## HDMoodRecord 接口

```objc
@property NSInteger moodLevel;    // 1=很差 2=差 3=一般 4=好 5=很好
@property NSDate *timestamp;      // 记录时间
@property (readonly) NSString *emojiString;  // 对应 emoji 字符串
```

## 正确使用示例

```objc
// ✅ 读取数据
HDHealthDataModel *m = [HDHealthDataModel shared];
NSInteger steps = m.todaySteps;
CGFloat progress = m.stepsProgress;  // 直接用，不要手动计算

// ✅ 写入数据
[[HDHealthDataModel shared] addWater:250.0];
[[HDHealthDataModel shared] addMood:4];

// ✅ 睡眠数据（最新在最后）
NSArray *sleep = [HDHealthDataModel shared].sleepHours;
NSNumber *lastNight = sleep.lastObject;  // 昨晚睡眠

// ❌ 错误：直接赋值
[HDHealthDataModel shared].waterML += 250;  // 禁止
```

## 进度计算说明

`stepsProgress = todaySteps / stepsGoal`（由 Model 内部计算，调用方直接使用）
`waterProgress = waterML / waterGoalML`（同上）

结果已 clamp 到 0.0~1.0，无需额外处理。

---

## 数据关系图

```
HDHealthDataModel (单例)
│
├── 步数维度
│   ├── todaySteps: NSInteger      今日步数
│   ├── stepsGoal: NSInteger       目标（默认10000）
│   └── stepsProgress: CGFloat     进度 = todaySteps/stepsGoal [0,1]
│
├── 喝水维度
│   ├── waterML: CGFloat           今日饮水 ml
│   ├── waterGoalML: CGFloat       目标（默认2000ml）
│   └── waterProgress: CGFloat     进度 = waterML/waterGoalML [0,1]
│
├── 睡眠维度
│   └── sleepHours: NSArray        近7天，index0=最早，index6=昨晚
│
├── 心情维度
│   ├── moodRecords: NSArray       HDMoodRecord 数组，按时间升序
│   └── latestMood: HDMoodRecord?  最新一条，可能为 nil
│
└── 系统
    └── isDarkMode: BOOL           主题状态

HDMoodRecord
├── moodLevel: NSInteger   1-5
├── timestamp: NSDate      记录时间
└── emojiString: NSString  readonly，根据 moodLevel 返回 emoji
```

## 卡路里计算参考

`caloryForSteps:` 内部算法：约 0.04 kcal/步（因人而异）
- 1000步 ≈ 40 kcal
- 5000步 ≈ 200 kcal
- 10000步 ≈ 400 kcal
