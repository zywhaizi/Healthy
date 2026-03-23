# Swift 迁移 - 文件结构指南

## 📁 推荐的文件结构

保持原有的目录结构，不要移动文件：

```
HealthDashboard/
├── Controllers/
│   ├── HDProfileViewController.swift      ✅ Swift 版本
│   ├── HDProfileViewController.h          ✅ OC 头文件
│   ├── HDProfileViewController.m          ✅ OC 实现
│   ├── HDTabBarController.h
│   ├── HDTabBarController.m
│   ├── HDQuickAddViewController.h
│   ├── HDQuickAddViewController.m
│   ├── HDDashboardViewController.h
│   ├── HDDashboardViewController.m
│   ├── HDExerciseTypeViewController.h
│   ├── HDExerciseTypeViewController.m
│   ├── HealthDashboard-Bridging-Header.h  ✅ Bridging Header
│   └── ... (其他 OC 文件)
│
├── ViewModels/
│   ├── HDProfileViewModel.swift           ✅ Swift ViewModel
│   └── ... (其他 ViewModel)
│
├── Models/
│   ├── HDHealthDataModel.h
│   ├── HDHealthDataModel.m
│   ├── HDMoodRecord.h
│   ├── HDMoodRecord.m
│   ├── HDExerciseRecord.h
│   ├── HDExerciseRecord.m
│   └── ... (其他 Model 文件)
│
├── Views/
│   ├── HDRingProgressView.h
│   ├── HDRingProgressView.m
│   ├── HDWaterView.h
│   ├── HDWaterView.m
│   └── ... (其他 View 文件)
│
└── ... (其他目录)
```

## 🔑 关键原则

### 1. 不移动文件
- ✅ ViewModel 保持在 ViewModels 目录
- ✅ ViewController 保持在 Controllers 目录
- ✅ Model 保持在 Models 目录
- ✅ View 保持在 Views 目录

### 2. 跨目录导入
- ✅ Xcode 会自动链接同一 target 中的文件
- ✅ 无需显式导入路径
- ✅ 直接使用类名即可

```swift
// ✅ 正确：直接使用类名
let viewModel = HDProfileViewModel()

// ❌ 错误：不要尝试显式导入
// import ../ViewModels/HDProfileViewModel
```

### 3. Target Membership 配置
- ✅ 所有 Swift 文件都要勾选 HealthDashboard target
- ✅ 所有 OC 文件都要勾选 HealthDashboard target
- ✅ Bridging Header 要勾选 HealthDashboard target

**验证步骤**：
1. 在 Xcode 中选择文件
2. 打开 File Inspector（右侧面板）
3. 检查 Target Membership 部分
4. 确保 HealthDashboard 被勾选

## 🔧 编译问题排除

### 问题：找不到 ViewModel

**原因**：Target Membership 配置不正确

**解决方案**：
1. 选择 HDProfileViewModel.swift
2. 打开 File Inspector
3. 在 Target Membership 中勾选 HealthDashboard
4. 清理构建文件夹：`Cmd + Shift + K`
5. 重新编译

### 问题：找不到 Bridging Header

**原因**：Build Settings 配置不正确

**解决方案**：
1. 选择 HealthDashboard target
2. 进入 Build Settings
3. 搜索 "Bridging Header"
4. 确保值为：`HealthDashboard/Controllers/HealthDashboard-Bridging-Header.h`

## ✅ 迁移检查清单

### 文件结构
- [ ] ViewModel 在 ViewModels 目录中
- [ ] ViewController 在 Controllers 目录中
- [ ] Model 在 Models 目录中
- [ ] View 在 Views 目录中

### Target Membership
- [ ] 所有 Swift 文件都勾选了 HealthDashboard target
- [ ] 所有 OC 文件都勾选了 HealthDashboard target
- [ ] Bridging Header 勾选了 HealthDashboard target

### Build Settings
- [ ] Objective-C Bridging Header 配置正确
- [ ] Swift Language Version 设置正确

### 编译验证
- [ ] 清理构建文件夹
- [ ] 编译成功
- [ ] 没有错误和警告

## 🚀 下一步

1. **验证文件结构**
   - 确保所有文件在正确的目录中

2. **检查 Target Membership**
   - 确保所有文件都勾选了正确的 target

3. **编译验证**
   - 清理构建文件夹
   - 重新编译

4. **运行测试**
   - 运行单元测试
   - 在模拟器中测试

---

**关键点**：保持文件结构不变，Xcode 会自动处理跨目录导入。
