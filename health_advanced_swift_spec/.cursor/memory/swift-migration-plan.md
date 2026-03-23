---
name: swift-migration-plan
type: migration-guide
description: OC + MVC 到 Swift + MVVM 的渐进式迁移计划（精简版）
date: 2026/3/22
---

# Swift + MVVM 迁移计划

## 迁移前置条件

迁移前必须完成以下 7 项检查（精简版）：

- [ ] 建立了 Git 分支策略（feature/swift-xxx）
- [ ] 建立了 Code Review 流程
- [ ] 建立了性能基准测试
- [ ] 团队成员都了解 Swift 和 MVVM
- [ ] 创建了 Bridging Header 和配置了 Build Settings
- [ ] 准备了回滚方案（oc-backup 分支）
- [ ] **创建了功能对标清单**（OC vs Swift 功能完整性检查表）

**说明**：
- 移除了"所有代码都有测试/文档"的要求，改为在迁移过程中逐步补充
- 新增"功能对标清单"是无缝迁移的关键，必须在迁移前准备好
- 这样可以加快迁移启动速度，同时保持质量控制

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

**优化后：5 周**（原计划 6 周）

**时间分解**：
- 第 1 阶段（Agent 体系）：已完成 ✅
- 第 2 阶段（模块转换）：3 周（并行开发 + 灰度发布）
- 第 3 阶段（稳定期）：1 周（监控 + Bug 修复）
- 第 4 阶段（完全迁移）：1 周（清理 OC 代码 + 最终验证）

**关键**：不能跳过稳定期，必须等待 Swift 版本运行稳定后再删除 OC 代码

### 迁移原则

1. 向后兼容 - OC 和 Swift 代码可以并存
2. 渐进式 - 逐个模块转换
3. 可回滚 - 每个阶段都可以回滚
4. 低风险 - 充分测试后再上线
5. 测试驱动 - 先写测试，再写代码

## 第 1 阶段：建立 Swift Agent 体系（已完成 ✅）

### 已完成

✅ Swift 全局规范 (`swift-always.mdc`)
✅ MVVM 架构规范 (`mvvm-architecture.mdc`)
✅ Combine 数据绑定规范 (`combine-binding.mdc`)
✅ Swift 语言 Skill (`swift-language/SKILL.md`)
✅ MVVM 模式 Skill (`mvvm-pattern/SKILL.md`)
✅ Combine 绑定 Skill (`combine-binding/SKILL.md`)
✅ 页面级 Rules（5 个）
✅ 全局 AGENTS.md 导航体系

### 优化说明

移除了"创建 Swift 版本的页面 Skills"的要求，改为在转换过程中动态生成。这样可以：
- 避免重复文档维护
- 确保 Skills 与实际代码同步
- 减少前期准备工作

## 第 2 阶段：逐个模块转换（3.5 周）

### 转换顺序与工作量

**关键**：必须按照依赖关系转换，否则会出现功能不完整

```
依赖关系图：
  HDHealthDataModel (Model 层，所有模块依赖)
    ↓
  Profile (独立模块，无依赖)
  TabBar (依赖 Dashboard、QuickAdd、Profile)
  QuickAdd (依赖 Dashboard Delegate)
  Dashboard (依赖 QuickAdd、Exercise Delegate)
  Exercise (独立模块，无依赖)
```

**转换顺序**（必须遵守）：

| 顺序 | 模块 | 原因 | 工作量 | 人员 |
|---|---|---|---|---|
| 1 | Profile | 独立，无依赖 | 20h | 1 人 |
| 2 | Exercise | 独立，无依赖 | 48h | 2 人 |
| 3 | QuickAdd | 需要 Dashboard Delegate | 30h | 1 人 |
| 4 | Dashboard | 需要 QuickAdd、Exercise Delegate | 36h | 1-2 人 |
| 5 | TabBar | 最后转换，依赖所有子 VC | 18h | 1 人 |
| **总计** | - | - | **152h** | - |

