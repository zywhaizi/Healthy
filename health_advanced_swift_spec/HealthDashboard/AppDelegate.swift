//
//  AppDelegate.swift
//  HealthDashboard
//
//  Created by zhang, haizi on 2026/3/22.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = HDTabBarController()
        window?.makeKeyAndVisible()
        return true
    }
}
