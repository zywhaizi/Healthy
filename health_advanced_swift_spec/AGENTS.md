# HealthDashboard · 全局 Agent 知识体系入口

> 本文件是整个项目 AI Agent 能力体系的**总入口**。
> Agent 启动时自动加载，从这里导航到所有层级的规范、知识库和工具。

---

## 项目概览

- **项目名**: HealthDashboard
- **技术栈**: iOS · Swift · UIKit · MVVM · Combine
- **核心功能**: 健康数据仪表盘（步数、喝水、睡眠、心情）
- **作者**: zhang, haizi
- **创建时间**: 2026/3/19

---

## 体系地图（全局 → 页面级）

```
全局层（Always Apply）
├── .cursor/rules/global-always.mdc
├── .cursor/rules/swift-always.mdc
├── .cursor/rules/mvvm-architecture.mdc
├── .cursor/rules/combine-binding.mdc
├── .agents/skills/health-data-model/SKILL.md
├── .agents/skills/swift-language/SKILL.md
├── .agents/skills/mvvm-pattern/SKILL.md
├── .agents/skills/combine-binding/SKILL.md
└── .agents/skills/design-system/SKILL.md

质量门禁（修改 Swift 文件时触发）
└── .cursor/rules/swift-migration-gate.mdc

页面层（按文件/目录自动合并）
├── .cursor/rules/page-{dashboard|profile|quickadd|tabbar|exercise}.mdc
├── HealthDashboard/.agents/skills/page-{dashboard|profile|quickadd|tabbar|exercise}/SKILL.md
└── HealthDashboard/.agents/skills/views-components/SKILL.md

导航索引层
├── AGENTS.md (全局入口)
├── HealthDashboard/AGENTS.md (模块入口)
└── HealthDashboard/Controllers/AGENTS.md (控制器入口)

专职执行层（手动触发）
├── .cursor/agents/debugger.md        ← @debugger
├── .cursor/agents/refactor-advisor.md ← @refactor-advisor
└── .cursor/agents/verifier.md        ← @verifier

安全护栏层（自动触发）
├── .cursor/hooks/guard.sh
├── .cursor/hooks/block-sensitive.sh
└── .cursor/hooks/quality-gate.sh

长期记忆层
├── .cursor/memory/sop.md
├── .cursor/memory/project-decisions.md
├── .cursor/memory/known-issues.md
├── .cursor/memory/team-conventions.md
├── .cursor/memory/execution-environment.md
└── .cursor/memory/feedback.md
```

---

## 完整能力清单（统一管理视图）

### 🔒 行为约束层 · Rules

| 文件 | 职责 |
|---|---|
| `global-always.mdc` | HD 前缀、禁止事项、Guardrails、Quality Gate |
| `swift-always.mdc` | Swift 规范、MVVM 约束、Quality Gate |
| `mvvm-architecture.mdc` | MVVM 架构规范、各层职责 |
| `combine-binding.mdc` | Combine 数据绑定规范 |
| `swift-migration-gate.mdc` | Swift 编译质量门禁（六项验收） |
| `page-dashboard.mdc` | 仪表盘页面约束 |
| `page-profile.mdc` | 个人中心页面约束 |
| `page-quickadd.mdc` | 快速录入页面约束 |
| `page-tabbar.mdc` | TabBar 页面约束 |
| `page-exercise.mdc` | 运动模块页面约束 |

### 🗂 导航索引层 · AGENTS.md

| 文件 | 职责 |
|---|---|
| `AGENTS.md` (根目录) | 全局入口、体系地图、能力清单 |
| `HealthDashboard/AGENTS.md` | 模块级入口、数据流、页面导航 |
| `HealthDashboard/Controllers/AGENTS.md` | 控制器层入口、VC 通信规则 |

### 🧠 知识库层 · Skills（全局）

| Skill | 职责 |
|---|---|
| `health-data-model/SKILL.md` | HDHealthDataModel 接口、数据关系图 |
| `swift-language/SKILL.md` | Swift 语言特性和最佳实践 |
| `mvvm-pattern/SKILL.md` | MVVM 设计模式的完整实现 |
| `combine-binding/SKILL.md` | Combine 框架的数据绑定 |
| `design-system/SKILL.md` | 颜色、字体、间距、Dark Mode 规范 |

### 📱 知识库层 · Skills（页面级）

| Skill | 文件 | 职责 |
|---|---|---|
| 仪表盘 | `page-dashboard/SKILL.md` | 数据绑定、UI 组件、刷新时机 |
| 个人中心 | `page-profile/SKILL.md` | 主题切换、目标设置、数据统计 |
| 快速录入 | `page-quickadd/SKILL.md` | Delegate 通信、表单校验 |
| TabBar | `page-tabbar/SKILL.md` | Tab 结构、协调逻辑、主题通知 |
| 运动模块 | `page-exercise/SKILL.md` | 页面职责、Delegate、计时器、卡路里 |
| 自定义 View | `views-components/SKILL.md` | 5个组件接口说明 |

### 🤖 专职执行层 · Agents

| Agent | 触发方式 | 职责 |
|---|---|---|
| `@verifier` | 说「帮我验收」/「检查完成度」 | 只读验收，输出结构化报告 |
| `@refactor-advisor` | 说「重构」/「架构优化」 | 提案优先，HITL 确认后执行 |
| `@debugger` | 说「报错」/「crash」/「不工作」 | 系统性排障，最小化修复 |

### 🛡 安全护栏层 · Hooks

| 脚本 | 触发时机 | 职责 |
|---|---|---|
| `guard.sh` | Shell 命令执行前 | 拦截危险命令（rm -rf 等） |
| `block-sensitive.sh` | 文件读取前 | 屏蔽 .env / 证书文件 |
| `quality-gate.sh` | Agent 完成时 / pre-commit | 质量检查 |

### 🗃 长期记忆层 · Memory

| 文件 | 类型 | 职责 |
|---|---|---|
| `sop.md` | 长期 | 标准操作流程（修改页面、添加功能、修复 Bug 等） |
| `project-decisions.md` | 长期 | 关键架构决策与理由 |
| `known-issues.md` | 临时 | 已知 Bug、根因、修复状态 |
| `team-conventions.md` | 长期 | Code Review 标准、提交信息格式、分支管理 |
| `execution-environment.md` | 长期 | 执行环境约束、工具调用规范 |
| `feedback.md` | 临时 | Agent 错误记录、改进建议、学习日志 |

---

## 核心约定（Agent 必读）

1. **前缀**: 所有类名使用 `HD` 前缀
2. **数据单例**: 全局数据通过 `HDHealthDataModel.shared` 读写
3. **主题**: UI 主题切换通过 `applyTheme` 方法，订阅 `$isDarkMode`
4. **Delegate**: 跨 VC 通信使用 Delegate 模式（`weak` 声明）
5. **禁止事项**: 不得引入第三方库、不得修改 `Info.plist` 关键字段

---

## 快速触发指南

```
场景                          触发方式
─────────────────────────────────────────────
改某个 VC         →  打开那个文件，Rules 自动生效
需要验收          →  @verifier 或说「帮我验收」
需要重构建议      →  @refactor-advisor
遇到 Bug          →  @debugger 或说「这里报错了」
查项目全貌        →  @AGENTS.md
```

---

## 扩展指南（新增页面时）

```
1. 新建 .cursor/rules/page-{name}.mdc
2. 新建 HealthDashboard/.agents/skills/page-{name}/SKILL.md
3. 在 HDTabBarController 注册新 Tab（需人工确认）
4. 在本文件能力清单中补充对应行
```
