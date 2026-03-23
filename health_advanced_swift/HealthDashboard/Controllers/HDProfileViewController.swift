//
//  HDProfileViewController.swift
//  HealthDashboard - 个人中心
//
//  Created by AI Assistant on 2026/3/22.
//

import UIKit
import Combine

// MARK: - ViewModel
// 简化版 ViewModel，只负责存储 UI 状态，不访问 Model

@MainActor
class HDProfileViewModel: ObservableObject {
    @Published var todayStepsText: String = "0"
    @Published var waterMLText: String = "0ml"
    @Published var sleepHoursText: String = "0h"
    
    @Published var stepsGoalText: String = "10000"
    @Published var waterGoalText: String = "2000"
    
    @Published var isDarkMode: Bool = false
    @Published var backgroundColor: UIColor = .white
    @Published var cardBackgroundColor: UIColor = .white
    @Published var textColor: UIColor = .black
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // 空初始化，数据由 ViewController 设置
    }
    
    func updateThemeColors() {
        let dark = isDarkMode
        backgroundColor = dark ? UIColor(red: 0.06, green: 0.08, blue: 0.14, alpha: 1.0)
                               : UIColor(red: 0.93, green: 0.95, blue: 0.97, alpha: 1.0)
        cardBackgroundColor = dark ? UIColor(red: 0.12, green: 0.16, blue: 0.24, alpha: 1.0)
                                   : UIColor.white
        textColor = dark ? UIColor.white
                        : UIColor(red: 0.10, green: 0.12, blue: 0.18, alpha: 1.0)
    }
}

// MARK: - ViewController

@MainActor
class HDProfileViewController: UIViewController {
    private let viewModel = HDProfileViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let themeSwitch = UISwitch()
    
    // UI 标签引用
    private var titleLabel: UILabel?
    private var nameLabel: UILabel?
    private var themeCard: UIView?
    private var themeLbl: UILabel?
    private var goalCard: UIView?
    private var goalTitle: UILabel?
    private var statLabels: [UILabel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        buildContent()
        setupBindings()
        applyTheme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        applyTheme()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
    }
    
    // MARK: - UI Setup
    
    private func setupScrollView() {
        let sw = UIScreen.main.bounds.size.width
        let sh = UIScreen.main.bounds.size.height
        
        scrollView.frame = CGRect(x: 0, y: 0, width: sw, height: sh)
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        
        contentView.frame = CGRect(x: 0, y: 0, width: sw, height: 600)
        scrollView.addSubview(contentView)
        scrollView.contentSize = CGSize(width: sw, height: 600)
    }
    
