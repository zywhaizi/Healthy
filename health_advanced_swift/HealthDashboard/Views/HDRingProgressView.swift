//
//  HDRingProgressView.swift
//  HealthDashboard - 环形进度条
//
//  Created by AI Assistant on 2026/3/22.
//

import UIKit

/// 环形进度条，支持动画
class HDRingProgressView: UIView {

    // MARK: - Properties

    var ringColor: UIColor = UIColor(red: 0.22, green: 0.82, blue: 0.55, alpha: 1) {
        didSet { progressLayer.strokeColor = ringColor.cgColor }
    }
    var trackColor: UIColor = UIColor(white: 0.2, alpha: 1) {
        didSet { trackLayer.strokeColor = trackColor.cgColor }
    }
    var lineWidth: CGFloat = 10 {
        didSet {
            trackLayer.lineWidth = lineWidth
            progressLayer.lineWidth = lineWidth
        }
    }
    private(set) var progress: CGFloat = 0

    // MARK: - Layers

    private let trackLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear

        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.lineWidth = lineWidth
        trackLayer.lineCap = .round
        layer.addSublayer(trackLayer)

        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = ringColor.cgColor
        progressLayer.lineWidth = lineWidth
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0
        layer.addSublayer(progressLayer)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = (min(bounds.width, bounds.height) - lineWidth) / 2
        let path = UIBezierPath(
            arcCenter: center, radius: radius,
            startAngle: -.pi / 2, endAngle: 3 * .pi / 2, clockwise: true
        )
        trackLayer.path = path.cgPath
        progressLayer.path = path.cgPath
        trackLayer.lineWidth = lineWidth
        progressLayer.lineWidth = lineWidth
        trackLayer.strokeColor = trackColor.cgColor
        progressLayer.strokeColor = ringColor.cgColor
    }

    // MARK: - Public

    func setProgress(_ progress: CGFloat, animated: Bool) {
        self.progress = max(0, min(1, progress))
        if animated {
            let anim = CABasicAnimation(keyPath: "strokeEnd")
            anim.fromValue = progressLayer.strokeEnd
            anim.toValue = self.progress
            anim.duration = 0.8
            anim.timingFunction = CAMediaTimingFunction(name: .easeOut)
            progressLayer.add(anim, forKey: "progress")
        }
        progressLayer.strokeEnd = self.progress
    }
}
