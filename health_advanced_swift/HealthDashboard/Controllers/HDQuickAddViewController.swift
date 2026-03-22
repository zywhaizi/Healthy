//
//  HDQuickAddViewController.swift
//  HealthDashboard - 快速录入底部弹窗
//
//  Created by AI Assistant on 2026/3/22.
//

import UIKit
import Combine

// MARK: - Protocol

/// QuickAdd 录入完成后通知 Dashboard 刷新
@MainActor protocol HDQuickAddDelegate: AnyObject {
    func quickAddDidUpdateData()
}

// MARK: - ViewModel

@MainActor
class HDQuickAddViewModel: ObservableObject {
    @Published var stepsValue: Int = 2000
    @Published var stepsDisplayText: String = "2000步"

    private let model = HDHealthDataModel.shared

    /// 更新步数显示文字（步数 + 卡路里）
    func updateStepsDisplay(_ steps: Int) {
        stepsValue = steps
        let cal = model.calory(forSteps: steps)
        stepsDisplayText = String(format: "%d步 %.0f卡", steps, cal)
    }

    /// 写入喝水数据
    func addWater() {
        model.addWater(200)
    }

    /// 写入步数数据
    func addSteps() {
        model.addSteps(stepsValue)
    }

    /// 写入心情数据
    func addMood(_ level: Int) {
        model.addMood(level)
    }
}

// MARK: - ViewController

class HDQuickAddViewController: UIViewController {

    // MARK: - Properties

    /// delegate 必须 weak，防止循环引用
    weak var delegate: HDQuickAddDelegate?

    private let viewModel = HDQuickAddViewModel()
    private var cancellables = Set<AnyCancellable>()

    // MARK: - UI