    private func buildContent() {
        let sw = view.bounds.size.width
        let topY: CGFloat = 60
        
        // 页面标题
        let title = UILabel(frame: CGRect(x: 20, y: topY, width: sw - 40, height: 40))
        title.text = "个人中心"
        title.font = UIFont.systemFont(ofSize: 28, weight: .heavy)
        title.textColor = .white
        contentView.addSubview(title)
        titleLabel = title
        
        // 头像
        let avatar = UIView(frame: CGRect(x: sw/2 - 44, y: topY + 58, width: 88, height: 88))
        avatar.backgroundColor = UIColor(red: 0.22, green: 0.54, blue: 0.95, alpha: 1)
        avatar.layer.cornerRadius = 44
        contentView.addSubview(avatar)
        
        let avatarEmoji = UILabel(frame: avatar.bounds)
        avatarEmoji.text = "😊"
        avatarEmoji.font = UIFont.systemFont(ofSize: 44)
        avatarEmoji.textAlignment = .center
        avatar.addSubview(avatarEmoji)
        
        // 用户名
        let name = UILabel(frame: CGRect(x: 20, y: topY + 158, width: sw - 40, height: 28))
        name.text = "健康达人"
        name.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        name.textColor = .white
        name.textAlignment = .center
        contentView.addSubview(name)
        nameLabel = name
        
        // 统计行
        let statTitles = ["今日步数", "喝水", "睡眠"]
        let itemW = sw / 3.0
        let statsY = topY + 200
        
        for i in 0..<3 {
            let val = UILabel(frame: CGRect(x: CGFloat(i) * itemW, y: statsY, width: itemW, height: 32))
            val.font = UIFont.monospacedDigitSystemFont(ofSize: 20, weight: .bold)
            val.textColor = UIColor(red: 0.22, green: 0.54, blue: 0.95, alpha: 1)
            val.textAlignment = .center
            contentView.addSubview(val)
            statLabels.append(val)
            
            let lbl = UILabel(frame: CGRect(x: CGFloat(i) * itemW, y: statsY + 34, width: itemW, height: 18))
            lbl.text = statTitles[i]
            lbl.font = UIFont.systemFont(ofSize: 12)
            lbl.textColor = UIColor(white: 0.55, alpha: 1)
            lbl.textAlignment = .center
            contentView.addSubview(lbl)
        }
        
        // 夜间模式卡片
        let themeY = statsY + 72
        let themeCardView = UIView(frame: CGRect(x: 16, y: themeY, width: sw - 32, height: 64))
        themeCardView.backgroundColor = UIColor(red: 0.12, green: 0.16, blue: 0.24, alpha: 1)
        themeCardView.layer.cornerRadius = 16
        contentView.addSubview(themeCardView)
        themeCard = themeCardView
        
        let themeLblView = UILabel(frame: CGRect(x: 16, y: 18, width: sw - 100, height: 28))
        themeLblView.text = "🌙  夜间模式"
        themeLblView.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        themeLblView.textColor = .white
        themeCardView.addSubview(themeLblView)
        themeLbl = themeLblView
        
        themeSwitch.frame = CGRect(x: sw - 32 - 70, y: 16, width: 51, height: 31)
        themeSwitch.onTintColor = UIColor(red: 0.22, green: 0.54, blue: 0.95, alpha: 1)
        themeSwitch.addTarget(self, action: #selector(themeSwitchChanged), for: .valueChanged)
        themeCardView.addSubview(themeSwitch)
        
        // 目标卡片
        let goalY = themeY + 80
        let goalCardView = UIView(frame: CGRect(x: 16, y: goalY, width: sw - 32, height: 120))
        goalCardView.backgroundColor = UIColor(red: 0.12, green: 0.16, blue: 0.24, alpha: 1)
        goalCardView.layer.cornerRadius = 16
        contentView.addSubview(goalCardView)
        goalCard = goalCardView
        
        let goalTitleView = UILabel(frame: CGRect(x: 16, y: 14, width: sw - 64, height: 22))
        goalTitleView.text = "🎯  我的目标"
        goalTitleView.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        goalTitleView.textColor = .white
        goalCardView.addSubview(goalTitleView)
        goalTitle = goalTitleView
        
        // 目标内容（动态绑定）
        let goalLabel1 = UILabel(frame: CGRect(x: 16, y: 44, width: sw - 64, height: 24))
        goalLabel1.font = UIFont.systemFont(ofSize: 14)
        goalLabel1.textColor = UIColor(white: 0.70, alpha: 1)
        goalCardView.addSubview(goalLabel1)
        
        let goalLabel2 = UILabel(frame: CGRect(x: 16, y: 76, width: sw - 64, height: 24))
        goalLabel2.font = UIFont.systemFont(ofSize: 14)
        goalLabel2.textColor = UIColor(white: 0.70, alpha: 1)
        goalCardView.addSubview(goalLabel2)
        
        // 绑定目标标签
        viewModel.$stepsGoalText
            .map { "每日步数：\($0) 步" }
            .receive(on: DispatchQueue.main)
            .sink { [weak goalLabel1] text in
                goalLabel1?.text = text
            }
            .store(in: &cancellables)
        
        viewModel.$waterGoalText
            .map { "每日喝水：\($0) ml" }
            .receive(on: DispatchQueue.main)
            .sink { [weak goalLabel2] text in
                goalLabel2?.text = text
            }
            .store(in: &cancellables)
    }
    
    private func setupBindings() {
        // 从 Model 读取初始数据
        refreshData()

        // 绑定统计数据到 UI
        viewModel.$todayStepsText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in self?.statLabels[safe: 0]?.text = text }
            .store(in: &cancellables)

        viewModel.$waterMLText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in self?.statLabels[safe: 1]?.text = text }
            .store(in: &cancellables)

        viewModel.$sleepHoursText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in self?.statLabels[safe: 2]?.text = text }
            .store(in: &cancellables)

        // 绑定主题开关状态
        viewModel.$isDarkMode
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isDark in self?.themeSwitch.isOn = isDark }
            .store(in: &cancellables)

        // 订阅 Model @Published 属性替代通知
        Publishers.MergeMany(
            HDHealthDataModel.shared.$todaySteps.map { _ in () }.eraseToAnyPublisher(),
            HDHealthDataModel.shared.$waterML.map { _ in () }.eraseToAnyPublisher(),
            HDHealthDataModel.shared.$sleepHours.map { _ in () }.eraseToAnyPublisher()
        )
        .debounce(for: .milliseconds(50), scheduler: DispatchQueue.main)
        .sink { [weak self] in self?.refreshData() }
        .store(in: &cancellables)

        HDHealthDataModel.shared.$isDarkMode
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.refreshData()
                self?.applyTheme()
            }
            .store(in: &cancellables)

        refreshData()
    }

    private func refreshData() {
        let model = HDHealthDataModel.shared
        viewModel.todayStepsText = "\(model.todaySteps)"
        viewModel.waterMLText = String(format: "%.0fml", model.waterML)
        viewModel.sleepHoursText = String(format: "%.1fh", model.sleepHours.last ?? 0)
        viewModel.stepsGoalText = "\(model.stepsGoal)"
        viewModel.waterGoalText = String(format: "%.0f", model.waterGoalML)
        viewModel.isDarkMode = model.isDarkMode
        viewModel.updateThemeColors()
    }
    
    // MARK: - 主题切换
    
    @objc private func themeSwitchChanged() {
        HDHealthDataModel.shared.isDarkMode.toggle()
        applyTheme()
    }
    
    @objc func applyTheme() {
        view.backgroundColor = viewModel.backgroundColor
        scrollView.backgroundColor = viewModel.backgroundColor
        contentView.backgroundColor = viewModel.backgroundColor
        
        titleLabel?.textColor = viewModel.textColor
        nameLabel?.textColor = viewModel.textColor
        
        themeCard?.backgroundColor = viewModel.cardBackgroundColor
        themeLbl?.textColor = viewModel.textColor
        
        goalCard?.backgroundColor = viewModel.cardBackgroundColor
        goalTitle?.textColor = viewModel.textColor
    }
}

// MARK: - Array Safe Access Extension

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
