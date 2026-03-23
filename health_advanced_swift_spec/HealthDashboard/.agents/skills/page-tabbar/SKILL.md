---
name: page-tabbar
description: TabBar 控制器（HDTabBarController）的结构、主题订阅、Tab 配置规范。修改 TabBar 相关代码时自动加载。
---

# page-tabbar · TabBar 知识库

> 当前实现：`Controllers/HDTabBarController.swift`（Swift + Combine）

## Tab 结构（顺序不得变更）

```
Tab 0: HDDashboardViewController      首页仪表盘
Tab 1: HDExerciseTypeViewController   运动模块
Tab 2: HDProfileViewController        个人中心
```

> ⚠️ QuickAdd **不是独立 Tab**，是 Dashboard FAB 弹出的底部弹窗。

## viewDidLoad 必须完成的配置

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    setupTabs()
    applyTabBarStyle()
    // 订阅主题变化（Combine，替代 NSNotification）
    HDHealthDataModel.shared.$isDarkMode
        .receive(on: DispatchQueue.main)
        .sink { [weak self] _ in self?.applyTabBarStyle() }
        .store(in: &cancellables)
}
```

## Tab 初始化标准写法

```swift
private func setupTabs() {
    // Tab 0: 首页
    let dashboard = HDDashboardViewController()
    let dashNav = UINavigationController(rootViewController: dashboard)
    dashNav.isNavigationBarHidden = true
    dashNav.tabBarItem = UITabBarItem(title: "首页", image: UIImage(systemName: "heart.fill"), tag: 0)

    // Tab 1: 运动
    let exercise = HDExerciseTypeViewController()
    let exerciseNav = UINavigationController(rootViewController: exercise)
    exerciseNav.tabBarItem = UITabBarItem(title: "运动", image: UIImage(systemName: "figure.walk"), tag: 1)

    // Tab 2: 个人中心
    let profile = HDProfileViewController()
    let profileNav = UINavigationController(rootViewController: profile)
    profileNav.isNavigationBarHidden = true
    profileNav.tabBarItem = UITabBarItem(title: "我的", image: UIImage(systemName: "person.circle.fill"), tag: 2)

    viewControllers = [dashNav, exerciseNav, profileNav]
}
```

## 主题适配（iOS 15+ UITabBarAppearance）

```swift
private func applyTabBarStyle() {
    if #available(iOS 15, *) {
        let app = UITabBarAppearance()
        app.configureWithOpaqueBackground()
        app.backgroundColor = .systemBackground   // 语义色，自动适配 Dark Mode
        tabBar.standardAppearance = app
        tabBar.scrollEdgeAppearance = app
    } else {
        tabBar.barTintColor = .systemBackground
        tabBar.isTranslucent = false
    }
    tabBar.tintColor = .systemBlue
    tabBar.unselectedItemTintColor = .secondaryLabel
}
```

## 各子 VC 主题刷新机制

各 VC 通过自身订阅 `HDHealthDataModel.shared.$isDarkMode` 响应主题切换，**TabBar 不需要遍历通知子 VC**：

```swift
// 在各 VC 的 viewDidLoad 中
HDHealthDataModel.shared.$isDarkMode
    .receive(on: DispatchQueue.main)
    .sink { [weak self] _ in self?.applyTheme() }
    .store(in: &cancellables)
```

## 禁止事项

- TabBar 不处理业务逻辑，只做 Tab 配置和样式协调
- Tab 顺序/数量变更需人工确认
- 不在 TabBar 中直接操作 `HDHealthDataModel` 数据
- 不使用 NSNotification 监听主题（改用 Combine `$isDarkMode`）

## 常见问题

**Q: 如何给 Tab 设置角标？**

```swift
viewControllers?[0].tabBarItem.badgeValue = "3"
viewControllers?[0].tabBarItem.badgeValue = nil  // 清除
```

**Q: TabBar 样式在 iOS 15 以下怎么处理？**
A: 使用 `#available(iOS 15, *)` 分支，iOS 15 以下用 `barTintColor`。
