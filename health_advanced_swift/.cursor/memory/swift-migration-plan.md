---
name: swift-migration-plan
type: migration-guide
description: OC + MVC 到 Swift + MVVM 的渐进式迁移计划（精简版）
date: 2026/3/22
---

# Swift + MVVM 迁移计划

## 迁移前置条件

迁移前必须完成以下 8 项检查：

- [ ] 所有 OC 代码都有单元测试
- [ ] 所有 OC 代码都有 UI 测试
- [ ] 所有 OC 代码都有文档
- [ ] 建立了 Git 分支策略（feature/swift-xxx）
- [ ] 建立了 Code Review 流程
- [ ] 建立了性能基准测试
- [ ] 团队成员都了解 Swift 和 MVVM
- [ ] 创建了 Bridging Header 和配置了 Build Settings

## 迁移概览

采用**渐进式迁移**策略，将项目从 Objective-C + MVC 逐步迁移到 Swift + MVVM。

### 迁移目标

- ✅ 完全迁移到 Swift
- ✅ 采用 MVVM 架构
- ✅ 使用 Combine 进行数据绑定
- ✅ 保持功能完整性
- ✅ 代码覆盖率 > 90%
- ✅ 性能指标 ±15%

### 迁移时间

**优化后：3.5 周**（原计划 6 周）

### 迁移原则

1. 向后兼容 - OC 和 Swift 代码可以并存
2. 渐进式 - 逐个模块转换
3. 可回滚 - 每个阶段都可以回滚
4. 低风险 - 充分测试后再上线
5. 测试驱动 - 先写测试，再写代码

## 第 1 阶段：建立 Swift Agent 体系（1 周）

### 已完成

✅ Swift 全局规范 (`swift-always.mdc`)
✅ MVVM 架构规范 (`mvvm-architecture.mdc`)
✅ Combine 数据绑定规范 (`combine-binding.mdc`)
✅ Swift 语言 Skill (`swift-language/SKILL.md`)
✅ MVVM 模式 Skill (`mvvm-pattern/SKILL.md`)
✅ Combine 绑定 Skill (`combine-binding/SKILL.md`)

### 待完成

- [ ] 创建 Swift 版本的页面 Skills（5 个）
- [ ] 创建迁移检查清单
- [ ] 建立性能基准测试

## 第 2 阶段：逐个模块转换（3.5 周）

### 转换顺序与工作量

| 模块 | 工作量 | 递减率 | 优化后 | 人员 |
|---|---|---|---|---|
| Profile | 40h | 0% | 40h | 1 人 |
| TabBar | 30h | -25% | 22.5h | 1 人 |
| QuickAdd | 50h | -25% | 37.5h | 1 人 |
| Dashboard | 60h | -25% | 45h | 1-2 人 |
| Exercise | 80h | -25% | 60h | 2 人 |
| **总计** | **260h** | **-20%** | **205h** | - |

**并行转换时间表**：
```
第 1 周：Profile (1 人) + TabBar (1 人)
第 2 周：QuickAdd (1 人) + Dashboard (1 人)
第 3 周：Dashboard (2 人) + Exercise (1 人)
第 3.5 周：Exercise (2 人) + 最终验证
```

### 每个模块的转换流程

1. 分析 OC 代码（理解业务逻辑、识别数据流）
2. 创建 Swift 版本（ViewModel + ViewController + 测试）
3. 测试（单元测试 > 80% + UI 测试 + 性能测试）
4. 验证（功能完整性 + 性能达标 + 代码质量）
5. 灰度发布（10% → 25% → 50% → 100%）
6. 文档更新

### 转换检查清单

```
代码转换
  ☐ ViewModel 创建完成
  ☐ ViewController 创建完成
  ☐ 所有 API 已转换
  ☐ 主题切换已实现
  ☐ Delegate 通信已实现

代码质量
  ☐ 没有 Swift 编译警告
  ☐ 遵守规范（swift-always.mdc）
  ☐ 使用了 HD 前缀
  ☐ 没有硬编码颜色值

测试
  ☐ 单元测试覆盖率 > 80%
  ☐ UI 测试覆盖所有交互
  ☐ 性能测试通过
  ☐ 集成测试通过

功能验证
  ☐ 所有功能与 OC 版本一致
  ☐ 没有功能缺失
  ☐ 用户体验无差异
```

## 第 3 阶段：完全迁移（1 周）

- [ ] 删除所有 OC 代码
- [ ] 删除 OC 相关的 Rules 和 Skills
- [ ] 更新全局 AGENTS.md
- [ ] 最终验证和文档更新

## 技术选择

### UI 框架

