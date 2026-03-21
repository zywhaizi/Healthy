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
├── .cursor/rules/global-always.mdc
├── .agents/skills/health-data-model/SKILL.md
├── .agents/skills/ios-objc-patterns/SKILL.md
└── .agents/skills/design-system/SKILL.md

页面层（按文件/目录自动合并）
├── .cursor/rules/page-{dashboard|profile|quickadd|tabbar|exercise}.mdc
├── HealthDashboard/.agents/skills/page-{dashboard|profile|quickadd|tabbar|exercise}/SKILL.md
└── HealthDashboard/.agents/skills/views-components/SKILL.md

导航索引层
├── AGENTS.md (全局入口)
├── HealthDashboard/AGENTS.md (模块入口)
└── HealthDashboard/Controllers/AGENTS.md (控制器入口)
```

---

## 完整能力清单（统一管理视图）

### 🔒 行为约束层 · Rules

| 文件 | 职责 |
|---|---|
| `global-always.mdc` | ObjC 规范、HD 前缀、禁止事项、Quality Gate |
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
| `ios-objc-patterns/SKILL.md` | Singleton/Delegate/Theme/Notification 模式 |
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

---

## 核心约定（Agent 必读）

1. **前缀**: 所有类名使用 `HD` 前缀
2. **数据单例**: 全局数据通过 `[HDHealthDataModel shared]` 读写
3. **主题**: UI 主题切换通过 `applyTheme` 方法
4. **Delegate**: 跨 VC 通信使用 Delegate 模式
5. **禁止事项**: 不得引入第三方库、不得修改 `Info.plist` 关键字段

---

## 扩展指南（新增页面时）

```
1. 新建 .cursor/rules/page-{name}.mdc
2. 新建 HealthDashboard/.agents/skills/page-{name}/SKILL.md
3. 在 HDTabBarController 注册新 Tab
4. 在本文件能力清单中补充对应行
```
