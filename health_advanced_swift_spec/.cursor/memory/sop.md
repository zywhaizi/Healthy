---
name: sop
type: long-term
description: HealthDashboard 项目的标准操作流程（SOP）
last-updated: 2026/3/21
---

# 标准操作流程（SOP）

## 1. 修改某个页面的 SOP

**场景**：需要修改仪表盘、个人中心、快速录入或 TabBar 页面

**步骤**：

1. **打开对应文件**
   ```
   打开 HDDashboardViewController.swift（或其他 VC 文件）
   ```

2. **自动加载规范**
   ```
   Rules 自动注入：
   - global-always.mdc（全局规范）
   - page-dashboard.mdc（页面约束）
   - Controllers/AGENTS.md（控制器规范）
   ```

3. **参考 Skill 中的示例**
   ```
   打开对应的 Skill：
   - /page-dashboard（修改仪表盘）
   - /page-profile（修改个人中心）
   - /page-quickadd（修改快速录入）
   - /page-tabbar（修改 TabBar）
   
   查看「业务逻辑」和「代码示例」部分
   ```

4. **遵守 Rules 约束**
   ```
   检查清单：
   - [ ] 使用了 HD 前缀
   - [ ] 没有硬编码颜色值
   - [ ] 数据通过 Model 方法写入
   - [ ] 实现了 applyTheme 方法
   - [ ] Combine 订阅使用了 `[weak self]` 且存入 `cancellables`
   ```

5. **提交 PR 和 Code Review**
   ```
   git commit -m "feat(dashboard): 描述改动"
   git push origin feat/dashboard-xxx
   
   在 PR 中：
   - 描述改动内容
   - 说明为什么这样改
   - 附上测试截图（如有 UI 改动）
   ```

6. **接受 Code Review**
   ```
   Reviewer 检查清单：
   - [ ] HD 前缀
   - [ ] applyTheme 实现
   - [ ] 数据写入方式
   - [ ] 颜色值（无硬编码）
   - [ ] Combine 订阅使用 `[weak self]`
   - [ ] Delegate 声明为 `weak`
   ```

---

## 2. 添加新功能的 SOP

**场景**：需要添加一个新的页面或功能模块

**步骤**：

1. **记录架构决策**
   ```
   编辑 project-decisions.md
   
   添加：
   - 为什么需要这个功能
   - 为什么选择这个设计方案
   - 有哪些权衡
   ```

2. **创建 Rule 文件**
   ```
   新建 .cursor/rules/page-{name}.mdc
   
   参考 page-dashboard.mdc 的格式：
   - 禁止事项
   - 必须遵守
   - 质量门禁
   ```

3. **创建 Skill 文件**
   ```
   新建 HealthDashboard/.agents/skills/page-{name}/SKILL.md
   
   包含：
   - 页面职责
   - 业务逻辑
   - 代码示例
   - 常见问题
   ```

4. **更新 AGENTS.md**
   ```
   在根目录 AGENTS.md 的能力清单中添加新行：
   
   | `HealthDashboard/.agents/skills/page-{name}/` | 修改{页面名}时 | {职责描述} |
   ```

5. **实现功能**
   ```
   按照 Rule 和 Skill 的要求实现代码
   ```

6. **运行质量检查**
   ```
   .cursor/hooks/quality-gate.sh
   
   检查：
   - HD 前缀
   - 硬编码颜色
   - 数据写入方式
   - applyTheme 实现
   - Combine 订阅 `[weak self]`
   - Delegate 声明为 `weak`
   ```

7. **提交 PR**
   ```
   git commit -m "feat(page-{name}): 添加新页面"
   ```

---

## 3. 修复 Bug 的 SOP

**场景**：发现并修复一个 Bug

**步骤**：

1. **记录问题**
   ```
   编辑 known-issues.md
   
   添加：
   - 问题描述
   - 位置（文件和行号）
   - 症状
   - 根本原因
   - 解决方案
   - 状态：🔴 未修复
   ```