**并行转换时间表**（3 周）：
```
第 1 周：
  - Profile (1 人) + Exercise (2 人)
  
第 2 周：
  - QuickAdd (1 人) + Dashboard (1-2 人)
  
第 3 周：
  - TabBar (1 人) + 最终验证 + 灰度发布
  
第 4 周：
  - 稳定期（监控 + Bug 修复）
  
第 5 周：
  - 清理 OC 代码 + 最终验证
```

**总时间**：5 周（包括稳定期和清理）

1. **分析 OC 代码**（理解业务逻辑、识别数据流）
   - 列出所有 public 方法和属性
   - 识别所有 Delegate 回调
   - 记录所有 NSNotification 监听
   - 识别所有数据持久化操作

2. **创建功能对标清单**（无缝迁移的关键）
   - 列出 OC 版本的所有功能点
   - 为每个功能点创建测试用例
   - 定义验收标准（功能、性能、UI）

3. **创建 Swift 版本**（ViewModel + ViewController + 测试）
   - 同步实现所有 OC 功能
   - 保持 API 兼容性（Bridging Header）
   - 编写对应的测试用例

4. **功能对标测试**（必须 100% 通过）
   - 逐项验证每个功能点
   - 对比 OC 和 Swift 的行为
   - 记录任何差异并修复

5. **性能和质量验证**
   - 单元测试 > 80%
   - UI 测试覆盖所有交互
   - 性能测试通过（±15%）
   - 代码审查通过

6. **灰度发布**（10% → 25% → 50% → 100%）
   - 每个阶段监控崩溃率和性能
   - 收集用户反馈
   - 发现问题立即回滚

7. **文档更新**

### 转换检查清单

```
代码转换
  ☐ ViewModel 创建完成
  ☐ ViewController 创建完成
  ☐ 所有 API 已转换
  ☐ 主题切换已实现
  ☐ Delegate 通信已实现
  ☐ 所有 NSNotification 已转换为 Combine
  ☐ 所有数据持久化逻辑已迁移

代码质量
  ☐ 没有 Swift 编译警告
  ☐ 遵守规范（swift-always.mdc）
  ☐ 使用了 HD 前缀
  ☐ 没有硬编码颜色值
  ☐ 没有循环引用（使用 [weak self]）

测试
  ☐ 单元测试覆盖率 > 80%
  ☐ UI 测试覆盖所有交互
  ☐ 性能测试通过（±15%）
  ☐ 集成测试通过
  ☐ 内存泄漏测试通过

功能对标验证（必须 100% 通过）
  ☐ 所有功能与 OC 版本一致
  ☐ 没有功能缺失
  ☐ 用户体验无差异
  ☐ 数据一致性验证
  ☐ 边界条件测试
  ☐ 错误处理一致性
```

## 第 3 阶段：完全迁移（1 周）

### 清理阶段（0.5 周）

- [ ] 所有模块 Swift 版本已上线 1 周以上
- [ ] 崩溃率 < 0.05%，性能达标
- [ ] 用户反馈良好，无重大 Bug

### 删除阶段（0.5 周）

- [ ] 删除所有 OC 代码（分批删除，保留 git 历史）
- [ ] 删除 Bridging Header
- [ ] 删除 OC 相关的 Rules 和 Skills
- [ ] 更新全局 AGENTS.md
- [ ] 最终验证和文档更新

**优化说明**：
- 不能在第 2 阶段最后直接删除 OC 代码
- 必须等待 Swift 版本稳定运行 1 周以上
- 保留 git 历史便于问题追踪和回滚
- 分批删除降低风险

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

## 功能对标清单模板

### Profile 模块示例

