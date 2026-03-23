# Exercise 模块 UI 规格

## 页面结构

### 1. 运动类型选择页面 (HDExerciseTypeViewController)

**布局**：
- 顶部：标题 "选择运动类型"
- 中部：运动类型网格（2列）
- 底部：取消按钮

**运动类型卡片**：
- 尺寸：(屏幕宽-32)/2 × 120pt
- 圆角：12pt
- 内边距：12pt
- 元素：emoji(32pt) + 名称(14pt) + 描述(11pt)
- 间距：8pt

**颜色**：
- 背景：`secondarySystemBackgroundColor`
- 文字：`labelColor`
- 选中态：蓝色边框 2pt

### 2. 运动计时页面 (HDExerciseTimerViewController)

**布局**：
- 顶部：运动类型 + 返回按钮
- 中部：大时间显示 + 进度环
- 下部：控制按钮（暂停/继续/完成）

**时间显示**：
- 字体：`monospacedDigitSystemFontOfSize:48 weight:bold`
- 颜色：`systemBlueColor`
- 格式：MM:SS

**进度环**：
- 半径：80pt
- 线宽：8pt
- 颜色：`systemBlueColor`
- 背景：`systemGray3Color`

**控制按钮**：
- 尺寸：56×56pt
- 圆角：28pt
- 间距：16pt
- 暂停：`systemYellowColor`
- 完成：`systemGreenColor`

### 3. 运动统计页面 (HDExerciseSummaryViewController)

**布局**：
- 顶部：运动类型 + 时间
- 中部：统计卡片（时长、卡路里、心率）
- 下部：保存/重新开始按钮

**统计卡片**：
- 尺寸：(屏幕宽-32) × 80pt
- 圆角：12pt
- 内边距：16pt
- 布局：标题(11pt) + 数值(28pt bold)

**数值格式**：
- 时长：`00:45` (MM:SS)
- 卡路里：`245 kcal`
- 心率：`128 bpm`

### 4. 运动设置页面 (HDExerciseSettingViewController)

**布局**：
- 顶部：标题 "运动目标"
- 中部：目标设置表单
- 底部：保存按钮

**表单项**：
- 每日目标时长：输入框 + 单位(分钟)
- 目标卡路里：输入框 + 单位(kcal)
- 运动提醒：开关

**输入框**：
- 高度：44pt
- 圆角：8pt
- 边框：1pt `separatorColor`
- 内边距：12pt

## 间距规范

```
顶部留白：16pt
卡片间距：12pt
内边距：16pt
元素间距：8pt
底部留白：16pt + tabBar高度
```

## 字体规范

```
标题：systemFont 17pt semibold
副标题：systemFont 14pt regular
数值：monospacedDigitSystemFont 28pt bold
说明：systemFont 11pt regular
```

## 颜色映射

| 用途 | Light Mode | Dark Mode |
|---|---|---|
| 背景 | #F5F7FA | #0F1218 |
| 卡片 | #FFFFFF | #1F2633 |
| 文字主 | #1A1F2E | #FFFFFF |
| 文字次 | #8C92A4 | #8C92A4 |
| 运动类型 | 见下表 | 见下表 |

## 运动类型颜色

| 类型 | 颜色 | Hex |
|---|---|---|
| 跑步 | Red | #FF6B6B |
| 骑行 | Teal | #4ECDC4 |
| 游泳 | Blue | #45B7D1 |
| 散步 | Green | #96CEB4 |
| 瑜伽 | Yellow | #FFEAA7 |
| 力量训练 | Orange | #DDA15E |

## 动画规范

- 页面转场：0.3s ease-in-out
- 按钮点击：0.12s scale down + 0.18s scale up
- 计时器更新：无动画（实时更新）
- 进度环：0.5s ease-out
