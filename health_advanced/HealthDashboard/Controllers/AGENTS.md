# Controllers · 控制器层 Agent 入口

> 继承 `HealthDashboard/AGENTS.md` + 根目录 `AGENTS.md`。
> 打开任意 VC 文件时自动合并加载，指向对应页面 Skill。

## VC 间通信规则

- **QuickAdd → Dashboard**：通过 `HDQuickAddDelegate` 协议
- **主题切换**：由 `HDTabBarController` 统一协调所有子VC
- **禁止**：VC 之间直接持有引用（除 delegate weak 引用外）

## 当前任务提示

修改某个 VC 时，请先加载对应的 Skill 获取详细业务规范：
- 修改 Dashboard → 输入 `/page-dashboard`
- 修改 Profile → 输入 `/page-profile`
- 修改 QuickAdd → 输入 `/page-quickadd`
- 修改 TabBar → 输入 `/page-tabbar`