```
功能点：目标步数设置
┌─────────────────────────────────────────────────────────┐
│ OC 版本行为                                              │
├─────────────────────────────────────────────────────────┤
│ 1. 读取 HDHealthDataModel.stepsGoal                     │
│ 2. 显示在 UITextField 中                                │
│ 3. 用户修改后调用 setStepsGoal:                         │
│ 4. 发送 HDDataDidChange 通知                            │
│ 5. Dashboard 监听通知并刷新进度环                       │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ Swift 版本验收标准                                       │
├─────────────────────────────────────────────────────────┤
│ ✓ ViewModel 通过 @Published 绑定目标值                  │
│ ✓ ViewController 显示相同的 UI                          │
│ ✓ 用户修改后调用 Model 的 setStepsGoal:                │
│ ✓ Model 发送 Combine 通知                               │
│ ✓ Dashboard 通过 Combine 订阅并刷新                     │
│ ✓ 性能：加载时间 ±15%                                   │
│ ✓ 内存：使用量 ±10%                                     │
└─────────────────────────────────────────────────────────┘

测试用例：
  [ ] 初始值正确加载
  [ ] 修改值后立即更新
  [ ] 修改值后 Dashboard 同步更新
  [ ] 边界值测试（0, 999999）
  [ ] 无效输入处理
```

### 创建对标清单的步骤

1. **逐个模块创建清单**
   - Profile：目标设置、数据展示
   - TabBar：Tab 切换、主题切换
   - QuickAdd：数据录入、Delegate 回调
   - Dashboard：数据绑定、进度显示
   - Exercise：计时、数据保存

2. **每个功能点包含**
   - OC 版本的具体行为
   - Swift 版本的验收标准
   - 测试用例清单
   - 性能基准

3. **在转换前完成**
   - 这是无缝迁移的关键
   - 避免遗漏功能
   - 确保 100% 功能对标

## 数据一致性验证工具

### 必需的验证机制

为了确保无缝迁移，必须在 Model 层添加以下验证：

```swift
// HDHealthDataModel.swift
class HDHealthDataModel {
    // 数据变更日志（用于对标验证）
    private var changeLog: [(timestamp: Date, key: String, oldValue: Any, newValue: Any)] = []
    
    // 验证 OC 和 Swift 版本数据一致性
    func validateDataConsistency() -> Bool {
        let ocSteps = self.todaySteps
        let ocWater = self.waterML
        let ocMood = self.latestMood?.moodLevel ?? 0
        
        // 与预期值对比
        return ocSteps >= 0 && ocWater >= 0 && ocMood >= 0
    }
    
    // 记录所有数据变更
    private func logChange(key: String, oldValue: Any, newValue: Any) {
        changeLog.append((Date(), key, oldValue, newValue))
        // 保留最近 1000 条记录
        if changeLog.count > 1000 {
            changeLog.removeFirst()
        }
    }
    
    // 导出变更日志用于调试
    func exportChangeLog() -> String {
        return changeLog.map { 
            "[\($0.timestamp)] \($0.key): \($0.oldValue) → \($0.newValue)"
        }.joined(separator: "\n")
    }
}
```

### 灰度发布中的数据验证

在灰度发布的每个阶段，必须验证：

```
第 1 阶段（10% 用户）
  ✓ 随机抽样 100 个用户的数据
  ✓ 对比 OC 版本和 Swift 版本的数据
  ✓ 验证数据一致性 100%
  ✓ 如果发现不一致，立即回滚

第 2 阶段（25% 用户）
  ✓ 随机抽样 500 个用户的数据
  ✓ 对比数据一致性
  ✓ 验证没有新增不一致

第 3 阶段（50% 用户）
  ✓ 随机抽样 1000 个用户的数据
  ✓ 对比数据一致性
  ✓ 验证没有新增不一致

第 4 阶段（100% 用户）
  ✓ 全量验证所有用户数据
  ✓ 确保 100% 一致
```

## 功能完整性检查清单

### Profile 模块

```
数据展示
  ☐ 显示今日步数
  ☐ 显示步数进度环
  ☐ 显示目标步数
  ☐ 显示今日喝水量
  ☐ 显示喝水进度环
  ☐ 显示目标喝水量
  ☐ 显示近 7 天睡眠数据
  ☐ 显示最近心情记录

目标设置
  ☐ 修改步数目标
  ☐ 修改喝水目标
  ☐ 保存目标到本地
  ☐ 修改后 Dashboard 同步更新

主题切换
  ☐ Dark Mode 切换
  ☐ 所有 UI 元素响应主题变化
  ☐ 主题状态持久化
```