2. **分析根本原因**
   ```
   读代码，理解为什么会出现这个 Bug
   
   常见原因：
   - 硬编码颜色（Dark Mode 问题）
   - 使用 performSelector（类型检查问题）
   - 直接修改 Model（数据不同步）
   - 忘记调用 applyTheme（主题不生效）
   ```

3. **实现修复**
   ```
   按照 Rule 和 Skill 的要求修复代码
   
   修复时参考：
   - 对应页面的 Rule（约束）
   - 对应页面的 Skill（示例）
   - design-system Skill（颜色规范）
   ```

4. **验证修复有效**
   ```
   测试清单：
   - [ ] Bug 消失
   - [ ] 没有引入新 Bug
   - [ ] Light Mode 正常
   - [ ] Dark Mode 正常
   - [ ] 其他页面不受影响
   ```

5. **更新 known-issues.md**
   ```
   修改状态：🔴 未修复 → ✅ 已修复
   
   添加：
   - 修复方案（代码片段）
   - 修复时间
   - 相关 PR
   ```

6. **提交 PR**
   ```
   git commit -m "fix(dashboard): 修复 Dark Mode 颜色问题"
   ```

---

## 4. 主题切换的 SOP

**场景**：用户切换 Light/Dark Mode

**流程**：

```
用户点击主题切换按钮
    ↓
HDProfileViewController 修改 isDarkMode
    ↓
HDHealthDataModel.shared().isDarkMode = !isDarkMode
    ↓
$isDarkMode Combine 订阅触发
    ↓
各 VC 自身订阅响应，调用 applyTheme()
    ↓
每个 VC 的 applyTheme 更新所有 UI 颜色
    ↓
主题切换完成
```

**实现检查清单**：

- [ ] HDProfileViewController 中有主题切换按钮
- [ ] 点击时修改 `HDHealthDataModel.shared().isDarkMode`
- [ ] 各 VC 在 `viewDidLoad` 中订阅 `$isDarkMode`
- [ ] 所有 ViewController 实现了 `applyTheme`
- [ ] `applyTheme` 中使用语义色，不硬编码颜色

---

## 5. 数据录入的 SOP

**场景**：用户在 QuickAdd 页面录入健康数据

**流程**：

```
用户打开 QuickAdd 页面
    ↓
选择数据类型（喝水/步数/心情）
    ↓
输入数值
    ↓
点击「确认」按钮
    ↓
表单校验
  - 喝水：100ml ≤ 值 ≤ 2000ml
  - 步数：1 ≤ 值 ≤ 50000
  - 心情：1-5 整数
    ↓
校验通过
    ↓
调用 Model 方法写入
  - HDHealthDataModel.shared().addWater(ml)
  - HDHealthDataModel.shared().addSteps(steps)
  - HDHealthDataModel.shared().addMood(level)
    ↓
调用 Delegate 回调
  - delegate?.quickAddDidUpdateData()
    ↓
Dashboard 收到回调
    ↓
Dashboard 刷新数据显示
    ↓
dismiss QuickAdd 页面
    ↓
数据录入完成
```

**实现检查清单**：

- [ ] QuickAdd 有表单校验
- [ ] 校验范围正确
- [ ] 使用 Model 方法写入（不直接赋值）
- [ ] 调用了 Delegate 回调
- [ ] Delegate 声明为 weak
- [ ] Dashboard 实现了 HDQuickAddDelegate
- [ ] Dashboard 在回调中刷新数据

---

## 6. 新人入职的 SOP

**场景**：新人加入项目

**步骤**：

1. **第一天（1 小时）**
   ```
   阅读：
   - AGENTS.md（5 分钟）
   - project-decisions.md（10 分钟）
   - team-conventions.md（10 分钟）
   - known-issues.md（10 分钟）
   - global-always.mdc（10 分钟）
   ```

2. **第二天（2 小时）**
   ```
   阅读对应页面的 Skill：
   - 如果要修改仪表盘，读 page-dashboard Skill（30 分钟）
   - 如果要修改个人中心，读 page-profile Skill（30 分钟）
   - 如果要修改快速录入，读 page-quickadd Skill（30 分钟）
   - 如果要修改 TabBar，读 page-tabbar Skill（30 分钟）
   ```

