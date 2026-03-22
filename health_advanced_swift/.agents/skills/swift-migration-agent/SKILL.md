---
name: swift-migration-agent
description: OC 到 Swift 迁移统一执行版。以编译通过和功能可用为第一优先级。
---

# swift-migration-agent（统一执行版）

> 优先级：**编译正确 > 功能正确 > 结构优化**。
> 门禁规则见：`.cursor/rules/swift-migration-gate.mdc`
> 验收清单见：`./CHECKLIST.md`

---

## 标准 8 步迁移流程（任一步失败先修复再继续）

### Step 1. 盘点引用
- 读取目标 OC `.h/.m` 及所有入口引用（`HDTabBarController.m`）
- 识别：Delegate 设置位置、`applyTheme` 调用链路、Model 写入点
- 输出：入口文件、Delegate 名、是否有 `quickAdd.delegate = dashboard`

### Step 2. 创建 Swift 最小骨架
- 新建 `HD{PageName}ViewController.swift`，放于 `Controllers/` 目录
- 必须实现：`viewDidLoad`、`viewWillAppear`、`applyTheme`
- Dashboard / Exercise：`viewWillAppear` 中调用 `refreshData()` + `applyTheme()`
- QuickAdd：`delegate` 属性声明为 `weak`

### Step 3. 校验 target membership
- Swift 文件加入 `HealthDashboard` target（非 Test target）
- Bridging Header 路径：`HealthDashboard/Controllers/HealthDashboard-Bridging-Header.h`
- Bridging Header 中已导入 `HDHealthDataModel.h`

### Step 4. 首次编译门禁
- 目标：0 error，失败先修复不得进入下一步
- 高频原因：Bridging Header 路径错、Swift 文件未加入 target、OC 仍 `#import` 不存在的头文件

### Step 5. 替换入口引用（`HDTabBarController.m`）
- 删除：`#import "HD{PageName}ViewController.h"`
- 替换创建方式：
  ```objc
  Class cls = NSClassFromString(@"HealthDashboard.HD{PageName}ViewController");
  UIViewController *vc = [[cls alloc] init];
  ```
- 属性类型改为 `UIViewController *`
- Tab 顺序锁定：**Tab 0 = Dashboard / Tab 1 = QuickAdd / Tab 2 = Profile**
- QuickAdd：`quickAdd.delegate = dashboard` 设置代码必须保留

### Step 6. 二次编译门禁
- 替换引用后再次确保 0 error
- `NSClassFromString` 返回 nil 时检查：模块名 `HealthDashboard`、类名、target

### Step 7. 功能冒烟验证
- 页面可从 Tab 正常进入
- 主题深浅切换后 UI 刷新正确（`applyTheme` 有效）
- Delegate 回调可达（QuickAdd/Exercise → Dashboard 数据刷新）
- 各页面专项详见 `./CHECKLIST.md` Step 7

### Step 8. 清理旧 OC（需用户确认）
- 删除 `.h/.m` 前必须询问用户
- 删除后再次确认编译 0 error
- 确认无其他 OC 文件仍在 `#import` 已删除头文件

---

## 高频错误速查

| 错误现象 | 原因 | 修复 |
|---|---|---|
| `Cannot find 'HDHealthDataModel' in scope` | Bridging Header 未生效 | 检查路径，`Cmd+Shift+K` 重编 |
| `Cannot find type 'XXX' in scope` | Swift 文件未加入 target | File Inspector → Target Membership 勾选 |
| OC 端编译报找不到头文件 | 仍 `#import` 已删除的 `.h` | 删除对应 `#import` 行 |
| `NSClassFromString` 返回 nil | 模块名/类名错误 | 格式：`HealthDashboard.HDXxxViewController` |
| 索引失效/诡异编译错误 | Xcode 缓存问题 | `killall Xcode && rm -rf ~/Library/Developer/Xcode/DerivedData/*` |
| 跨目录 Swift 编译失败 | Swift 编译器跨目录限制 | 将 ViewModel 与 ViewController 放在同一目录 `Controllers/` |

---

## 迁移约束（项目硬规则）

- 类名必须 `HD` 前缀
- 所有 ViewController 必须实现 `applyTheme`
- 数据写入仅通过 `HDHealthDataModel` 方法：`addWater` / `addSteps` / `addMood`
- 禁止直接修改 Model 属性、禁止引入第三方库、禁止 `performSelector`

---

## 附录：本项目三个 Tab 入口替换示例

```objc
// Tab 0 - Dashboard（如已迁移）
Class dashClass = NSClassFromString(@"HealthDashboard.HDDashboardViewController");
UIViewController *dashboard = [[dashClass alloc] init];

// Tab 1 - QuickAdd（如已迁移）
Class quickAddClass = NSClassFromString(@"HealthDashboard.HDQuickAddViewController");
UIViewController *quickAdd = [[quickAddClass alloc] init];
// ⚠️ QuickAdd delegate 设置必须保留，Swift VC 需声明 @objc 属性让 OC 侧可访问

// Tab 2 - Profile（如已迁移）
Class profileClass = NSClassFromString(@"HealthDashboard.HDProfileViewController");
UIViewController *profile = [[profileClass alloc] init];
```

- 详细验收清单：`./CHECKLIST.md`