### TabBar 模块

```
Tab 管理
  ☐ 3 个 Tab 正常显示
  ☐ Tab 切换正常工作
  ☐ Tab 顺序正确（Dashboard、QuickAdd、Profile）

主题切换
  ☐ 主题切换时所有子 VC 更新
  ☐ Tab 图标颜色响应主题
  ☐ Tab 文字颜色响应主题

Delegate 设置
  ☐ QuickAdd delegate 正确设置
  ☐ Dashboard 能接收 QuickAdd 回调
```

### QuickAdd 模块

```
喝水录入
  ☐ 输入框接收用户输入
  ☐ 验证输入范围（100-2000ml）
  ☐ 提交后调用 Model.addWater()
  ☐ 调用 Delegate 回调
  ☐ Dashboard 收到回调并更新

步数录入
  ☐ 输入框接收用户输入
  ☐ 验证输入范围（1-50000）
  ☐ 提交后调用 Model.addSteps()
  ☐ 调用 Delegate 回调
  ☐ Dashboard 收到回调并更新

心情录入
  ☐ 显示 5 个心情选项
  ☐ 用户选择后调用 Model.addMood()
  ☐ 调用 Delegate 回调
  ☐ Dashboard 收到回调并更新

表单校验
  ☐ 空值检查
  ☐ 范围检查
  ☐ 错误提示
```

### Dashboard 模块

```
数据绑定
  ☐ 步数数据绑定
  ☐ 喝水数据绑定
  ☐ 睡眠数据绑定
  ☐ 心情数据绑定

进度显示
  ☐ 步数进度环显示
  ☐ 喝水进度环显示
  ☐ 进度值正确计算
  ☐ 进度颜色根据完成度变化

Delegate 回调
  ☐ 接收 QuickAdd 回调
  ☐ 接收 Exercise 回调
  ☐ 回调后数据正确更新

主题切换
  ☐ Dark Mode 切换
  ☐ 所有卡片颜色响应主题
  ☐ 文字颜色响应主题

数据刷新
  ☐ viewWillAppear 时刷新数据
  ☐ 接收通知时刷新数据
  ☐ 接收 Delegate 回调时刷新数据
```

### Exercise 模块

```
运动类型选择
  ☐ 显示运动类型列表
  ☐ 用户选择后进入计时页面

运动计时
  ☐ 计时器正常工作
  ☐ 显示运动时间
  ☐ 显示预计卡路里
  ☐ 暂停/继续功能
  ☐ 停止功能

运动统计
  ☐ 显示运动时间
  ☐ 显示运动卡路里
  ☐ 显示运动距离（如果有）
  ☐ 保存运动数据到 Model
  ☐ 调用 Delegate 回调

运动目标设置
  ☐ 显示目标运动时间
  ☐ 显示目标卡路里
  ☐ 修改目标
  ☐ 保存目标到本地

主题切换
  ☐ Dark Mode 切换
  ☐ 所有 UI 元素响应主题
```

### 全局功能

```
数据持久化
  ☐ 所有数据保存到本地
  ☐ 应用重启后数据恢复
  ☐ 数据格式正确

主题系统
  ☐ Dark Mode 切换
  ☐ 所有 VC 实现 applyTheme
  ☐ 主题状态持久化
  ☐ 应用重启后主题恢复

性能指标
  ☐ 应用启动时间 ±15%
  ☐ 页面切换时间 ±15%
  ☐ 数据加载时间 ±15%
  ☐ 内存使用 ±10%
  ☐ 帧率 ≥ 55 FPS

崩溃和错误
  ☐ 没有崩溃
  ☐ 没有编译警告
  ☐ 错误处理完整
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

## 无缝迁移关键点

### 0. Feature Flag 控制策略（最关键！）

**问题**：OC 和 Swift 版本同时存在时，如果没有明确的版本控制，容易出现混乱

**解决方案**：使用 Feature Flag 精确控制版本切换

```swift
// HDFeatureFlags.swift
class HDFeatureFlags {
    static let shared = HDFeatureFlags()
    