3. **第三天（1 小时）**
   ```
   实践：
   - 运行一次质量检查（15 分钟）
   - 提交第一个 PR（45 分钟）
   - 接受 Code Review（30 分钟）
   ```

4. **第一周**
   ```
   - 修复 1-2 个简单 Bug
   - 参与 Code Review
   - 熟悉项目工作流程
   ```

---

## 7. Code Review 的 SOP

**场景**：审查他人的 PR

**步骤**：

1. **检查必检项**
   ```
   - [ ] HD 前缀
   - [ ] applyTheme 实现
   - [ ] 数据写入方式（通过 Model 方法）
   - [ ] 颜色值（无硬编码）
   - [ ] Combine 订阅使用 `[weak self]`
   - [ ] Delegate 声明为 `weak`
   ```

2. **检查可选项**
   ```
   - [ ] 代码注释清晰
   - [ ] 方法长度（< 50 行）
   - [ ] 无重复代码
   - [ ] 无内存泄漏风险
   ```

3. **提出反馈**
   ```
   - 必检项不通过：Request Changes
   - 可选项有问题：Comment（建议）
   - 全部通过：Approve
   ```

4. **作者修改**
   ```
   - 根据反馈修改代码
   - 再次提交
   - 等待 Re-review
   ```

5. **合并 PR**
   ```
   - 所有反馈已解决
   - 至少 1 个 Approve
   - 合并到 main 分支
   ```

---

## 8. 改动后的规范更新 SOP

**场景**：修改代码后，需要更新相关规范

**步骤**：

1. **识别改动的影响范围**
   ```
   修改了什么代码？
   ├─ 修改了某个页面 → 检查对应的 Rule/Skill
   ├─ 修改了 Model → 检查 health-data-model Skill
   ├─ 修改了 View → 检查 views-components Skill
   ├─ 修改了全局逻辑 → 检查 global-always.mdc
   └─ 修改了 ViewController → 检查 Controllers/AGENTS.md
   ```

2. **检查现有规范是否适用**
   ```
   现有规范是否覆盖了这个改动？
   ├─ 是 → 检查代码是否符合规范
   ├─ 否 → 需要更新规范
   └─ 部分 → 需要补充规范
   ```

3. **更新相关文件**
   ```
   如果需要更新规范：
   ├─ 更新对应的 Rule（.mdc 文件）
   │  └─ 只改「禁止」「必须」「质量门禁」
   ├─ 更新对应的 Skill（SKILL.md 文件）
   │  └─ 更新「业务逻辑」「代码示例」「常见问题」
   ├─ 更新 AGENTS.md（如需要）
   │  └─ 如果新增了 Skill 或改变了职责
   ├─ 在 feedback.md 中记录改进
   │  └─ 记录为什么需要改进规范
   └─ 在 known-issues.md 中记录问题（如有）
      └─ 记录发现的问题和解决方案
   ```

4. **验证规范的完整性**
   ```
   检查清单：
   - [ ] Rule 中的禁止事项是否完整
   - [ ] Rule 中的必须遵守是否准确
   - [ ] Skill 中的代码示例是否正确
   - [ ] Skill 中的常见问题是否覆盖
   - [ ] AGENTS.md 中的能力清单是否更新
   - [ ] 没有冗余或重复的规范
   - [ ] Rule 和 Skill 职责是否分离
   ```

5. **提交 PR**
   ```
   git commit -m "docs: 更新规范以支持新改动"
   
   PR 描述中说明：
   - 改动了什么代码
   - 为什么需要更新规范
   - 更新了哪些规范文件
   - 是否有新的禁止事项或必须遵守
   ```

**关键原则**：
- 规范改动必须经过人工审查
- 规范改动应该在 Code Review 中讨论
- 规范改动应该有明确的理由
- 规范改动应该记录在 feedback.md 中
- 不要自动生成规范，手动维护更安全

**常见场景**：

