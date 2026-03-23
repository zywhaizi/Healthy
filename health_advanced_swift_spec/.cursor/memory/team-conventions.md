---
name: team-conventions
description: HealthDashboard 项目的团队约定和工作流程
---

# 团队约定

## Code Review 标准

### 必检项

- [ ] **HD 前缀**：所有新增类是否使用了 `HD` 前缀
- [ ] **applyTheme**：所有 ViewController 是否实现了 `applyTheme` 方法
- [ ] **数据写入**：数据修改是否通过 Model 方法（`addWater:`、`addSteps:`、`addMood:`）
- [ ] **颜色值**：是否有硬编码颜色（RGB 值），应使用语义色
**NS_ASSUME_NONNULL**：头文件是否包含 `NS_ASSUME_NONNULL_BEGIN/END`

### 可选项

- [ ] 代码注释是否清晰
- [ ] 方法长度是否超过 50 行（考虑拆分）
- [ ] 是否有重复代码（DRY 原则）
- [ ] 是否有内存泄漏风险

---

## 提交信息格式

### 格式规范

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Type 类型

- `feat`: 新功能
- `fix`: Bug 修复
- `refactor`: 代码重构（不改功能）
- `style`: 代码风格调整（格式、缩进等）
- `docs`: 文档更新
- `test`: 测试相关
- `chore`: 构建、依赖等维护工作

### Scope 范围

- `dashboard`: 仪表盘页面
- `profile`: 个人中心页面
- `quickadd`: 快速录入页面
- `tabbar`: TabBar 容器
- `model`: 数据模型
- `view`: 自定义 View
- `rules`: Rules 和约束
- `skills`: Skills 和知识库

### 示例

```
feat(dashboard): 添加步数进度环动画

- 使用 CABasicAnimation 实现平滑过渡
- 进度变化时自动更新颜色
- 支持 Dark Mode 适配

Closes #123
```

```
fix(tabbar): 修复 Dark Mode 下颜色显示错误

- 将硬编码 RGB 颜色替换为语义色
- 使用 UIColor.systemBackgroundColor
- 测试 Light/Dark Mode 切换

Fixes #456
```

---

## 分支管理

### 分支命名

```
<type>/<scope>-<description>
```

### 示例

```
feat/dashboard-add-animation
fix/tabbar-dark-mode
refactor/model-simplify-logic
docs/update-readme
```

### 分支策略

- `main`: 主分支，只接受 PR
- `develop`: 开发分支（可选）
- `feature/*`: 功能分支
- `fix/*`: Bug 修复分支
- `refactor/*`: 重构分支

---

## 发布流程

### 版本号规范

遵循 Semantic Versioning：`MAJOR.MINOR.PATCH`

- `MAJOR`: 不兼容的 API 变更
- `MINOR`: 新增功能（向后兼容）
- `PATCH`: Bug 修复

### 发布检查清单

- [ ] 所有 PR 已合并
- [ ] 所有测试通过
- [ ] 质量门禁检查通过
- [ ] 文档已更新
- [ ] CHANGELOG 已更新
- [ ] 版本号已更新

---

## 文档维护

### 文档位置

- `docs/architecture.md`: 项目架构图
- `docs/ai-agent-system.md`: AI Agent 体系说明
- `AGENTS.md`: Agent 能力体系入口
- `.cursor/rules/`: 编码规范
- `.agents/skills/`: 知识库

### 文档更新时机

- 架构变更时更新 `architecture.md`
- 新增 Skill 时更新 `AGENTS.md` 的能力清单
- 新增规范时更新对应 Rule 文件
- 发现新问题时更新 `known-issues.md`

---

## 工具和自动化

### 质量检查

```bash
# 运行质量门禁检查
.cursor/hooks/quality-gate.sh

# 检查危险命令
.cursor/hooks/guard.sh

# 自动格式化
.cursor/hooks/format.sh
```

### 推荐的 IDE 设置

- 启用 Clang Format（自动格式化）
- 启用 Linter（代码检查）
- 启用 Cursor Rules（自动应用规范）

---

## 沟通约定

### 问题报告

使用 GitHub Issues，格式：

```markdown
## 问题描述
简要描述问题

## 复现步骤
1. ...
2. ...
3. ...

## 预期行为
应该发生什么

## 实际行为
实际发生了什么

## 环境信息
- iOS 版本：
- 设备：
- 其他：
```

### 讨论和决策

- 架构决策：在 `project-decisions.md` 中记录
- 技术方案：在 PR 中讨论
- 团队约定：在本文件中更新

---

## 新人入职清单

- [ ] 阅读 `AGENTS.md`（全局入口）
- [ ] 阅读 `project-decisions.md`（项目背景）
- [ ] 阅读 `known-issues.md`（已知问题）
- [ ] 阅读 `.cursor/rules/global-always.mdc`（编码规范）
- [ ] 阅读对应页面的 Skill（如要修改仪表盘，读 `page-dashboard` Skill）
- [ ] 运行一次质量检查，确保环境正确
- [ ] 提交第一个 PR，接受 Code Review

---

## 常见问题

### Q: 如何快速了解项目？
A: 按顺序阅读：
1. `AGENTS.md`（5 分钟）
2. `project-decisions.md`（10 分钟）
3. 对应页面的 Skill（15 分钟）

### Q: 如何修改某个页面？
A: 
1. 打开对应的 ViewController 文件
2. Rules 和 Skill 会自动加载
3. 遵守 Rules，参考 Skill 中的示例

### Q: 如何添加新功能？
A:
1. 在 `project-decisions.md` 中记录决策
2. 创建对应的 Rule 和 Skill
3. 在 `AGENTS.md` 中更新能力清单
4. 提交 PR，接受 Code Review

### Q: 遇到 Bug 怎么办？
A:
1. 在 `known-issues.md` 中记录问题
2. 分析根本原因
3. 提交修复 PR
4. 更新 `known-issues.md` 的状态