    // 每个模块的版本控制
    var useSwiftProfile: Bool = false      // Profile 使用 Swift 版本
    var useSwiftTabBar: Bool = false       // TabBar 使用 Swift 版本
    var useSwiftQuickAdd: Bool = false     // QuickAdd 使用 Swift 版本
    var useSwiftDashboard: Bool = false    // Dashboard 使用 Swift 版本
    var useSwiftExercise: Bool = false     // Exercise 使用 Swift 版本
    
    // 灰度发布控制
    var swiftVersionPercentage: Int = 0    // 0-100，表示使用 Swift 版本的用户比例
    
    // 判断当前用户是否使用 Swift 版本
    func shouldUseSwiftVersion(for module: String) -> Bool {
        let userID = getCurrentUserID()
        let hash = userID.hashValue % 100
        return hash < swiftVersionPercentage
    }
}

// 在 TabBarController 中使用
class HDTabBarController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if HDFeatureFlags.shared.useSwiftProfile {
            // 使用 Swift 版本的 Profile
            let profileVC = HDProfileViewController()
            // ...
        } else {
            // 使用 OC 版本的 Profile
            let profileVC = HDProfileViewController()
            // ...
        }
    }
}
```

**验证清单**：
- [ ] Feature Flag 正确控制版本切换
- [ ] 同一用户在应用重启后版本一致
- [ ] 灰度发布百分比正确
- [ ] 没有出现混合版本的情况

### 1. 数据一致性

**问题**：OC 和 Swift 版本数据不同步

**解决方案**：
```swift
// ✅ 正确：共享同一个 Model 单例
let model = HDHealthDataModel.shared  // OC 单例
model.$todaySteps  // Swift 访问 OC 属性
```

**验证**：
- [ ] 修改 OC 版本数据，Swift 版本能读到
- [ ] 修改 Swift 版本数据，OC 版本能读到
- [ ] 数据持久化一致

### 2. Delegate 通信

**问题**：OC Delegate 和 Swift Delegate 混用

**解决方案**：
```swift
// ✅ 正确：保持 Delegate 兼容
@protocol HDQuickAddDelegate <NSObject>
- (void)quickAddDidUpdateData;
@end

// Swift 实现
class HDDashboardViewController: UIViewController, HDQuickAddDelegate {
    func quickAddDidUpdateData() {
        // 刷新数据
    }
}
```

**验证**：
- [ ] QuickAdd 调用 Delegate 回调
- [ ] Dashboard 正确接收回调
- [ ] 数据正确更新

### 3. NSNotification 转换

**问题**：OC 使用 NSNotification，Swift 使用 Combine

**解决方案**：
```swift
// ✅ 正确：Model 同时发送两种通知
- (void)addWater:(CGFloat)ml {
    _waterML += ml;
    // OC 通知（兼容旧代码）
    [[NSNotificationCenter defaultCenter] 
        postNotificationName:@"HDDataDidChange" object:nil];
    // Combine 通知（新代码）
    self.waterMLDidChange?(_waterML);
}
```

**验证**：
- [ ] OC 代码能收到 NSNotification
- [ ] Swift 代码能通过 Combine 订阅
- [ ] 两种方式数据一致

### 4. 主题切换

**问题**：OC 和 Swift 版本主题不同步

**解决方案**：
```swift
// ✅ 正确：统一通过 Model 的 isDarkMode
// OC 版本
[HDHealthDataModel shared].isDarkMode = YES;

// Swift 版本
HDHealthDataModel.shared.isDarkMode = true

