---
name: project-decisions
description: HealthDashboard 项目的关键架构决策和设计理由
---

# 项目关键决策

## 1. 为什么选择 MVC 而不是 MVVM？

**决策**：采用 MVC 架构
**理由**：
- 项目规模小（4个VC，5个View），MVC 足够
- 团队熟悉 ObjC MVC 模式，学习成本低
- 避免过度设计，MVVM 的 ViewModel 层在此项目中收益不大
- 保持代码简洁，便于维护

**权衡**：
- 如果未来功能复杂度大幅增加，可考虑迁移到 MVVM
- 目前 VC 职责清晰（协调 View 和 Model），不会过重

---

## 2. 为什么用单例 HDHealthDataModel？

**决策**：全局数据通过单例 `[HDHealthDataModel shared]` 管理
**理由**：
- 健康数据是全局共享状态，单例是最直接的方案
- 避免 VC 直接持有数据，减少内存泄漏风险
- 简化 VC 间通信，不需要复杂的数据传递链路
- 主题切换（isDarkMode）也通过单例管理，保持一致性

**权衡**：
- 单例不易测试，但项目目前没有单元测试需求
- 如果未来需要多用户支持，需要重构为用户级别的数据管理

---

## 3. 为什么禁止第三方库？

**决策**：禁止引入第三方库（CocoaPods/SPM），除非明确获得人工确认
**理由**：
- 项目功能简单，UIKit 原生能力足够
- 减少依赖管理复杂度，避免版本冲突
- 保持代码纯净，便于长期维护
- 新人上手成本低，无需学习第三方库

**例外**：
- 如果需要网络请求，可考虑 Alamofire
- 如果需要 JSON 解析，可考虑 Codable（已内置）
- 任何新库都需要人工确认

---

## 4. 为什么用 Delegate 而不是 Notification？

**决策**：QuickAdd → Dashboard 的通信用 Delegate，主题切换用 Notification
**理由**：
- Delegate：一对一通信，QuickAdd 只需通知 Dashboard 刷新
- Notification：一对多广播，主题切换需要通知所有 VC

**权衡**：
- Delegate 需要手动设置（在 TabBar 中），但更明确
- Notification 自动广播，但容易被滥用

---

## 5. 为什么硬编码颜色是违规？

**决策**：所有颜色必须使用 UIColor 语义色，禁止硬编码 RGB 值
**理由**：
- 语义色自动适配 Dark Mode，无需手动处理
- 减少 applyTheme 的复杂度
- 保持视觉一致性，便于全局主题调整

**现状**：
- HDTabBarController.m 中有硬编码颜色，需要修复
- 已在 design-system Skill 中提供了完整的语义色映射

---

## 6. 为什么禁止 performSelector？

**决策**：禁止使用 `performSelector`，改用直接调用或 `respondsToSelector`
**理由**：
- performSelector 绕过编译器类型检查，容易产生运行时错误
- 代码可读性差，难以追踪调用链
- 现代 ObjC 有更好的替代方案

**替代方案**：
```objc
// ❌ 禁止
[vc performSelector:@selector(applyTheme)];

// ✅ 推荐
if ([vc respondsToSelector:@selector(applyTheme)]) {
    [(id)vc applyTheme];
}
```

---

## 7. 为什么 Delegate 必须是 weak？

**决策**：所有 delegate 属性必须声明为 `weak`
**理由**：
- 防止循环引用（QuickAdd 持有 Dashboard，Dashboard 也持有 QuickAdd）
- weak 引用在对象释放时自动置为 nil，避免野指针

**现状**：
- HDQuickAddViewController 中的 delegate 已正确声明为 weak
- 这是 ObjC 的标准做法

---

## 8. 为什么数据写入必须通过 Model 方法？

**决策**：禁止直接赋值 Model 属性，必须通过 `addWater:`、`addSteps:`、`addMood:` 方法
**理由**：
- 方法内部可以做数据验证、日志记录、通知更新
- 直接赋值无法触发 UI 刷新
- 便于未来扩展（如数据持久化、云同步）

**示例**：
```objc
// ❌ 禁止
[HDHealthDataModel shared].waterML += 250;

// ✅ 推荐
[[HDHealthDataModel shared] addWater:250];
```

---

## 9. 为什么要分离 Rule 和 Skill？

**决策**：Rule 只写「禁止」「必须」，Skill 写「怎么做」「为什么」
**理由**：
- Rule 是约束层，Agent 必须遵守
- Skill 是知识层，Agent 参考学习
- 职责分离，避免上下文污染
- Rule 精简，加载快；Skill 详细，学习全面

**改进历程**：
- 初版：Rule 和 Skill 内容重叠，冗余 40%
- 改进后：Rule 精简 31%，职责清晰

---

## 10. 为什么需要 AI Agent 能力体系？

**决策**：建立完整的 Rules/Skills/Agents/Hooks 体系
**理由**：
- 项目规模虽小，但需要长期维护
- AI Agent 需要明确的约束和知识库
- 新人上手快，代码质量有保障
- 便于自动化检查和质量门禁

**收益**：
- 代码风格一致
- Bug 率降低
- 维护成本低
- 可扩展性强
