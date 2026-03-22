# HealthDashboard · 模块级 Agent 入口

> 继承根目录 `AGENTS.md`，补充 HealthDashboard 模块特有约定。
> 打开本目录下任意文件时自动合并加载。

## 🚧 迁移任务优先链路（Compile-First）

涉及 OC → Swift 迁移时，**必须按此顺序执行**，不得跳步：

1. 先应用门禁规则：`.cursor/rules/swift-migration-gate.mdc`
2. 再按执行 Skill：`.agents/skills/swift-migration-agent/SKILL.md`
3. 全程填写检查单：`.agents/skills/swift-migration-agent/CHECKLIST.md`

**迁移默认目标**：0 编译错误 + 功能可用 + 主题与回调链路正常。

## 数据流向（必须遵守）

```
用户操作 → VC（接收输入）→ HDHealthDataModel.shared（写入）
→ Delegate回调 → VC读取Model → 驱动View更新
```

View 层禁止直接访问 `[HDHealthDataModel shared]`。

## 页面导航

| 页面 | Rule | Skill |
|---|---|---|
| 仪表盘 | `page-dashboard.mdc` | `/page-dashboard` |
| 个人中心 | `page-profile.mdc` | `/page-profile` |
| 快速录入 | `page-quickadd.mdc` | `/page-quickadd` |
| TabBar | `page-tabbar.mdc` | `/page-tabbar` |
| 运动模块 | `page-exercise.mdc` | `/page-exercise` |

## 更多详情

→ 控制器层约定：`Controllers/AGENTS.md`
→ 全局规范：根目录 `AGENTS.md`