**推荐：UIKit + MVVM + Combine**
- 学习曲线平缓
- 与现有代码兼容
- 社区资源丰富

### 数据绑定

**必须使用 Combine**
- Apple 官方框架
- 与 SwiftUI 无缝集成
- 性能优秀

## 迁移规范

### 命名规范

- ViewController：`HDXxxViewController`
- ViewModel：`HDXxxViewModel`
- View：`HDXxxView`
- Protocol：`HDXxxDelegate`

### 架构规范

- Model：数据层，通过 `HDHealthDataModel.shared` 访问
- ViewModel：业务逻辑层，使用 `@Published` 进行数据绑定
- View：UI 层，通过 `@ObservedObject` 订阅 ViewModel
- ViewController：协调层，管理生命周期和主题切换

## 测试规范

### 单元测试示例

```swift
class HDProfileViewModelTests: XCTestCase {
    var viewModel: HDProfileViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        viewModel = HDProfileViewModel()
        cancellables = Set<AnyCancellable>()
    }
    
    func testStepsGoalBinding() {
        let expectation = XCTestExpectation(description: "stepsGoal updated")
        
        viewModel.$stepsGoalText
            .dropFirst()
            .sink { text in
                XCTAssertEqual(text, "10000")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.updateStepsGoal(10000)
        wait(for: [expectation], timeout: 1.0)
    }
}
```

## OC 到 Swift 转换指南

### Bridging Header 配置

```objc
// HealthDashboard-Bridging-Header.h
#ifndef HealthDashboard_Bridging_Header_h
#define HealthDashboard_Bridging_Header_h

#import "HDHealthDataModel.h"
#import "HDMoodRecord.h"
#import "HDExerciseRecord.h"
#import "HDDashboardViewController.h"
#import "HDProfileViewController.h"
#import "HDQuickAddViewController.h"
#import "HDTabBarController.h"
#import "HDExerciseTypeViewController.h"
#import "HDQuickAddDelegate.h"
#import "HDExerciseDelegate.h"

#endif
```

在 Build Settings 中配置：`Objective-C Bridging Header` = `HealthDashboard/HealthDashboard-Bridging-Header.h`

### 常见转换模式

**KVO → Combine**：
```swift
// OC: [model addObserver:self forKeyPath:@"todaySteps" ...]
// Swift:
model.$todaySteps
    .sink { [weak self] newValue in
        self?.updateUI(newValue)
    }
    .store(in: &cancellables)
```

**NSNotification → Combine**：
```swift
// OC: [[NSNotificationCenter defaultCenter] addObserver:self ...]
// Swift:
NotificationCenter.default.publisher(for: NSNotification.Name("HDThemeDidChangeNotification"))
    .sink { [weak self] _ in
        self?.applyTheme()
    }
    .store(in: &cancellables)
```

**Block → 闭包**：
```swift
// OC: typedef void (^HDCompletionBlock)(BOOL success);
// Swift:
func fetchData(completion: @escaping (Bool) -> Void) { }
// 或使用 Combine:
func fetchData() -> AnyPublisher<Bool, Error> { }
```

**GCD → DispatchQueue**：
```swift
// OC: dispatch_async(dispatch_get_main_queue(), ^{ ... });
// Swift:
DispatchQueue.main.async { }
// 或使用 Combine:
model.$todaySteps
    .receive(on: DispatchQueue.main)
    .sink { value in }
    .store(in: &cancellables)
```

## 项目管理

### 进度跟踪

| 阶段 | 目标 | 进度 | 状态 |
|---|---|---|---|
| 第 1 阶段 | Agent 体系 | 0% | 待开始 |
| 第 2 阶段 | 模块转换 | 0% | 待开始 |
| 第 3 阶段 | 完全迁移 | 0% | 待开始 |

### 风险跟踪

| 风险 | 状态 | 所有者 | 处理方案 |
|---|---|---|---|
| 功能不一致 | 监控中 | QA | 功能对标测试 |
| 性能下降 | 监控中 | 性能团队 | 性能基准测试 |
| 学习曲线 | 监控中 | 培训负责人 | 充分培训 |

### 每周进度报告

- 完成的工作
- 遇到的问题
- 下周计划
- 风险预警

## 应急预案

### 性能严重下降应急

**触发条件**：
- 平均加载时间 > 200ms
- 内存使用 > 100MB
- 帧率 < 30 FPS

**应急流程**：
1. 启动性能优化团队
2. 使用 Instruments 分析
3. 识别性能瓶颈
4. 进行性能优化
5. 重新进行性能测试
6. 如果无法达标，考虑回滚

### 大量 Bug 应急

**触发条件**：
- 新 Bug 数 > 10 个/天
- 关键 Bug 数 > 3 个
- 用户投诉 > 20 条