    private let sheetView = UIView()
    private let stepsSlider = UISlider()
    private let stepsValueLabel = UILabel()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        buildSheet()
        setupBindings()

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissSheet))
        view.addGestureRecognizer(tap)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 弹出动画
        UIView.animate(
            withDuration: 0.35,
            delay: 0,
            usingSpringWithDamping: 0.85,
            initialSpringVelocity: 0.5,
            options: [],
            animations: { self.sheetView.transform = .identity },
            completion: nil
        )
    }

    /// applyTheme：主题由 buildSheet 构建时读取，此处保留为扩展点
    @objc func applyTheme() {
        // sheet 背景色在 buildSheet 中已根据 isDarkMode 设置
        // 如需动态切换可在此刷新
    }

    // MARK: - UI 构建

    private func buildSheet() {
        let sw = view.bounds.size.width
        let sh = view.bounds.size.height
        let sheetH: CGFloat = 380
        let dark = HDHealthDataModel.shared.isDarkMode
        let textC: UIColor = dark ? .white : UIColor(red: 0.1, green: 0.12, blue: 0.18, alpha: 1)

        sheetView.frame = CGRect(x: 0, y: sh - sheetH, width: sw, height: sheetH)
        sheetView.backgroundColor = dark
            ? UIColor(red: 0.10, green: 0.13, blue: 0.20, alpha: 1)
            : .white
        sheetView.layer.cornerRadius = 20
        sheetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        sheetView.transform = CGAffineTransform(translationX: 0, y: sheetH)
        view.addSubview(sheetView)

        // 阻止点击穿透
        let sheetTap = UITapGestureRecognizer()
        sheetView.addGestureRecognizer(sheetTap)

        // 标题
        let titleLbl = UILabel(frame: CGRect(x: 20, y: 20, width: sw - 40, height: 28))
        titleLbl.text = "快速录入"
        titleLbl.font = .systemFont(ofSize: 20, weight: .bold)
        titleLbl.textColor = textC
        sheetView.addSubview(titleLbl)

        // 关闭按钮
        let closeBtn = UIButton(type: .system)
        closeBtn.frame = CGRect(x: sw - 56, y: 16, width: 36, height: 36)
        closeBtn.setTitle("✕", for: .normal)
        closeBtn.titleLabel?.font = .systemFont(ofSize: 18)
        closeBtn.setTitleColor(UIColor(white: 0.5, alpha: 1), for: .normal)
        closeBtn.addTarget(self, action: #selector(dismissSheet), for: .touchUpInside)
        sheetView.addSubview(closeBtn)

        // 喝水按钮
        addSheetButton(
            title: "💧  喝一杯水 +200ml",
            y: 68,
            color: UIColor(red: 0.20, green: 0.55, blue: 0.95, alpha: 1),
            action: #selector(addWaterTapped)
        )

        // 步数标题
        let stepsTitleLbl = UILabel(frame: CGRect(x: 20, y: 138, width: sw - 40, height: 22))
        stepsTitleLbl.text = "👟  记录步数"
        stepsTitleLbl.font = .systemFont(ofSize: 15, weight: .semibold)
        stepsTitleLbl.textColor = textC
        sheetView.addSubview(stepsTitleLbl)

        // 步数滑块
        stepsSlider.frame = CGRect(x: 20, y: 168, width: sw - 40 - 120, height: 30)
        stepsSlider.minimumValue = 500
        stepsSlider.maximumValue = 10000
        stepsSlider.value = 2000
        stepsSlider.tintColor = UIColor(red: 0.22, green: 0.82, blue: 0.55, alpha: 1)
        stepsSlider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        sheetView.addSubview(stepsSlider)

        // 步数数值标签
        stepsValueLabel.frame = CGRect(x: sw - 130, y: 162, width: 110, height: 30)
        stepsValueLabel.font = .monospacedDigitSystemFont(ofSize: 14, weight: .semibold)
        stepsValueLabel.textColor = textC
        stepsValueLabel.textAlignment = .right
        sheetView.addSubview(stepsValueLabel)

        // 确认步数按钮
        let stepsBtn = makeButton(
            title: "确认步数",
            color: UIColor(red: 0.22, green: 0.82, blue: 0.55, alpha: 1)
        )
        stepsBtn.frame = CGRect(x: 20, y: 210, width: sw - 40, height: 44)
        stepsBtn.addTarget(self, action: #selector(addStepsTapped), for: .touchUpInside)
        sheetView.addSubview(stepsBtn)

        // 心情标题
        let moodTitleLbl = UILabel(frame: CGRect(x: 20, y: 272, width: sw - 40, height: 22))
        moodTitleLbl.text = "🌟  心情打卡"
        moodTitleLbl.font = .systemFont(ofSize: 15, weight: .semibold)
        moodTitleLbl.textColor = textC
        sheetView.addSubview(moodTitleLbl)

        // 心情 emoji 按钮
        let emojis = ["😞", "😕", "😐", "😊", "😄"]
        let emojiW = (sw - 40) / 5.0
        for (i, emoji) in emojis.enumerated() {
            let btn = UIButton(type: .custom)
            btn.frame = CGRect(x: 20 + CGFloat(i) * emojiW, y: 302, width: emojiW, height: 44)
            btn.setTitle(emoji, for: .normal)
            btn.titleLabel?.font = .systemFont(ofSize: 28)
            btn.tag = 100 + i + 1  // tag 101~105 对应 moodLevel 1~5
            btn.addTarget(self, action: #selector(moodTapped(_:)), for: .touchUpInside)
            sheetView.addSubview(btn)
        }

        // 初始化步数显示
        viewModel.updateStepsDisplay(2000)
    }

    // MARK: - Combine 绑定

    private func setupBindings() {
        viewModel.$stepsDisplayText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.stepsValueLabel.text = text
            }
            .store(in: &cancellables)
    }

    // MARK: - 辅助方法

    private func addSheetButton(title: String, y: CGFloat, color: UIColor, action: Selector) {
        let btn = makeButton(title: title, color: color)
        btn.frame = CGRect(x: 20, y: y, width: view.bounds.width - 40, height: 52)
        btn.addTarget(self, action: action, for: .touchUpInside)
        sheetView.addSubview(btn)
    }

    private func makeButton(title: String, color: UIColor) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = color
        btn.layer.cornerRadius = 12
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }

    // MARK: - Actions

    @objc private func sliderChanged() {
        let steps = Int(stepsSlider.value)
        viewModel.updateStepsDisplay(steps)
    }

    @objc private func addWaterTapped() {
        viewModel.addWater()
        performDismiss()
    }

    @objc private func addStepsTapped() {
        viewModel.addSteps()
        performDismiss()
    }

    @objc private func moodTapped(_ sender: UIButton) {
        let level = sender.tag - 100  // 1~5
        viewModel.addMood(level)
        performDismiss()
    }

    @objc private func dismissSheet() {
        performDismiss()
    }

    /// 收起动画 → 调用 delegate → dismiss
    private func performDismiss() {
        UIView.animate(withDuration: 0.25, animations: {
            self.sheetView.transform = CGAffineTransform(translationX: 0, y: 400)
            self.view.backgroundColor = .clear
        }, completion: { _ in
            // 必须在 dismiss 前调用 delegate
            self.delegate?.quickAddDidUpdateData()
            self.dismiss(animated: false, completion: nil)
        })
    }
}
