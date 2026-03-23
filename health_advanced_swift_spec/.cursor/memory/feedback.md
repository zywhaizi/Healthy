---
name: feedback
type: temporary
description: HealthDashboard 项目的反馈学习日志，记录 Agent 的错误和改进建议
last-updated: 2026/3/21
review-date: 2026/4/21
---

# 反馈学习日志

> 本文件记录 AI Agent 在项目中犯过的错误、正确做法和改进建议。
> 定期审查（每月一次），删除已解决的问题。

---

## 2026/3/21 - 初始化

### 问题 1：硬编码颜色在 Dark Mode 下显示错误

**发现时间**：2026/3/21
**问题描述**：HDTabBarController.m 中硬编码了 RGB 颜色值，Dark Mode 下显示错误
**Agent 的错误**：没有参考 design-system Skill 中的颜色规范
**正确做法**：使用 UIColor 语义色（如 UIColor.systemBackgroundColor）
**改进建议**：
- 在 page-tabbar.mdc 中强调颜色规范
- 在 design-system Skill 中添加「常见错误」部分
- 在 quality-gate.sh 中添加硬编码颜色检查

**状态**：🔴 未修复
**优先级**：高

---

### 问题 2：使用被禁止的 performSelector

**发现时间**：2026/3/21
**问题描述**：HDTabBarController.m 中使用了 performSelector 绕过类型检查
**Agent 的错误**：没有检查 global-always.mdc 中的禁止事项
**正确做法**：使用 respondsToSelector + 直接调用
**改进建议**：
- 在 verifier.md 中添加 performSelector 检查
- 在 quality-gate.sh 中添加 performSelector 检测
- 在 ios-objc-patterns Skill 中强调这个禁止项

**状态**：🔴 未修复
**优先级**：高

---

### 问题 3：QuickAdd Tab 缺失

**发现时间**：2026/3/21
**问题描述**：HDTabBarController 只有 2 个 Tab，缺少 QuickAdd Tab
**Agent 的错误**：没有参考 page-tabbar Rule 中的 Tab 结构要求
**正确做法**：按照 Tab 结构添加 3 个 Tab（Dashboard、QuickAdd、Profile）
**改进建议**：
- 在 page-tabbar.mdc 中明确 Tab 结构是必须的
- 在 quality-gate.sh 中添加 Tab 数量检查
- 在 known-issues.md 中记录这个问题

**状态**：🔴 未修复
**优先级**：高

---

### 问题 4：Delegate 设置缺失

**发现时间**：2026/3/21
**问题描述**：HDTabBarController 没有设置 QuickAdd 的 delegate
**Agent 的错误**：没有参考 page-tabbar Rule 中的 Delegate 设置要求
**正确做法**：在 viewDidLoad 中设置 `quickAdd.delegate = dashboard`
**改进建议**：
- 在 page-tabbar.mdc 中明确 Delegate 设置是必须的
- 在 page-quickadd Skill 中添加 Delegate 设置的示例
- 在 quality-gate.sh 中添加 Delegate 检查

**状态**：🔴 未修复
**优先级**：高

---

### 问题 5：Rule 和 Skill 职责重叠

**发现时间**：2026/3/21
**问题描述**：Rule 中包含了业务逻辑和代码示例，与 Skill 内容重叠
**Agent 的错误**：没有理解 Rule 和 Skill 的职责分离
**正确做法**：
- Rule 只写「禁止」「必须」「质量门禁」
- Skill 写「怎么做」「为什么」「示例」「问题」
**改进建议**：
- 精简所有 page Rules（删除业务逻辑和代码示例）
- 在 AGENTS.md 中明确说明 Rule 和 Skill 的职责
- 在 team-conventions.md 中添加「Rule vs Skill」的对比

**状态**：✅ 已修复（2026/3/21）
**改进效果**：Rule 文件精简 31%，职责清晰

---

### 问题 6：缺少 Memory 文件

**发现时间**：2026/3/21
**问题描述**：项目没有长期记忆和临时记忆机制
**Agent 的错误**：没有建立跨对话的知识积累
**正确做法**：
- 创建 project-decisions.md（长期记忆）
- 创建 known-issues.md（临时记忆）
- 创建 team-conventions.md（长期记忆）
**改进建议**：
- 定期审查 known-issues.md，删除已修复的问题
- 在 project-decisions.md 中记录所有架构决策
- 在 team-conventions.md 中记录团队约定

**状态**：✅ 已修复（2026/3/21）
**改进效果**：建立了完整的记忆体系

---

## 改进建议总结

### 短期改进（本周）

| 优先级 | 改进项 | 工作量 | 收益 |
|---|---|---|---|
| 🔴 高 | 修复硬编码颜色 | 小 | 高 |
| 🔴 高 | 修复 performSelector | 小 | 高 |
| 🔴 高 | 添加 QuickAdd Tab | 中 | 高 |
| 🔴 高 | 设置 Delegate | 小 | 高 |

### 中期改进（下周）

| 优先级 | 改进项 | 工作量 | 收益 |
|---|---|---|---|
| 🟡 中 | 全面应用语义色 | 大 | 中 |
| 🟡 中 | 检查 applyTheme 完整性 | 中 | 中 |
| 🟡 中 | 增强 quality-gate.sh | 中 | 中 |

### 长期改进（持续）

| 优先级 | 改进项 | 工作量 | 收益 |
|---|---|---|---|
| 🟢 低 | 积累更多反馈 | 持续 | 高 |
| 🟢 低 | 优化 Rule 和 Skill | 持续 | 中 |
| 🟢 低 | 完善 SOP 文档 | 持续 | 中 |

---

## 反馈模板

当发现新的问题时，使用以下模板记录：

```markdown
### 问题 N：[简短标题]

**发现时间**：YYYY/MM/DD
**问题描述**：[详细描述问题]
**Agent 的错误**：[Agent 为什么犯了这个错误]
**正确做法**：[应该怎么做]
**改进建议**：
- [建议 1]
- [建议 2]
- [建议 3]

**状态**：🔴 未修复 / 🟡 部分修复 / ✅ 已修复
**优先级**：高 / 中 / 低
**相关文件**：[涉及的文件]
```

---

## 审查清单

每月审查一次（下次审查日期：2026/4/21）：

- [ ] 检查已修复的问题，删除过期记录
- [ ] 检查未修复的问题，更新优先级
- [ ] 检查改进建议是否已实施
- [ ] 添加新发现的问题
- [ ] 更新 last-updated 和 review-date

---

## 学习成果

通过反馈学习，Agent 应该逐步改进：

1. **第一阶段**（初期）：频繁犯错，需要大量反馈
2. **第二阶段**（适应期）：错误减少，开始理解规范
3. **第三阶段**（成熟期）：主动遵守规范，很少犯错
4. **第四阶段**（优化期）：能够优化规范，提出改进建议

**目标**：让 Agent 在 2-3 周内达到第三阶段。
