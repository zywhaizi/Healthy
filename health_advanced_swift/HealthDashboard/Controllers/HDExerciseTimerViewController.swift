//
//  HDExerciseTimerViewController.swift
//  HealthDashboard - 运动计时
//
//  Created by AI Assistant on 2026/3/22.
//

import UIKit

// MARK: - ViewController

@MainActor
class HDExerciseTimerViewController: UIViewController {

    // MARK: - Properties

    /// 运动类型（0=目标跑, 1=自由跑）
    var exerciseType: Int = 0

    private let timeLabel = UILabel()
    private let distanceLabel = UILabel()
    private let paceLabel = UILabel()
    private let calorieLabel = UILabel()
    private let progressView = UIProgressView()
    private let pauseButton = UIButton(type: .custom)
    private let endButton = UIButton(type: .custom)

    private var timer: Timer?
    private var elapsedSeconds: Int = 0
    private var currentDistance: CGFloat = 0
    private var isRunning: Bool = false

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        applyTheme()
        startTimer()
        NotificationCenter.default.addObserver(self, selector: #selector(applyTheme), name: NSNotification.Name("HDThemeDidChange"), object: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutUI()
    }

    // timer 在 endExercise/togglePause 中已 invalidate，VC 销毁时 Timer 自动释放

    // MARK: - UI Setup

    private func setupUI() {
        title = "运动中"

        timeLabel.text = "00:00:00"
        timeLabel.font = .monospacedDigitSystemFont(ofSize: 48, weight: .bold)
        timeLabel.textAlignment = .center
        view.addSubview(timeLabel)

        distanceLabel.text = "0.0 km"
        distanceLabel.font = .monospacedDigitSystemFont(ofSize: 32, weight: .bold)
        distanceLabel.textColor = .systemBlue
        distanceLabel.textAlignment = .center
        view.addSubview(distanceLabel)

        paceLabel.text = "配速: 0:00 /km"
        paceLabel.font = .systemFont(ofSize: 16)
        paceLabel.textColor = .secondaryLabel
        paceLabel.textAlignment = .center
        view.addSubview(paceLabel)

        calorieLabel.text = "0 kcal"
        calorieLabel.font = .systemFont(ofSize: 16)
        calorieLabel.textColor = .secondaryLabel
        calorieLabel.textAlignment = .center
        view.addSubview(calorieLabel)

        progressView.progressTintColor = .systemBlue
        progressView.trackTintColor = .tertiaryLabel
        view.addSubview(progressView)

        pauseButton.setTitle("暂停", for: .normal)
        pauseButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        pauseButton.layer.cornerRadius = 8
        pauseButton.backgroundColor = .systemOrange
        pauseButton.setTitleColor(.white, for: .normal)
        pauseButton.addTarget(self, action: #selector(togglePause), for: .touchUpInside)
        view.addSubview(pauseButton)

        endButton.setTitle("结束", for: .normal)
        endButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        endButton.layer.cornerRadius = 8
        endButton.backgroundColor = .systemRed
        endButton.setTitleColor(.white, for: .normal)
        endButton.addTarget(self, action: #selector(endExercise), for: .touchUpInside)
        view.addSubview(endButton)
    }

    private func layoutUI() {
        let padding: CGFloat = 16
        let width = view.bounds.width - padding * 2

        timeLabel.frame = CGRect(x: padding, y: 100, width: width, height: 60)
        distanceLabel.frame = CGRect(x: padding, y: 170, width: width, height: 50)
        paceLabel.frame = CGRect(x: padding, y: 230, width: width, height: 24)
        calorieLabel.frame = CGRect(x: padding, y: 260, width: width, height: 24)
        progressView.frame = CGRect(x: padding, y: 300, width: width, height: 4)

        let btnY = view.bounds.height - padding - 120
        let btnW = (width - 16) / 2
        pauseButton.frame = CGRect(x: padding, y: btnY, width: btnW, height: 50)
        endButton.frame = CGRect(x: padding + btnW + 16, y: btnY, width: btnW, height: 50)
    }

    // MARK: - Timer

    private func startTimer() {
        isRunning = true
        elapsedSeconds = 0
        currentDistance = 0
        /// NSTimer 在主线程 RunLoop 上触发，不阻塞主线程
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    @objc private func updateTimer() {
        elapsedSeconds += 1
        currentDistance += 0.01

        // 更新时间
        let h = elapsedSeconds / 3600
        let m = (elapsedSeconds % 3600) / 60
        let s = elapsedSeconds % 60
        timeLabel.text = String(format: "%02d:%02d:%02d", h, m, s)

        // 更新距离
        distanceLabel.text = String(format: "%.1f km", currentDistance)

        // 更新配速
        if currentDistance > 0 {
            let paceMinutes = Double(elapsedSeconds) / 60.0 / Double(currentDistance)
            let paceMin = Int(paceMinutes)
            let paceSec = Int((paceMinutes - Double(paceMin)) * 60)
            paceLabel.text = String(format: "配速: %d:%02d /km", paceMin, paceSec)
        }

        // 更新卡路里（约0.1 kcal/秒）
        calorieLabel.text = "\(Int(Double(elapsedSeconds) * 0.1)) kcal"

        // 更新进度条（仅目标跑）
        if exerciseType == 0 {
            let model = HDHealthDataModel.shared()
            let targetDist = CGFloat(model.targetRunDistanceKM)
            if targetDist > 0 {
                progressView.progress = Float(min(1.0, currentDistance / targetDist))
            }
        }
    }

    // MARK: - Actions

    @objc private func togglePause() {
        if isRunning {
            timer?.invalidate()
            timer = nil
            isRunning = false
            pauseButton.setTitle("继续", for: .normal)
        } else {
            isRunning = true
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            pauseButton.setTitle("暂停", for: .normal)
        }
    }

    @objc private func endExercise() {
        timer?.invalidate()
        timer = nil

        // 构建运动记录
        let record = HDExerciseRecord()
        record.type = exerciseType
        record.durationSeconds = elapsedSeconds
        record.distanceKM = currentDistance
        record.caloriesBurned = Int(Double(elapsedSeconds) * 0.1)
        record.timestamp = Date()

        // 通过 Model 方法保存数据
        HDHealthDataModel.shared().saveExerciseRecord(record)

        // 跳转到总结页
        let vc = HDExerciseSummaryViewController()
        vc.exerciseRecord = record
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - Theme

    @objc func applyTheme() {
        view.backgroundColor = .systemBackground
        timeLabel.textColor = .label
        distanceLabel.textColor = .systemBlue
        paceLabel.textColor = .secondaryLabel
        calorieLabel.textColor = .secondaryLabel
    }
}
