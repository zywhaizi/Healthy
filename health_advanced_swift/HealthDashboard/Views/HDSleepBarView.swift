//
//  HDSleepBarView.swift
//  HealthDashboard - 睡眠柱状图
//
//  Created by AI Assistant on 2026/3/22.
//

import UIKit

/// 近7天睡眠横向柱状图
class HDSleepBarView: UIView {

    // MARK: - Properties

    var hoursData: [NSNumber] = []

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        reloadData()
    }

    // MARK: - Public

    func reloadData() {
        subviews.forEach { $0.removeFromSuperview() }
        guard !hoursData.isEmpty else { return }

        let count = min(7, hoursData.count)
        let w = bounds.width
        let h = bounds.height
        let barW = (w - 8 * CGFloat(count - 1)) / CGFloat(count)
        let maxH = hoursData.map { $0.floatValue }.max().map { CGFloat($0) } ?? 10
        let safeMaxH = maxH < 1 ? 10 : maxH
        let days = ["一", "二", "三", "四", "五", "六", "日"]
        let startIdx = hoursData.count - count

        for i in 0..<count {
            let hours = CGFloat(hoursData[startIdx + i].floatValue)
            let ratio = hours / safeMaxH
            let barH = max(4, ratio * (h - 20))
            let x = CGFloat(i) * (barW + 8)

            // 柱子
            let bar = UIView(frame: CGRect(x: x, y: h - barH - 16, width: barW, height: barH))
            bar.backgroundColor = UIColor(red: 0.38, green: 0.60, blue: 0.95, alpha: 1)
            bar.layer.cornerRadius = barW / 2
            addSubview(bar)

            // 星期标签
            let lbl = UILabel(frame: CGRect(x: x, y: h - 14, width: barW, height: 14))
            lbl.text = days[i % 7]
            lbl.font = .systemFont(ofSize: 10)
            lbl.textColor = UIColor(white: 0.55, alpha: 1)
            lbl.textAlignment = .center
            addSubview(lbl)
        }
    }
}
