---
name: known-issues
description: HealthDashboard 项目的已知问题、Bug 和解决方案
---

# 已知问题和解决方案

## 1. Dark Mode 颜色适配问题

**问题**：HDTabBarController.m 中硬编码了 RGB 颜色值，Dark Mode 下显示错误
**位置**：`HealthDashboard/Controllers/HDTabBarController.m` 第 52-60 行
**症状**：
- Light Mode 下颜色正确
- Dark Mode 下颜色不变，导致对比度不足

**根本原因**：
```objc
// ❌ 硬编码颜色
app.backgroundColor = dark
    ? [UIColor colorWithRed:0.08 green:0.11 blue:0.18 alpha:1.0]
    : [UIColor colorWithRed:0.97 green:0.97 blue:0.99 alpha:1.0];
```

**解决方案**：
```objc
// ✅ 使用语义色
app.backgroundColor = UIColor.systemBackgroundColor;
```

**状态**：🔴 未修复（需要优先处理）
**优先级**：高（影响用户体验）

---

## 2. performSelector 使用问题

**问题**：HDTabBarController.m 中使用了被禁止的 `performSelector`
**位置**：`HealthDashboard/Controllers/HDTabBarController.m` 第 75 行
**症状**：
- 代码可读性差
- 绕过编译器类型检查
- 容易产生运行时错误

**根本原因**：
```objc
// ❌ 使用 performSelector
[nav.topViewController performSelector:@selector(applyTheme)];
```

**解决方案**：
```objc
// ✅ 直接调用
if ([nav.topViewController respondsToSelector:@selector(applyTheme)]) {
    [(id)nav.topViewController applyTheme];
}
```

**状态**：🔴 未修复（违反 global-always.mdc）
**优先级**：高（代码质量）

---

## 3. QuickAdd Tab 缺失

**问题**：HDTabBarController 只有 2 个 Tab（Dashboard 和 Profile），缺少 QuickAdd Tab
**位置**：`HealthDashboard/Controllers/HDTabBarController.m` 第 40 行
**症状**：
- 快速录入功能无法访问
- 页面导航不完整

**根本原因**：
```objc
// ❌ 只有 2 个 Tab
self.viewControllers = @[dashNav, profNav];
```

**解决方案**：
```objc
// ✅ 添加 QuickAdd Tab
HDQuickAddViewController *quickAdd = [HDQuickAddViewController new];
UINavigationController *quickAddNav = [[UINavigationController alloc] initWithRootViewController:quickAdd];
quickAddNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"快速录入" image:[UIImage systemImageNamed:@"plus.circle.fill"] tag:1];

self.viewControllers = @[dashNav, quickAddNav, profNav];
```

**状态**：🔴 未修复（功能缺失）
**优先级**：高（核心功能）

---

## 4. Delegate 设置缺失

**问题**：HDTabBarController 没有设置 QuickAdd 的 delegate
**位置**：`HealthDashboard/Controllers/HDTabBarController.m` 的 `viewDidLoad` 中
**症状**：
- QuickAdd 录入后无法通知 Dashboard 刷新
- 数据更新不会立即显示

**根本原因**：
```objc
// ❌ 缺少 delegate 设置
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTabs];
    // 没有设置 quickAdd.delegate = dashboard
}
```

**解决方案**：
```objc
// ✅ 在 setupTabs 后设置 delegate
HDQuickAddViewController *quickAdd = self.viewControllers[1];
HDDashboardViewController *dashboard = self.viewControllers[0];
quickAdd.delegate = dashboard;
```

**状态**：🔴 未修复（依赖于 QuickAdd Tab 的添加）
**优先级**：高（核心通信机制）

---

## 5. 语义色未全面应用

**问题**：项目中虽然定义了语义色规范，但实际代码中没有使用
**位置**：所有 ViewController 和 View 文件
**症状**：
- Dark Mode 适配不完整
- 颜色硬编码分散在各处

**根本原因**：
- design-system Skill 是后来添加的
- 现有代码是在没有规范的情况下编写的

**解决方案**：
- 逐步重构，将硬编码颜色替换为语义色
- 优先处理 HDTabBarController（已识别）
- 其次处理其他 ViewController

**状态**：🟡 部分修复（HDTabBarController 待修）
**优先级**：中（长期改进）

---

## 6. applyTheme 实现不完整

**问题**：某些 ViewController 可能没有完整实现 `applyTheme` 方法
**位置**：待检查所有 ViewController
**症状**：
- 主题切换时某些 UI 元素颜色不变
- Dark Mode 适配不完整

**根本原因**：
- applyTheme 是后来强制要求的
- 现有代码可能有遗漏

**解决方案**：
- 检查所有 ViewController 是否实现了 applyTheme
- 检查 applyTheme 中是否覆盖了所有 UI 元素

**状态**：🟡 待检查
**优先级**：中（质量保证）

---

## 修复优先级排序

| 优先级 | 问题 | 影响 | 工作量 |
|---|---|---|---|
| 🔴 高 | Dark Mode 颜色 | 用户体验 | 小 |
| 🔴 高 | performSelector | 代码质量 | 小 |
| 🔴 高 | QuickAdd Tab 缺失 | 核心功能 | 中 |
| 🔴 高 | Delegate 设置 | 核心通信 | 小 |
| 🟡 中 | 语义色全面应用 | 长期维护 | 大 |
| 🟡 中 | applyTheme 完整性 | 质量保证 | 中 |

---

## 修复建议

**立即修复**（本周）：
1. 修复 HDTabBarController 的硬编码颜色
2. 修复 performSelector 问题
3. 添加 QuickAdd Tab 和 Delegate 设置

**后续改进**（下周）：
1. 全面应用语义色
2. 检查所有 applyTheme 实现
3. 运行质量门禁检查
