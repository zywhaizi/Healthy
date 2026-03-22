//
//  HDExerciseTypeViewController.swift
//  HealthDashboard - 运动类型选择
//
//  Created by AI Assistant on 2026/3/22.
//

import UIKit
import Combine

// MARK: - ViewController

@MainActor
class HDExerciseTypeViewController: UIViewController {

    // MARK: - UI

    private let scrollView = UIScrollView()
    private var targetRunView: HDExerciseTypeView!
    private var freeRunView: HDExerciseTypeView!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        applyTheme()
        NotificationCenter.default.addObserver(self, selector: #selector(applyTheme), name: NSNotification.Name("HDThemeDidChange"), object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyTheme()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutUI()
    }

    // MARK: - UI Setup

    private func setupUI() {
        title = "选择运动类型"

        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)

        // 目标跑卡片
        targetRunView = HDExerciseTypeView()
        targetRunView.exerciseType = 0
        targetRunView.titleLabel.text = "🏃 目标跑"
        targetRunView.descriptionLabel.text = "设置距离和时间目标\n开始计时运动"
        targetRunView.startButton.addTarget(self, action: #selector(startTargetRun), for: .touchUpInside)
        scrollView.addSubview(targetRunView)

        // 自由跑卡片
        freeRunView = HDExerciseTypeView()
        freeRunView.exerciseType = 1
        freeRunView.titleLabel.text = "🏃 自由跑"
        freeRunView.descriptionLabel.text = "无目标限制\n尽情享受运动"
        freeRunView.startButton.addTarget(self, action: #selector(startFreeRun), for: .touchUpInside)
        scrollView.addSubview(freeRunView)
    }

    private func layoutUI() {
        let padding: CGFloat = 16
        let width = view.bounds.width - padding * 2

        scrollView.frame = view.bounds
        targetRunView.frame = CGRect(x: padding, y: padding, width: width, height: 180)
        freeRunView.frame = CGRect(x: padding, y: padding * 2 + 180, width: width, height: 180)
        scrollView.contentSize = CGSize(width: view.bounds.width, height: padding * 3 + 360)
    }

    // MARK: - Actions

    @objc private func startTargetRun() {
        let vc = HDExerciseSettingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func startFreeRun() {
        let alert = UIAlertController(title: "自由跑", message: "功能开发中...", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }

    // MARK: - Theme

    @objc func applyTheme() {
        view.backgroundColor = .systemBackground
        targetRunView?.applyTheme()
        freeRunView?.applyTheme()
    }
}
