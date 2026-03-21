---
name: design-system
description: HealthDashboard 设计系统：颜色、字体、间距、Dark Mode 适配规范。需要处理 UI 样式时自动加载。
---

# design-system · 设计系统

## 颜色（禁止硬编码，使用系统语义色）

```objc
// 背景
UIColor.systemBackgroundColor             // 主背景
UIColor.secondarySystemBackgroundColor    // 卡片背景

// 文字
UIColor.labelColor                        // 主文字
UIColor.secondaryLabelColor               // 次要文字
UIColor.tertiaryLabelColor                // 辅助文字

// 强调色
UIColor.systemBlueColor                   // 步数/主操作
UIColor.systemCyanColor                   // 喝水
UIColor.systemIndigoColor                 // 睡眠
UIColor.systemYellowColor                 // 心情
UIColor.systemGreenColor                  // 完成状态
UIColor.systemRedColor                    // 警告/未达标

// 结构
UIColor.separatorColor                    // 分割线
UIColor.systemGroupedBackgroundColor      // 分组背景
```

## 字体规范

```objc
// 标题
[UIFont systemFontOfSize:28 weight:UIFontWeightBold]      // 大数字（步数、卡路里）
[UIFont systemFontOfSize:17 weight:UIFontWeightSemibold]  // 卡片标题
[UIFont systemFontOfSize:15 weight:UIFontWeightMedium]    // 次级标题

// 正文
[UIFont systemFontOfSize:13 weight:UIFontWeightRegular]   // 说明文字
[UIFont systemFontOfSize:11 weight:UIFontWeightRegular]   // 辅助标注

// 数字优先用
[UIFont monospacedDigitSystemFontOfSize:24 weight:UIFontWeightBold]
```

## 间距规范（8pt 基准网格）

```
4pt  — 极小间距（icon 与文字）
8pt  — 小间距（卡片内元素）
12pt — 中间距（卡片内分组）
16pt — 标准间距（卡片内边距、卡片间距）
24pt — 大间距（区块间）
32pt — 超大间距（页面顶部留白）
```

## 圆角规范

```
8pt  — 小组件（按钮、标签）
12pt — 卡片（HDDashboardCardView）
16pt — 大卡片
全圆 — 进度环、头像
```

## Dark Mode 适配原则

1. 只用语义色，不用 `[UIColor colorWithRed:...]` 硬编码
2. 图片资源在 Assets.xcassets 中提供 Dark Mode 变体
3. 阴影在 Dark Mode 下减弱或去除（深色背景阴影不明显）
4. `applyTheme` 方法负责所有主题切换，不在其他地方写主题逻辑

## 进度环颜色映射

```objc
// 根据完成度动态变色
if (progress < 0.3)       return UIColor.systemRedColor;
else if (progress < 0.7)  return UIColor.systemYellowColor;
else if (progress < 1.0)  return UIColor.systemBlueColor;
else                      return UIColor.systemGreenColor;  // 完成
```