**应急流程**：
1. 启动 Bug 修复团队
2. 优先级排序
3. 分配修复任务
4. 加班修复 Bug
5. 进行回归测试
6. 发布修复版本
7. 如果无法控制，考虑回滚

## 用户沟通计划

### 沟通时间表

| 时间 | 内容 | 方式 |
|---|---|---|
| 第 1 周 | 宣布迁移计划 | 博客 + 邮件 + 应用内通知 |
| 第 4 周 | 发布 Beta 版本 | 邀请 Beta 测试 |
| 第 8 周 | 发布正式版本 | 发布更新日志 |

### 反馈处理流程

1. 收集反馈（应用内、邮件、社交媒体）
2. 分类反馈（Bug、功能、建议）
3. 优先级排序
4. 分配处理
5. 跟进反馈
6. 关闭反馈

## 文档维护计划

### 文档所有者

| 文档 | 所有者 | 更新频率 |
|---|---|---|
| Swift 规范 | 技术负责人 | 每月 |
| MVVM 规范 | 架构师 | 每月 |
| 迁移计划 | 项目经理 | 每周 |
| 代码示例 | 开发团队 | 每周 |
| 最佳实践 | 技术委员会 | 每月 |

## 版本管理

### 版本兼容性矩阵

| 版本 | OC 代码 | Swift 代码 | 状态 |
|---|---|---|---|
| v1.0 | 100% | 0% | 当前版本 |
| v1.1 | 80% | 20% | Profile + TabBar |
| v1.2 | 60% | 40% | + QuickAdd |
| v1.3 | 40% | 60% | + Dashboard |
| v1.4 | 20% | 80% | + Exercise |
| v2.0 | 0% | 100% | 完全迁移 |

### 向后兼容性

- 保持 API 兼容性
- 使用 Deprecation 标记旧 API
- 提供迁移指南
- 支持 iOS 13.0+

## 后续计划

### 短期（迁移后 1 个月）

- [ ] 收集用户反馈
- [ ] 修复发现的 bug
- [ ] 优化性能

### 中期（迁移后 3 个月）

- [ ] 引入 SwiftUI（可选）
- [ ] 优化代码结构
- [ ] 提升代码覆盖率

### 长期（迁移后 6 个月）

- [ ] 升级到最新 iOS 版本
- [ ] 采用新的 Apple 框架
- [ ] 持续优化和改进

## 风险管理

### 风险矩阵

| 风险 | 概率 | 影响 | 等级 | 预防措施 |
|---|---|---|---|---|
| 功能不一致 | 低 | 高 | 8 | 功能对标测试 |
| 性能下降 | 中 | 高 | 12 | 性能基准测试 |
| 学习曲线 | 中 | 低 | 6 | 充分培训 |
| Combine 泄漏 | 低 | 中 | 6 | 代码审查 |
| 循环引用 | 低 | 中 | 6 | 代码审查 |

### 风险预防

**功能不一致**：创建功能对标清单 → 编写测试用例 → 功能对标测试

**性能下降**：建立性能基准 → 性能测试 → 性能优化

**学习曲线**：8 周培训（Swift 基础 → MVVM → Combine → 项目实战）

**Combine 泄漏**：使用 `.store(in: &cancellables)` + 代码审查

**循环引用**：使用 `[weak self]` + 代码审查

## 性能基准

### 性能目标

| 模块 | 目标 | 说明 |
|---|---|---|
| Profile | ±15% | 简单模块 |
| TabBar | ±15% | 简单模块 |
| QuickAdd | ±18% | 中等复杂 |
| Dashboard | ±20% | 复杂模块 |
| Exercise | ±20% | 复杂模块 |

### 关键成功指标（KPI）

| KPI | 目标 | 测量方法 |
|---|---|---|
| 功能完整性 | 100% | 功能对标测试 |
| 崩溃率 | < 0.05% | Firebase Crashlytics |
| 性能指标 | ±15% | Instruments |
| 代码覆盖率 | > 90% | Codecov |
| 代码审查通过率 | > 95% | GitHub |
| 用户满意度 | > 80% | 用户反馈 |

## 灰度发布

### 发布阶段

| 阶段 | 用户比例 | 时间 | 崩溃率 | 性能 | 投诉数 |
|---|---|---|---|---|---|
| 第 1 阶段 | 10% | 1 周 | < 0.05% | ±15% | - |
| 第 2 阶段 | 25% | 1 周 | < 0.08% | ±18% | < 5 |
| 第 3 阶段 | 50% | 1 周 | < 0.1% | ±20% | < 10 |
| 第 4 阶段 | 100% | 立即 | < 0.1% | ±20% | < 20 |

