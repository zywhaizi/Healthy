# HealthDashboard · 模块级 Agent 入口

> 继承根目录 `AGENTS.md`，补充 HealthDashboard 模块特有约定。
> 打开本目录下任意文件时自动合并加载。

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

## 更多详情

→ 控制器层约定：`Controllers/AGENTS.md`
→ 全局规范：根目录 `AGENTS.md`
