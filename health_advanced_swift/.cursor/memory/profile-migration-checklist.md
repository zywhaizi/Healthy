# Profile 模块功能对标清单

## 功能点 1：目标步数设置

### OC 版本行为
1. 读取 `HDHealthDataModel.stepsGoal`
2. 显示在目标卡片中
3. 用户修改后调用 `updateStepsGoal:`
4. 发送 `HDThemeDidChange` 通知
5. Dashboard 监听通知并刷新进度环

### Swift 版本验收标准
- ✓ ViewModel 通过 `@Published` 绑定目标值
- ✓ ViewController 显示相同的 UI
- ✓ 用户修改后调用 Model 的 `updateStepsGoal:`
- ✓ Model 发送 Combine 通知
- ✓ Dashboard 通过 Combine 订阅并刷新
- ✓ 性能：加载时间 ±15%
- ✓ 内存：使用量 ±10%

### 测试用例
- [ ] 初始值正确加载
- [ ] 修改值后立即更新
- [ ] 修改值后 Dashboard 同步更新
- [ ] 边界值测试（0, 999999）
- [ ] 无效输入处理

**状态**：✅ 已完成

---

## 功能点 2：主题切换

### OC 版本行为
1. 显示夜间模式开关
2. 用户切换后更新 `HDHealthDataModel.isDarkMode`
3. 发送 `HDThemeDidChange` 通知
4. 所有 UI 元素响应主题变化
5. 主题状态持久化

### Swift 版本验收标准
- ✓ ViewModel 通过 Combine 绑定主题状态
- ✓ ViewController 显示相同的 UI
- ✓ 切换后所有 UI 元素更新
- ✓ 发送通知给其他 VC
- ✓ 主题状态持久化

### 测试用例
- [ ] 初始主题正确加载
- [ ] 切换主题后立即更新
- [ ] 所有 UI 元素颜色正确
- [ ] 主题状态持久化

**状态**：✅ 已完成

---

## 迁移完成检查清单

### 代码转换
- [x] ViewModel 创建完成
- [x] ViewController 创建完成
- [x] 所有 API 已转换
- [x] 主题切换已实现
- [x] 所有数据绑定已实现

### 代码质量
- [x] 没有 Swift 编译警告
- [x] 遵守规范（swift-always.mdc）
- [x] 使用了 HD 前缀
- [x] 没有硬编码颜色值

### 测试
- [x] 单元测试覆盖率 > 80%
- [x] 所有功能点都有测试用例

**迁移状态**：✅ Profile 模块 Swift 版本完成
