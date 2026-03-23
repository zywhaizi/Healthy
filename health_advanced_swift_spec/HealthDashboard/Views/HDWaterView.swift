//
//  HDWaterView.swift
//  HealthDashboard - 喝水波浪动画
//
//  Created by zhang, haizi on 2026/3/22.
//

import UIKit

/// 水波进度视图
@MainActor
class HDWaterView: UIView {

    // MARK: - Properties

    private var level: CGFloat = 0.3
    private let waveLayer = CAShapeLayer()
    private var displayLink: CADisplayLink?
    private var waveOffset: CGFloat = 0

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        layer.cornerRadius = 8
        backgroundColor = UIColor(red: 0.10, green: 0.18, blue: 0.30, alpha: 1)

        waveLayer.fillColor = UIColor(red: 0.20, green: 0.60, blue: 0.95, alpha: 0.75).cgColor
        layer.addSublayer(waveLayer)

        displayLink = CADisplayLink(target: self, selector: #selector(updateWave))
        displayLink?.add(to: .main, forMode: .common)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    nonisolated deinit {
        // displayLink 会随对象释放自动失效
        // 在 willMove(toWindow:) 中处理生命周期
    }

    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow == nil {
            displayLink?.invalidate()
            displayLink = nil
        }
    }

    // MARK: - Wave Animation

    @objc private func updateWave() {
        waveOffset += 0.03
        drawWave()
    }

    private func drawWave() {
        let w = bounds.width
        let h = bounds.height
        let waterY = h * (1 - level)
        let amplitude: CGFloat = 4.0

        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: waterY))
        for x in stride(from: CGFloat(0), through: w, by: 1) {
            let y = waterY + amplitude * sin((x / w * 2 * .pi) + waveOffset)
            path.addLine(to: CGPoint(x: x, y: y))
        }
        path.addLine(to: CGPoint(x: w, y: h))
        path.addLine(to: CGPoint(x: 0, y: h))
        path.close()
        waveLayer.path = path.cgPath
    }

    // MARK: - Public

    func setWaterLevel(_ level: CGFloat, animated: Bool) {
        self.level = max(0, min(1, level))
    }
}
