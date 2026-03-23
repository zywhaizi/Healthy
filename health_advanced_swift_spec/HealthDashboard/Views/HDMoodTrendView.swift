//
//  HDMoodTrendView.swift
//  HealthDashboard - 心情趋势折线图
//
//  Created by zhang, haizi on 2026/3/22.
//

import UIKit

/// 心情趋势折线图
class HDMoodTrendView: UIView {

    // MARK: - Properties

    var records: [HDMoodRecord] = []

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Public

    func reloadData() {
        setNeedsDisplay()
    }

    // MARK: - Drawing

    override func draw(_ rect: CGRect) {
        guard !records.isEmpty else { return }
        let count = min(7, records.count)
        let start = records.count - count
        let w = rect.width
        let h = rect.height
        let stepX = w / CGFloat(max(count - 1, 1))

        // 计算节点坐标
        var points: [CGPoint] = []
        for i in 0..<count {
            let r = records[start + i]
            let x = CGFloat(i) * stepX
            let y = h - (CGFloat(r.moodLevel) / 5.0) * (h - 16) - 8
            points.append(CGPoint(x: x, y: y))
        }

        // 绘制折线
        let linePath = UIBezierPath()
        linePath.lineWidth = 2
        UIColor(red: 0.38, green: 0.75, blue: 0.95, alpha: 1).setStroke()
        for (i, pt) in points.enumerated() {
            if i == 0 { linePath.move(to: pt) }
            else { linePath.addLine(to: pt) }
        }
        linePath.stroke()

        // 绘制节点
        UIColor(red: 0.22, green: 0.54, blue: 0.95, alpha: 1).setFill()
        for (i, pt) in points.enumerated() {
            let dot = UIBezierPath(arcCenter: pt, radius: 4, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
            dot.fill()

            // 最后一个节点显示 emoji
            if i == count - 1 {
                let r = records[start + i]
                let emoji = r.emojiString as NSString
                emoji.draw(at: CGPoint(x: pt.x - 8, y: pt.y - 22),
                           withAttributes: [.font: UIFont.systemFont(ofSize: 16)])
            }
        }
    }
}