// 所有 VC 都监听这个属性
model.$isDarkMode
    .sink { [weak self] isDark in
        self?.applyTheme()
    }
    .store(in: &cancellables)
```

**验证**：
- [ ] 切换主题时所有 VC 同步更新
- [ ] OC 和 Swift VC 主题一致
- [ ] 主题状态持久化

### 5. 内存管理

**问题**：Swift 中出现循环引用导致内存泄漏

**解决方案**：
```swift
// ❌ 错误：强引用 self
model.$todaySteps
    .sink { [self] value in
        self.updateUI(value)
    }
    .store(in: &cancellables)

// ✅ 正确：弱引用 self
model.$todaySteps
    .sink { [weak self] value in
        self?.updateUI(value)
    }
    .store(in: &cancellables)
```

**验证**：
- [ ] 使用 Instruments 检测内存泄漏
- [ ] 所有 Combine 订阅都使用 [weak self]
- [ ] ViewController 释放时 cancellables 也释放

### 6. 并行运行测试（关键！）

**问题**：OC 和 Swift 版本同时运行时，可能出现数据不同步

**解决方案**：在灰度发布前进行 48 小时的并行测试

```
第 1 步：在测试环境中同时运行 OC 和 Swift 版本
  - 使用 Feature Flag 控制版本切换
  - 同一用户在两个版本间切换
  - 验证数据一致性

第 2 步：关键场景对标测试
  - 修改数据后立即切换版本，验证数据一致
  - 主题切换后验证两个版本都更新
  - Delegate 回调验证（QuickAdd → Dashboard）
  - 数据持久化验证（重启应用后数据一致）

第 3 步：压力测试
  - 快速切换版本 100 次
  - 并发修改数据
  - 验证没有崩溃和数据丢失

第 4 步：内存泄漏检测
  - 使用 Instruments 检测两个版本的内存
  - 验证没有新增泄漏
```

**验证清单**：
- [ ] 数据一致性 100% 通过
- [ ] 没有发现新的崩溃
- [ ] 内存使用正常
- [ ] 性能指标达标

### 7. 灰度发布策略

**第 1 阶段（10% 用户）**：
- 监控崩溃率（目标 < 0.05%）
- 监控性能（目标 ±15%）
- 收集用户反馈
- **关键**：这 10% 用户的数据必须与 OC 版本用户数据一致

**第 2 阶段（25% 用户）**：
- 如果第 1 阶段通过
- 继续监控关键指标

**第 3 阶段（50% 用户）**：
- 如果第 2 阶段通过
- 继续监控

**第 4 阶段（100% 用户）**：
- 如果第 3 阶段通过
- 全量发布

**回滚条件**：
- 崩溃率 > 0.1%
- 性能下降 > 30%
- 关键功能不可用
- 用户投诉 > 20 条
- **数据不一致**（最严重，立即回滚）

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

### 培训计划（4 周，并行进行）

| 阶段 | 内容 | 时间 | 考核 |
|---|---|---|---|
| 第 1 周 | Swift 基础 + MVVM 架构 | 1 周 | 3 个练习 |
| 第 2 周 | Combine 绑定 + 项目实战 | 1 周 | Profile 模块转换 |
| 第 3-4 周 | 实际迁移工作 | 2 周 | 完成分配的模块 |

**优化说明**：
- 将培训与实际迁移工作结合
- 学习 + 实战并行，提高效率
- 移除了"快速通道"和"补习课程"的复杂分类

### 学习资源

- 官方文档：`.cursor/rules/swift-always.mdc` 等
- 代码示例：`.agents/skills/swift-language/SKILL.md` 等
- 实战项目：Profile 模块作为学习项目

## 自动化工具

### 必需工具

| 工具 | 功能 | 优先级 |
|---|---|---|
| SwiftLint | 代码检查 | 🔴 必需 |
| XCTest | 单元测试 | 🔴 必需 |
| Instruments | 性能分析 | 🔴 必需 |

### 可选工具

| 工具 | 功能 | 优先级 |
|---|---|---|
| SwiftFormat | 代码格式化 | 🟡 推荐 |
| Sourcery | 代码生成 | 🟡 推荐 |
| XCUITest | UI 测试 | 🟡 推荐 |
| Fastlane | 自动化测试 | 🟢 可选 |
| Codecov | 覆盖率分析 | 🟢 可选 |
| Firebase Crashlytics | 崩溃监控 | 🟢 可选 |

**优化说明**：
- 精简工具链，只保留必需的
- 避免过度工程化
- 后续可根据需要逐步添加

## 转换过程中的常见陷阱

### ❌ 陷阱 1：忘记在 Swift 版本中实现 Delegate 回调

**问题**：QuickAdd 的 Swift 版本没有调用 Delegate 回调，导致 Dashboard 无法更新

**解决方案**：
```swift
// ✅ 正确：在 Swift 版本中调用 Delegate
class HDQuickAddViewController: UIViewController {
    weak var delegate: HDQuickAddDelegate?
    
