//
//  HDExerciseSettingViewController.swift
//  HealthDashboard - 目标跑设置
//
//  Created by AI Assistant on 2026/3/22.
//

import UIKit

// MARK: - ViewController

@MainActor
class HDExerciseSettingViewController: UIViewController {

    // MARK: - UI

    private let distanceTitleLabel = UILabel()
    private let distanceTextField = UITextField()
    private let timeTitleLabel = UILabel()
    private let timeTextField = UITextField()
    private let startButton = UIButton(type: .custom)

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
        title = "设置目标"

        let model = HDHealthDataModel.shared()

        distanceTitleLabel.text = "目标距离 (km)"
        distanceTitleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        view.addSubview(distanceTitleLabel)

        distanceTextField.borderStyle = .roundedRect
        distanceTextField.keyboardType = .decimalPad
        distanceTextField.text = "\(model.targetRunDistanceKM)"
        distanceTextField.placeholder = "输入距离"
        view.addSubview(distanceTextField)

        timeTitleLabel.text = "目标时间 (分钟)"
        timeTitleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        view.addSubview(timeTitleLabel)

        timeTextField.borderStyle = .roundedRect
        timeTextField.keyboardType = .numberPad
        timeTextField.text = "\(model.targetRunMinutes)"
        timeTextField.placeholder = "输入时间"
        view.addSubview(timeTextField)

        startButton.setTitle("开始运动", for: .normal)
        startButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        startButton.layer.cornerRadius = 8
        startButton.setTitleColor(.white, for: .normal)
        startButton.addTarget(self, action: #selector(startExercise), for: .touchUpInside)
        view.addSubview(startButton)
    }

    private func layoutUI() {
        let padding: CGFloat = 16
        let width = view.bounds.width - padding * 2
        let topPadding: CGFloat = 100

        distanceTitleLabel.frame = CGRect(x: padding, y: topPadding, width: width, height: 24)
        distanceTextField.frame = CGRect(x: padding, y: topPadding + 28, width: width, height: 44)
        timeTitleLabel.frame = CGRect(x: padding, y: topPadding + 80, width: width, height: 24)
        timeTextField.frame = CGRect(x: padding, y: topPadding + 108, width: width, height: 44)
        startButton.frame = CGRect(x: padding, y: view.bounds.height - padding - 120, width: width, height: 50)
    }

    // MARK: - Actions

    @objc private func startExercise() {
        guard let distanceStr = distanceTextField.text, !distanceStr.isEmpty,
              let timeStr = timeTextField.text, !timeStr.isEmpty else {
            showAlert(message: "请输入距离和时间")
            return
        }

        let distance = Int(distanceStr) ?? 0
        let time = Int(timeStr) ?? 0

        guard distance >= 1, distance <= 50, time >= 1, time <= 180 else {
            showAlert(message: "距离: 1-50km, 时间: 1-180分钟")
            return
        }

        // 保存目标到 Model
        let model = HDHealthDataModel.shared()
        model.targetRunDistanceKM = distance
        model.targetRunMinutes = time

        let vc = HDExerciseTimerViewController()
        vc.exerciseType = 0
        navigationController?.pushViewController(vc, animated: true)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }

    // MARK: - Theme

    @objc func applyTheme() {
        view.backgroundColor = .systemBackground
        distanceTitleLabel.textColor = .label
        timeTitleLabel.textColor = .label
        distanceTextField.backgroundColor = .secondarySystemBackground
        timeTextField.backgroundColor = .secondarySystemBackground
        startButton.backgroundColor = .systemBlue
    }
}
