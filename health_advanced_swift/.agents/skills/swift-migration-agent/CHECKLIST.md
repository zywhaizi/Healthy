# Swift Migration Checklist（每次迁移必填）

> 本清单专为 HealthDashboard 项目定制。
> 每次迁移一个页面，必须按顺序填写，全绿才可报告完成。

## 迁移对象

- 页面：`HD{PageName}ViewController`
- 关联入口文件：（填写，如 `HDTabBarController.m`）
- 是否涉及 Delegate：是 / 否（填写 Delegate 名称）
- 涉及主题：**必须实现 `applyTheme`**（所有 VC 强制要求）
- 是否涉及数据写入：是 / 否（填写写入方法，只能用 `addWater/addSteps/addMood`）

---

## Step 1｜引用盘点

- [ ] 已读取目标 OC `.h/.m`
- [ ] 已确认在 `HDTabBarController.m` 中的创建方式（是否 `#import` / 直接 `new`）
- [ ] 已确认 `quickAdd.delegate = dashboard` 设置位置（如适用）
- [ ] 已确认 Delegate Protocol 声明文件
- [ ] 已确认 `applyTheme` 在父层（TabBar）的调用链路

---

## Step 2｜Swift 最小骨架

- [ ] 新建 Swift VC（`HD` 前缀，文件名与类名一致）
- [ ] 实现 `viewDidLoad`
- [ ] 实现 `viewWillAppear(_ animated:)`
  - Dashboard / Exercise 页面：必须在 `viewWillAppear` 中调用 `refreshData()` + `applyTheme()`
- [ ] 实现 `applyTheme()`（颜色全部用语义色，无硬编码）
- [ ] 如为 QuickAdd：`delegate` 属性声明为 `weak`

---

## Step 3｜Target Membership 检查

> ⚠️ **Agent 无法修改 `project.pbxproj`**，Swift 文件创建后必须由用户手动操作：
> 在 Xcode 中选中新建的 `.swift` 文件 → File Inspector（右侧面板）→ Target Membership → 勾选 `HealthDashboard`（非 Test target）
> **未加入 Target 的典型症状**：`NSClassFromString` 返回 nil、编译时找不到类

- [ ] ⚠️ 已提醒用户将 Swift 文件加入 `HealthDashboard` target
- [ ] Bridging Header 路径有效：`HealthDashboard/Controllers/HealthDashboard-Bridging-Header.h`
- [ ] Bridging Header 中已导入 `HDHealthDataModel.h`（以及其他必需 OC 头文件）
- [ ] 无重复类名与 OC 端冲突

---

## Step 4｜首次编译门禁

- [ ] 编译 **0 error**
- [ ] 若失败，已记录错误类型并修复，**未带错误进入下一步**

常见错误优先检查：
1. Bridging Header 路径错误或未生效
2. Swift 文件未加入 target
3. OC 仍 `#import` 已删除/不存在的头文件

---

## Step 5｜入口引用替换（HDTabBarController.m）

- [ ] 已删除对应 `#import "HD{PageName}ViewController.h"`
- [ ] 创建方式已改为：
  ```objc
  Class cls = NSClassFromString(@"HealthDashboard.HD{PageName}ViewController");
  UIViewController *vc = [[cls alloc] init];
  ```
- [ ] 模块名确认为 `HealthDashboard`（与 Xcode target 名一致）
- [ ] 类型声明已从具体类改为 `UIViewController *`
- [ ] Tab 顺序确认：**Tab 0 = Dashboard / Tab 1 = QuickAdd / Tab 2 = Profile**（不得调整）
- [ ] 如为 QuickAdd：`quickAdd.delegate = dashboard` 设置代码已保留

---

## Step 6｜二次编译门禁

- [ ] 替换引用后重新编译，**0 error**
- [ ] 若出现 `NSClassFromString` 返回 nil，已检查模块名/类名/target

---

## Step 7｜功能冒烟验证

### 通用项
- [ ] 页面可从 Tab 正常进入
- [ ] `viewDidLoad` 正常执行（页面 UI 渲染正确）
- [ ] `viewWillAppear` 正常执行（数据刷新正确）
- [ ] 深色/浅色主题切换后 UI 刷新正确（`applyTheme` 有效）

### Dashboard 专项
- [ ] 步数进度环数据正确（`stepsProgress` 来自 Model 只读属性）
- [ ] 喝水进度数据正确（`waterProgress` 来自 Model 只读属性）
- [ ] QuickAdd 录入后 Dashboard 数据刷新（Delegate 回调有效）

### QuickAdd 专项
- [ ] 喝水输入校验：100ml ≤ 输入值 ≤ 2000ml
- [ ] 步数输入校验：1 ≤ 输入值 ≤ 50000
- [ ] 心情输入校验：整数 1~5
- [ ] 录入完成后调用 `[self.delegate quickAddDidUpdateData]`
- [ ] delegate 为 `weak` 引用，无循环引用

### Profile 专项
- [ ] 目标值从 `stepsGoal` / `waterGoalML` 读取（不硬编码）
- [ ] 没有直接修改 Model 数据（`moodRecords`、`sleepHours` 只展示不修改）

### Exercise 专项
- [ ] 计时器不阻塞主线程
- [ ] 运动完成后调用 Delegate 通知 Dashboard 刷新
- [ ] 运动数据写入通过 Model 方法（`addExercise:duration:calories:`）

---

## Step 8｜OC 文件清理（六项验收通过后直接执行，无需用户确认）

- [ ] 用 `grep` 确认其他 OC 文件是否仍在 `#import` 目标头文件，若有则先删除对应 `#import` 行
- [ ] 直接删除 `.h/.m` 文件（无需询问用户）
- [ ] 删除后运行 `swiftc -typecheck` 确认 **0 error**
- [ ] 没有其他 OC 文件仍在 `#import` 已删除的头文件

---

## 六项验收（必须全绿）

- [ ] **A. 编译通过**：0 error
- [ ] **B. 实例化通过**：`NSClassFromString` 创建对象非 nil，页面可展示
- [ ] **C. 生命周期通过**：`viewDidLoad` / `viewWillAppear` 正常执行
- [ ] **D. 主题通过**：`applyTheme` 生效，深浅色切换无遗漏元素
- [ ] **E. 数据通过**：写入仅用 `addWater:` / `addSteps:` / `addMood:` 方法；读取用 readonly 属性
- [ ] **F. 回调通过**：QuickAdd / Exercise → Dashboard 的 Delegate 链路有效

---

## 汇报模板（迁移完成后必须输出）

```md
[迁移对象]
- 页面：HDxxxViewController
- 入口引用文件：HDTabBarController.m

[执行结果]
- Step1 读取引用：✅/❌
- Step2 Swift骨架：✅/❌
- Step3 target检查：✅/❌
- Step4 首次编译：✅/❌
- Step5 入口替换：✅/❌
- Step6 二次编译：✅/❌
- Step7 功能冒烟：✅/❌
- Step8 OC清理：✅/❌（如未执行说明原因）

[六项验收]
- A 编译：✅/❌
- B 实例化：✅/❌
- C 生命周期：✅/❌
- D 主题：✅/❌
- E 数据链路：✅/❌
- F 委托回调：✅/❌

[遗留风险]
- 无 / 列出风险项
```