    @IBAction func submitButtonTapped() {
        // 1. 验证输入
        guard let ml = Double(waterTextField.text), ml >= 100, ml <= 2000 else {
            showError("输入范围 100-2000ml")
            return
        }
        
        // 2. 调用 Model 方法
        HDHealthDataModel.shared.addWater(ml)
        
        // 3. 调用 Delegate 回调（关键！）
        delegate?.quickAddDidUpdateData()
        
        // 4. 关闭页面
        dismiss(animated: true)
    }
}
```

**验证**：
- [ ] 每个 QuickAdd 功能都有 Delegate 回调
- [ ] Dashboard 能接收回调
- [ ] 数据正确更新

### ❌ 陷阱 2：NSNotification 和 Combine 混用导致重复更新

**问题**：OC 版本发送 NSNotification，Swift 版本同时监听 NSNotification 和 Combine，导致数据更新两次

**解决方案**：
```swift
// ✅ 正确：只监听 Combine，不监听 NSNotification
class HDDashboardViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // 只订阅 Combine，不订阅 NSNotification
        HDHealthDataModel.shared.$todaySteps
            .sink { [weak self] value in
                self?.updateUI(value)
            }
            .store(in: &cancellables)
    }
}
```

**验证**：
- [ ] Swift 版本只使用 Combine
- [ ] 没有重复订阅
- [ ] 数据只更新一次

### ❌ 陷阱 3：主题切换时 OC 和 Swift 版本不同步

**问题**：切换主题时，OC 版本的 VC 更新了，但 Swift 版本的 VC 没有更新

**解决方案**：
```swift
// ✅ 正确：所有 VC 都监听 isDarkMode 变化
class HDProfileViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 监听主题变化
        HDHealthDataModel.shared.$isDarkMode
            .sink { [weak self] _ in
                self?.applyTheme()
            }
            .store(in: &cancellables)
    }
    
    func applyTheme() {
        let isDark = HDHealthDataModel.shared.isDarkMode
        view.backgroundColor = isDark ? .black : .white
    }
}
```

**验证**：
- [ ] 所有 VC 都实现 applyTheme
- [ ] 主题切换时所有 VC 同步更新
- [ ] OC 和 Swift 版本主题一致

### ❌ 陷阱 4：数据持久化不一致

**问题**：OC 版本保存数据到 UserDefaults，Swift 版本读取时格式不同

**解决方案**：
```swift
// ✅ 正确：统一使用 Model 的方法读写数据
let steps = HDHealthDataModel.shared.todaySteps
```

**验证**：
- [ ] 所有数据读写都通过 Model
- [ ] 没有直接访问 UserDefaults
- [ ] 数据格式一致

### ❌ 陷阱 5：内存泄漏导致 ViewController 无法释放

**问题**：Swift 版本的 ViewController 因为循环引用无法释放

**解决方案**：
```swift
// ✅ 正确：弱引用 self
model.$todaySteps
    .sink { [weak self] value in
        self?.updateUI(value)
    }
    .store(in: &cancellables)
