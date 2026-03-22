//
//  HDExerciseSummaryViewController.swift
//  HealthDashboard - 运动总结
//
//  Created by AI Assistant on 2026/3/22.
//

import UIKit

// MARK: - ViewController

@MainActor
class HDExerciseSummaryViewController: UIViewController {

    // MARK: - Properties

    /// 运动记录（由计时页面传入）
    var exerciseRecord: HDExerciseRecord?

    // MARK: - UI

    private let titleLabel = UILabel()
    private let timeLabel = UILabel()
    private let distanceLabel = UILabel()
    private let paceLabel = UILabel()
    private let calorieLabel = UILabel()
    private let saveButton = UIButton(type: .custom)
    private let cancelButton = UIButton(type: .custom)

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        applyTheme()
        NotificationCenter.default.addObserver(self, selector: #selector(applyTheme), name: NSNotification.Name("HDThemeDidChange"), object: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutUI()
    }

    // MARK: - UI Setup

    private func setupUI() {
        title = "运动总结"

        let record = exerciseRecord

        // 标题
        titleLabel.text = "\u{1F389} \(record?.typeString ?? "运动")完成"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)

        // 时间
        let totalSec = record?.durationSeconds ?? 0
        let h = totalSec / 3600
        let m = (totalSec % 3600) / 60
        let s = totalSec % 60
        timeLabel.text = String(format: "\u{23F1} 时间: %02d:%02d:%02d", h, m, s)
        timeLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        view.addSubview(timeLabel)

        // 距离
        let dist = record?.distanceKM ?? 0
        distanceLabel.text = String(format: "\u{1F4CD} 距离: %.1f km", dist)
        distanceLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        distanceLabel.textColor = .systemBlue
        view.addSubview(distanceLabel)

        // 配速
        var paceText = "\u{1F3C3} 配速: --"
        if dist > 0 {
            let paceMinutes = Double(totalSec) / 60.0 / Double(dist)
            let paceMin = Int(paceMinutes)
            let paceSec = Int((paceMinutes - Double(paceMin)) * 60)
            paceText = String(format: "\u{1F3C3} 配速: %d:%02d /km", paceMin, paceSec)
        }
        paceLabel.text = paceText
        paceLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        view.addSubview(paceLabel)

        // 卡路里
        calorieLabel.text = "\u{1F525} 卡路里: \(record?.caloriesBurned ?? 0) kcal"
        calorieLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        calorieLabel.textColor = .systemOrange
        view.addSubview(calorieLabel)

        // 保存按钮
        saveButton.setTitle("保存", for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        saveButton.layer.cornerRadius = 8
        saveButton.backgroundColor = .systemGreen
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.addTarget(self, action: #selector(saveExercise), for: .touchUpInside)
        view.addSubview(saveButton)

        // 放弃按钮
        cancelButton.setTitle("放弃", for: .normal)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        cancelButton.layer.cornerRadius = 8
        cancelButton.backgroundColor = .systemRed
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelExercise), for: .touchUpInside)
        view.addSubview(cancelButton)
    }

    private func layoutUI() {
        let padding: CGFloat = 16
        let width = view.bounds.width - padding * 2

        titleLabel.frame = CGRect(x: padding, y: 100, width: width, height: 40)
        timeLabel.frame = CGRect(x: padding, y: 150, width: width, height: 30)
        distanceLabel.frame = CGRect(x: padding, y: 190, width: width, height: 30)
        paceLabel.frame = CGRect(x: padding, y: 230, width: width, height: 30)
        calorieLabel.frame = CGRect(x: padding, y: 270, width: width, height: 30)

        let btnY = view.bounds.height - padding - 120
        let btnW = (width - 16) / 2
        saveButton.frame = CGRect(x: padding, y: btnY, width: btnW, height: 50)
        cancelButton.frame = CGRect(x: padding + btnW + 16, y: btnY, width: btnW, height: 50)
    }

    // MARK: - Actions

    @objc private func saveExercise() {
        // 数据已在计时页面保存到 Model，此处直接返回根页面
        navigationController?.popToRootViewController(animated: true)
    }

    @objc private func cancelExercise() {
        navigationController?.popToRootViewController(animated: true)
    }

    // MARK: - Theme

    @objc func applyTheme() {
        view.backgroundColor = .systemBackground
        titleLabel.textColor = .label
        timeLabel.textColor = .label
        distanceLabel.textColor = .systemBlue
        paceLabel.textColor = .label
        calorieLabel.textColor = .systemOrange
    }
}
