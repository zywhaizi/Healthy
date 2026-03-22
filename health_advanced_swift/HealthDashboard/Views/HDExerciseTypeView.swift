//
//  HDExerciseTypeView.swift
//  HealthDashboard - 运动类型选择卡片
//
//  Created by AI Assistant on 2026/3/22.
//

import UIKit

/// 运动类型选择卡片
class HDExerciseTypeView: UIView {

    // MARK: - Properties

    /// 运动类型（0=目标跑, 1=自由跑）
    var exerciseType: Int = 0

    // MARK: - UI

    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let startButton = UIButton(type: .custom)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: - UI Setup

    private func setupUI() {
        layer.cornerRadius = 12
        layer.masksToBounds = true
        backgroundColor = .secondarySystemBackground

        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = .label
        addSubview(titleLabel)

        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 2
        addSubview(descriptionLabel)

        startButton.setTitle("开始", for: .normal)
        startButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        startButton.layer.cornerRadius = 8
        startButton.backgroundColor = .systemBlue
        startButton.setTitleColor(.white, for: .normal)
        addSubview(startButton)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let padding: CGFloat = 16
        let width = bounds.width - padding * 2
        titleLabel.frame = CGRect(x: padding, y: padding, width: width, height: 24)
        descriptionLabel.frame = CGRect(x: padding, y: padding + 28, width: width, height: 40)
        startButton.frame = CGRect(x: padding, y: bounds.height - padding - 44, width: width, height: 44)
    }

    // MARK: - Theme

    @objc func applyTheme() {
        backgroundColor = .secondarySystemBackground
        titleLabel.textColor = .label
        descriptionLabel.textColor = .secondaryLabel
        startButton.backgroundColor = .systemBlue
    }
}