```

**验证**：
- [ ] 所有 Combine 订阅都使用 [weak self]
- [ ] 使用 Instruments 检测内存泄漏
- [ ] ViewController 释放时 cancellables 也释放

### ❌ 陷阱 6：Feature Flag 控制不当导致版本混乱

**问题**：同一用户在不同时间看到不同版本的 UI

**解决方案**：
```swift
// ✅ 正确：基于用户 ID 的哈希值确保一致性
func shouldUseSwiftVersion(for module: String) -> Bool {
    let userID = getCurrentUserID()
    let hash = userID.hashValue % 100
    return hash < swiftVersionPercentage
}
```

**验证**：
- [ ] 同一用户在应用重启后版本一致
- [ ] 灰度发布百分比正确
- [ ] 没有出现混合版本的情况

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

### 第 2 阶段完成标准（模块转换）

✅ 所有 5 个模块 Swift 版本完成
✅ 功能对标 100% 通过
✅ 单元测试覆盖率 > 80%
✅ 无编译错误和警告
✅ 代码审查通过

### 第 3 阶段完成标准（稳定期）

✅ 灰度发布 100% 完成
✅ 崩溃率 < 0.05%
✅ 性能指标达标（±15%）
✅ 用户反馈良好（投诉 < 5 条）
✅ 没有发现重大 Bug

### 第 4 阶段完成标准（完全迁移）

✅ 所有 OC 代码已删除
✅ Bridging Header 已删除
✅ 最终验证通过
✅ 文档已更新
✅ 团队培训完成

**优化说明**：
- 分阶段验收标准，清晰明确
- 每个阶段都有明确的 Go/No-Go 条件
- 避免功能遗漏和无缝迁移失败

---

## 快速启动清单

### 迁移前准备（必须完成）

- [ ] 确认团队成员已学习 Swift 基础
- [ ] 创建 `oc-backup` 分支作为回滚点
- [ ] 配置 Bridging Header
- [ ] 设置 SwiftLint 规则
- [ ] 第一个模块（Profile）开发者已准备好
- [ ] Code Review 流程已确认
- [ ] **创建功能对标清单**（5 个模块）
- [ ] **建立性能基准**（OC 版本的关键指标）
- [ ] **准备灰度发布工具**（Firebase 或其他）
- [ ] **实现 Feature Flag 系统**（版本控制）
- [ ] **准备数据验证工具**（数据一致性检查）

### 转换前最终检查（必须 100% 通过）

```
代码准备
  ☐ Bridging Header 配置完成
  ☐ Feature Flag 系统实现完成
  ☐ 数据验证工具实现完成
  ☐ 所有 OC 代码编译通过
  ☐ 没有编译警告

功能对标
  ☐ 5 个模块的功能对标清单已创建
  ☐ 每个功能点都有测试用例
  ☐ 性能基准已建立
  ☐ OC 版本所有功能正常

团队准备
  ☐ 所有开发者已学习 Swift 基础
  ☐ 所有开发者已学习 MVVM 架构
  ☐ 所有开发者已学习 Combine 绑定
  ☐ Code Review 流程已确认
  ☐ 灰度发布流程已确认

工具准备
  ☐ SwiftLint 已配置
  ☐ XCTest 已配置
  ☐ Instruments 已准备
  ☐ Firebase 灰度发布已配置
  ☐ 数据验证脚本已准备
```

### 迁移中监控（每日检查）

- [ ] 编译是否通过
- [ ] 单元测试是否通过
- [ ] 代码审查是否通过
- [ ] 功能对标是否通过
- [ ] 性能指标是否达标
- [ ] Feature Flag 是否正确工作

### 灰度发布监控（每 4 小时检查）

- [ ] 崩溃率是否 < 0.05%
- [ ] 性能是否 ±15%
- [ ] 用户反馈是否良好
- [ ] 数据一致性是否 100%
- [ ] 是否需要回滚

**现在可以开始迁移了！** 🚀
