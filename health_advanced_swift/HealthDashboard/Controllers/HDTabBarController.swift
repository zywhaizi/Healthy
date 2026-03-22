//
//  HDTabBarController.swift
//  HealthDashboard - TabBar 控制器
//
//  Created by AI Assistant on 2026/3/22.
//

import UIKit

@MainActor
class HDTabBarController: UITabBarController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        applyTabBarStyle()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(themeChanged),
            name: .hdThemeDidChange,
            object: nil
        )
    }

    nonisolated deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Tab Setup

    private func setupTabs() {
        // Tab 0: 首页
        let dashboard = HDDashboardViewController()
        dashboard.extendedLayoutIncludesOpaqueBars = true
        dashboard.edgesForExtendedLayout = .all
        let dashNav = UINavigationController(rootViewController: dashboard)
        dashNav.isNavigationBarHidden = true
        dashNav.extendedLayoutIncludesOpaqueBars = true
        dashNav.edgesForExtendedLayout = .all
        dashNav.tabBarItem = UITabBarItem(title: "首页", image: UIImage(systemName: "heart.fill"), tag: 0)

        // Tab 1: 运动
        let exercise = HDExerciseTypeViewController()
        let exerciseNav = UINavigationController(rootViewController: exercise)
        exerciseNav.isNavigationBarHidden = false
        exerciseNav.tabBarItem = UITabBarItem(title: "运动", image: UIImage(systemName: "figure.walk"), tag: 1)

        // Tab 2: 个人中心
        let profile = HDProfileViewController()
        let profileNav = UINavigationController(rootViewController: profile)
        profileNav.isNavigationBarHidden = true
        profileNav.tabBarItem = UITabBarItem(title: "我的", image: UIImage(systemName: "person.circle.fill"), tag: 2)

        viewControllers = [dashNav, exerciseNav, profileNav]
    }

    // MARK: - Theme

    private func applyTabBarStyle() {
        let tb = tabBar
        if #available(iOS 15, *) {
            let app = UITabBarAppearance()
            app.configureWithOpaqueBackground()
            app.backgroundColor = .systemBackground
            tb.standardAppearance = app
            tb.scrollEdgeAppearance = app
        } else {
            tb.barTintColor = .systemBackground
            tb.isTranslucent = false
        }
        tb.tintColor = .systemBlue
        tb.unselectedItemTintColor = .secondaryLabel
    }

    @objc private func themeChanged() {
        applyTabBarStyle()
        // 各 VC 通过自己监听 HDThemeDidChange 通知响应主题切换
    }
}