场景 A：发现现有规范不适用
```
1. 在 feedback.md 中记录问题
2. 更新对应的 Rule/Skill
3. 在 PR 中说明改进理由
4. Code Review 讨论并确认
```

场景 B：添加新功能需要新规范
```
1. 创建新的 Rule 文件（page-{name}.mdc）
2. 创建新的 Skill 文件（page-{name}/SKILL.md）
3. 在 AGENTS.md 中添加新行
4. 在 feedback.md 中记录决策
```

场景 C：修复 Bug 需要改进规范
```
1. 在 known-issues.md 中记录问题
2. 分析根本原因
3. 改进相关的 Rule/Skill 以防止再犯
4. 在 feedback.md 中记录改进
```

---

## 9. 新文件添加到工程的 SOP

**场景**：创建新的 `.swift` 文件后，需要添加到 Xcode 工程

**步骤**：

1. **创建文件**
   ```
   在对应目录创建 .swift 文件
   ├─ Controllers/ 目录 → ViewController / ViewModel 文件
   ├─ Views/ 目录 → View 文件
   ├─ Models/ 目录 → Model 文件
   └─ 其他目录 → 其他文件
   ```

2. **添加到工程 Target**
   ```
   选中新建的 .swift 文件
   → File Inspector（右侧面板）
   → Target Membership
   → 勾选 HealthDashboard
   ```

3. **验证添加成功**
   ```
   检查清单：
   - [ ] 文件在 Project Navigator 中可见
   - [ ] Target Membership 已勾选 HealthDashboard
   - [ ] 编译成功（⌘B）
   ```

4. **提交 PR**
   ```
   git add HealthDashboard/Controllers/HDExerciseViewController.swift
   git add HealthDashboard/Controllers/HDExerciseViewModel.swift
   git commit -m "feat: 添加运动页面文件到工程"
   ```

**常见问题**：

Q: 文件创建了但编译报错 `Cannot find type in scope`？
A: File Inspector → Target Membership → 确认勾选了 HealthDashboard，然后 `Cmd+Shift+K` 清理重编。

Q: 删除文件后需要做什么？
A: 在 Xcode 中选择文件 → Delete → Move to Trash（同时从工程移除）。

---

## 10. 发布版本的 SOP

**场景**：发布新版本

**步骤**：

1. **准备发布**
   ```
   - 所有 PR 已合并
   - 所有测试通过
   - 质量门禁检查通过
   ```

2. **更新版本号**
   ```
   遵循 Semantic Versioning：MAJOR.MINOR.PATCH
   
   - MAJOR：不兼容的 API 变更
   - MINOR：新增功能（向后兼容）
   - PATCH：Bug 修复
   ```

3. **更新文档**
   ```
   - CHANGELOG.md（新增功能、Bug 修复）
   - README.md（如有重大变更）
   - project-decisions.md（如有架构变更）
   - sop.md（如有流程变更）
   ```

4. **创建 Release**
   ```
   git tag v1.0.0
   git push origin v1.0.0
   ```

5. **发布**
   ```
   - 构建 App
   - 提交到 App Store（如需）
   - 通知用户
   ```

---

## 常见问题

### Q: 修改代码时 Rules 没有自动加载怎么办？
A: 
1. 确认打开的是正确的文件（如 HDDashboardViewController.m）
2. 检查 Cursor Settings 中 Rules 是否启用
3. 手动 `@` 引用对应的 Rule 文件

### Q: 不确定某个改动是否符合规范怎么办？
A:
1. 查看对应页面的 Rule（禁止事项、必须遵守）
2. 查看对应页面的 Skill（代码示例）
3. 运行质量检查：`.cursor/hooks/quality-gate.sh`

### Q: 发现新的 Bug 怎么办？
A:
1. 在 known-issues.md 中记录
2. 分析根本原因
3. 提交修复 PR
4. 更新 known-issues.md 的状态

### Q: 需要添加新功能怎么办？
A:
1. 在 project-decisions.md 中记录决策
2. 创建 Rule 和 Skill 文件
3. 更新 AGENTS.md
4. 实现功能
5. 提交 PR