### 回滚条件

**立即回滚**：
- 崩溃率 > 0.1%
- 关键功能不可用
- 数据丢失

**讨论后回滚（24 小时内）**：
- 崩溃率 > 0.05%
- 性能下降 > 30%
- 用户投诉 > 10 条

### 回滚流程

```
触发条件 → 应急会议（15 分钟）→ 停止发布（5 分钟）
→ 从 oc-backup 恢复（10 分钟）→ 回滚测试（30 分钟）
→ 发布回滚版本（10 分钟）→ 验证成功（15 分钟）
→ 分析原因（1 小时）→ 制定改进方案（1 小时）

总耗时：约 2.5 小时
```

## 团队培训

### 培训计划（8 周）

| 阶段 | 内容 | 时间 | 考核 |
|---|---|---|---|
| 第 1-2 周 | Swift 基础 | 2 周 | 5 个练习 + 测试 |
| 第 3-4 周 | MVVM 架构 | 2 周 | 3 个练习 + 测试 |
| 第 5-6 周 | Combine 绑定 | 2 周 | 3 个练习 + 测试 |
| 第 7-8 周 | 项目实战 | 2 周 | Profile 模块转换 |

### 快速通道

- **有 Swift 经验**：快速通道（4 周）
- **无 Swift 经验**：标准路径（8 周）
- **学习困难**：补习课程（10 周）

## 自动化工具

| 工具 | 功能 | 用途 |
|---|---|---|
| SwiftLint | 代码检查 | 检查代码规范 |
| SwiftFormat | 代码格式化 | 统一代码风格 |
| Sourcery | 代码生成 | 自动生成 ViewModel 模板 |
| XCTest | 单元测试 | 编写和运行单元测试 |
| XCUITest | UI 测试 | 编写和运行 UI 测试 |
| Fastlane | 自动化测试 | 自动运行测试套件 |
| Codecov | 覆盖率分析 | 分析代码覆盖率 |
| Firebase Crashlytics | 崩溃监控 | 实时崩溃监控 |
| Firebase Performance | 性能监控 | 实时性能监控 |
| Instruments | 性能分析 | 分析 CPU、内存、帧率 |

## 常见问题

### Q1：如何处理 OC 中的 KVO？
A：使用 Combine 的 `@Published` 替代

### Q2：如何处理 OC 中的 NSNotification？
A：使用 Combine 的 `NotificationCenter.default.publisher`

### Q3：如何处理 OC 中的 Block？
A：使用 Swift 的闭包或 Combine

### Q4：如何处理 OC 中的 GCD？
A：使用 Swift 的 DispatchQueue 或 Combine 的 `receive(on:)`

### Q5：如何处理 OC 中的 performSelector？
A：直接调用方法或使用 DispatchQueue.main.asyncAfter

## 故障排除

### Combine 订阅不工作

**排查**：
1. 检查是否使用了 `.store(in: &cancellables)`
2. 检查是否在主线程更新 UI（使用 `.receive(on: DispatchQueue.main)`）
3. 检查是否有循环引用（使用 `[weak self]`）

**解决**：
```swift
model.$todaySteps
    .print("步数")
    .receive(on: DispatchQueue.main)
    .sink { [weak self] value in
        self?.updateUI(value)
    }
    .store(in: &cancellables)
```

### 内存泄漏

**排查**：使用 Instruments 的 Leaks 工具检测

**解决**：
```swift
// ❌ 错误：强引用 self
model.$todaySteps.sink { [self] value in }

// ✅ 正确：弱引用 self
model.$todaySteps.sink { [weak self] value in }
```

### 性能下降

**排查**：使用 Instruments 的 Time Profiler 分析

**解决**：
- 避免过度订阅
- 避免频繁的数据转换
- 避免主线程阻塞

## 相关文档

- `.cursor/rules/swift-always.mdc` - Swift 全局规范
- `.cursor/rules/mvvm-architecture.mdc` - MVVM 架构规范
- `.cursor/rules/combine-binding.mdc` - Combine 数据绑定规范
- `.agents/skills/swift-language/SKILL.md` - Swift 语言知识库
- `.agents/skills/mvvm-pattern/SKILL.md` - MVVM 模式知识库
- `.agents/skills/combine-binding/SKILL.md` - Combine 绑定知识库

## 迁移成功标准

✅ 所有功能正常运行
✅ 性能指标达标（±15%）
✅ 代码覆盖率 > 90%
✅ 无遗留 OC 代码
✅ 无编译警告
✅ 用户反馈良好
✅ 文档完整

**现在可以开始迁移了！** 🚀
