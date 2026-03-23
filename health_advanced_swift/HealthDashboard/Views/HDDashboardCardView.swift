//
//  HDDashboardCardView.swift
//  HealthDashboard - 卡片容器
//
//  Created by zhang, haizi on 2026/3/22.
//

import UIKit

/// 通用卡片容器，圆角阴影
class HDDashboardCardView: UIView {

    // MARK: - Properties

    let titleLabel = UILabel()
    let subtitleLabel = UILabel()

    // MARK: - Init

    init(title: String, iconEmoji: String) {
        super.init(frame: .zero)
        backgroundColor = UIColor(red: 0.12, green: 0.16, blue: 0.24, alpha: 1)
        layer.cornerRadius = 16
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.18
        layer.shadowRadius = 8
        layer.shadowOffset = CGSize(width: 0, height: 2)

        // emoji 图标
        let icon = UILabel(frame: CGRect(x: 16, y: 14, width: 28, height: 28))
        icon.text = iconEmoji
        icon.font = .systemFont(ofSize: 22)
        addSubview(icon)

        // 标题
        titleLabel.frame = CGRect(x: 50, y: 14, width: 200, height: 22)
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        titleLabel.textColor = .white
        addSubview(titleLabel)

        // 副标题
        subtitleLabel.frame = CGRect(x: 50, y: 34, width: 240, height: 18)
        subtitleLabel.font = .systemFont(ofSize: 11)
        subtitleLabel.textColor = UIColor(white: 0.55, alpha: 1)
        addSubview(subtitleLabel)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Public

    func addContentView(_ view: UIView) {
        addSubview(view)
    }
}
