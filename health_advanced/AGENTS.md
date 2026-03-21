# HealthDashboard · 全局 Agent 知识体系入口

> 本文件是整个项目 AI Agent 能力体系的**总入口**。
> Agent 启动时自动加载，从这里导航到所有层级的规范、知识库和工具。

---

## 项目概览

- **项目名**: HealthDashboard
- **技术栈**: iOS · Objective-C · UIKit · MVC
- **核心功能**: 健康数据仪表盘（步数、喝水、睡眠、心情）
- **作者**: zhang, haizi
- **创建时间**: 2026/3/19

---

## 体系地图（全局 → 页面级）

```
全局层（Always Apply）
├── .cursor/rules/global-always.mdc        # ObjC 规范、HD 前缀、禁止事项
├── .cursor/hooks.json                     # Guardrails（系统级强制拦截）
├── .agents/skills/health-data-model/      # HDHealthDataModel 数据模型知识库
├── .agents/skills/ios-objc-patterns/      # Singleton / Delegate / Theme 模式
└── .agents/skills/design-system/          # 颜色 / 字体 / Dark Mode 规范

页面层（按文件/目录自动合并）
├── HealthDashboard/AGENTS.md              # 模块级入口
├── HealthDashboard/Controllers/AGENTS.md  # 控制器层入口
├── .cursor/rules/page-dashboard.mdc       # 仪表盘页面约束
├── .cursor/rules/page-profile.mdc         # 个人中心页面约束
├── .cursor/rules/page-quickadd.mdc        # 快速录入页面约束
├── .cursor/rules/page-tabbar.mdc          # TabBar 页面约束
├── HealthDashboard/.agents/skills/page-dashboard/   # 仪表盘知识库
├── HealthDashboard/.agents/skills/page-profile/     # 个人中心知识库
├── HealthDashboard/.agents/skills/page-quickadd/    # 快速录入知识库
├── HealthDashboard/.agents/skills/page-tabbar/      # TabBar 知识库
└── HealthDashboard/.agents/skills/views-components/ # 自定义 View 组件知识库

专职执行层（任务委托）
├── .cursor/agents/verifier.md             # 验收完成度
├── .cursor/agents/refactor-advisor.md     # 重构决策
└── .cursor/agents/debugger.md             # 排障专家
```

---

## 完整能力清单（统一管理视图）

### 🔒 行为约束层 · Rules

| 文件 | 触发方式 | 职责 |
|---|---|---|
| `.cursor/rules/global-always.mdc` | 每次对话自动注入 | ObjC规范、HD前缀、禁止事项、Guardrails、Quality Gate |
| `.cursor/rules/page-dashboard.mdc` | 打开 HDDashboard* 文件 | 仪表盘页面专属约束 |
| `.cursor/rules/page-profile.mdc` | 打开 HDProfile* 文件 | 个人中心专属约束 |
| `.cursor/rules/page-quickadd.mdc` | 打开 HDQuickAdd* 文件 | 快速录入专属约束 |
| `.cursor/rules/page-tabbar.mdc` | 打开 HDTabBar* 文件 | TabBar 专属约束 |

### 🗂 导航索引层 · AGENTS.md

| 文件 | 触发方式 | 职责 |
|---|---|---|
| `AGENTS.md`（本文件）| Agent 启动自动加载 | 全局入口、体系地图、能力清单 |
| `HealthDashboard/AGENTS.md` | 打开模块文件 | 数据流、页面导航 |
| `HealthDashboard/Controllers/AGENTS.md` | 打开任意 VC 文件 | VC 通信规则、Skill 导航 |

### 🧠 知识库层 · Skills（全局）

| Skill | 触发方式 | 职责 |
|---|---|---|
| `.agents/skills/health-data-model/` | 读写健康数据时 | HDHealthDataModel 接口、数据关系图 |
| `.agents/skills/ios-objc-patterns/` | 实现设计模式时 | Singleton/Delegate/Theme/Notification |
| `.agents/skills/design-system/` | 处理 UI 样式时 | 颜色、字体、间距、Dark Mode |

### 📱 知识库层 · Skills（页面级）

| Skill | 触发方式 | 职责 |
|---|---|---|
| `HealthDashboard/.agents/skills/page-dashboard/` | 修改仪表盘时 | 数据绑定、卡片布局、UI 规格 |
| `HealthDashboard/.agents/skills/page-profile/` | 修改个人中心时 | 主题切换、目标设置、统计展示 |
| `HealthDashboard/.agents/skills/page-quickadd/` | 修改录入页时 | Delegate SOP、校验规则 |
| `HealthDashboard/.agents/skills/page-tabbar/` | 修改 TabBar 时 | 角标、协调逻辑、Tab 结构 |
| `HealthDashboard/.agents/skills/views-components/` | 修改自定义 View 时 | 5个组件接口说明 |

### 🛡 安全护栏层 · Hooks

| 脚本 | 触发时机 | 职责 |
|---|---|---|
| `.cursor/hooks/guard.sh` | Shell 命令执行前 | 拦截危险命令（rm -rf 等）|
| `.cursor/hooks/block-sensitive.sh` | 文件读取前 | 屏蔽 .env/证书/secrets |
| `.cursor/hooks/format.sh` | .m/.h 文件编辑后 | 自动 clang-format |
| `.cursor/hooks/quality-gate.sh` | Agent 完成任务时 | NS_ASSUME_NONNULL 检查、performSelector 检测 |

### 🤖 专职执行层 · Subagents

| Agent | 触发方式 | 职责 |
|---|---|---|
| `.cursor/agents/verifier.md` | `@verifier` | 验收代码是否符合规范，输出结构化报告 |
| `.cursor/agents/refactor-advisor.md` | `@refactor-advisor` | 分析架构问题，提供重构方案（HITL 确认后执行）|
| `.cursor/agents/debugger.md` | `@debugger` | 系统性排查 Bug，最小化修复 |

---

## 核心约定（Agent 必读）

1. **前缀**: 所有类名使用 `HD` 前缀（HDDashboardViewController、HDHealthDataModel 等）
2. **数据单例**: 全局数据统一通过 `[HDHealthDataModel shared]` 读写，禁止在 VC 中直接持有数据
3. **主题**: UI 主题切换通过 `applyTheme` 方法，响应 `isDarkMode` 属性
4. **Delegate**: 跨 VC 通信使用 Delegate 模式（参考 `HDQuickAddDelegate`）
5. **禁止事项**: 不得引入第三方库（除非明确获得人工确认）；不得修改 `Info.plist` 关键字段

---

## 扩展指南（新增页面时）

```
1. 新建 .cursor/rules/page-{name}.mdc（参考 page-dashboard.mdc）
2. 新建 HealthDashboard/.agents/skills/page-{name}/SKILL.md
3. 在 HDTabBarController 注册新 Tab（需人工确认）
4. 在本文件能力清单中补充对应行
```
