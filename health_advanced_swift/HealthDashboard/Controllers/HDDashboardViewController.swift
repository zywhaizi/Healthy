//
//  HDDashboardViewController.swift
//  HealthDashboard - 首页仪表盘
//
//  Created by AI Assistant on 2026/3/22.
//

import UIKit
import Combine

// MARK: - ViewModel

@MainActor
class HDDashboardViewModel: ObservableObject {
    @Published var stepsText: String = "0"
    @Published var stepsSubText: String = "目标10000步 · 消耗0千卡"
    @Published var stepsProgress: CGFloat = 0
    @Published var stepsProgressPct: String = "0%"
    @Published var waterProgress: CGFloat = 0
    @Published var waterText: String = "0/2000ml"
    @Published var waterSubText: String = "已喝 0 ml"
    @Published var sleepHours: [Double] = []
    @Published var sleepSubText: String = "昨晚 0.0 小时"
    @Published var moodRecords: [HDMoodRecord] = []
    @Published var moodSubText: String = "今天还没记录心情"

    private let model = HDHealthDataModel.shared
    private var cancellables = Set<AnyCancellable>()

    init() {
        refreshData()
        setupModelBindings()
    }

    /// 订阅 Model @Published 属性，数据变化自动刷新
    private func setupModelBindings() {
        Publishers.MergeMany(
            model.$todaySteps.map { _ in () }.eraseToAnyPublisher(),
            model.$waterML.map { _ in () }.eraseToAnyPublisher(),
            model.$sleepHours.map { _ in () }.eraseToAnyPublisher(),
            model.$moodRecords.map { _ in () }.eraseToAnyPublisher()
        )
        .debounce(for: .milliseconds(50), scheduler: DispatchQueue.main)
        .sink { [weak self] in self?.refreshData() }
        .store(in: &cancellables)
    }

    /// 从 Model 读取所有数据，更新 @Published 属性
    func refreshData() {
        let m = model
        stepsText = "\(m.todaySteps)"
        let cal = m.calory(forSteps: m.todaySteps)
        stepsSubText = String(format: "目标%d步 · 消耗%.0f千卡", m.stepsGoal, cal)
        stepsProgress = m.stepsProgress
        stepsProgressPct = String(format: "%.0f%%", m.stepsProgress * 100)
        waterProgress = m.waterProgress
        waterText = String(format: "%.0f/%.0fml", m.waterML, m.waterGoalML)
        waterSubText = String(format: "已喝 %.0f ml", m.waterML)
        sleepHours = m.sleepHours
        sleepSubText = String(format: "昨晚 %.1f 小时", m.sleepHours.last ?? 0)
        moodRecords = m.moodRecords
        moodSubText = m.latestMood.map { "最新: \($0.emojiString)" } ?? "今天还没记录心情"
    }
}

// MARK: - ViewController

@MainActor
class HDDashboardViewController: UIViewController {

    // MARK: - Properties
    private let viewModel = HDDashboardViewModel()
    private var cancellables = Set<AnyCancellable>()

    // MARK: - UI
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var fabButton = UIButton(type: .custom)
    private var stepsCard: HDDashboardCardView!
    private var waterCard: HDDashboardCardView!
    private var sleepCard: HDDashboardCardView!
    private var moodCard: HDDashboardCardView!
    private var ringView: HDRingProgressView!
    private var stepsLabel = UILabel()
    private var stepsSubLabel = UILabel()
    private var pctLabel = UILabel()
    private var waterWave: HDWaterView!
    private var waterLabel = UILabel()
    private var sleepBar: HDSleepBarView!
    private var moodTrend: HDMoodTrendView!
    private weak var headerTitleLabel: UILabel?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        extendedLayoutIncludesOpaqueBars = true
        edgesForExtendedLayout = .all
        view.backgroundColor = UIColor(red: 0.06, green: 0.08, blue: 0.14, alpha: 1)
        setupScrollView()
        buildHeader()
        buildStepsCard()
        buildWaterCard()
        buildSleepCard()
        buildMoodCard()
        buildFAB()
        setupBindings()
        applyTheme()
        // 订阅主题变化（@Published 替代通知）
        HDHealthDataModel.shared.$isDarkMode
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.applyTheme() }
            .store(in: &cancellables)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        applyTheme()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let sw = view.bounds.width
        let sh = view.bounds.height
        let tabBarH = tabBarController?.tabBar.frame.height ?? 83
        fabButton.frame = CGRect(x: sw - 76, y: sh - tabBarH - 16 - 56, width: 56, height: 56)
    }

    // MARK: - Bindings

    private func setupBindings() {
        viewModel.$stepsText.receive(on: DispatchQueue.main)
            .sink { [weak self] t in self?.stepsLabel.text = t }.store(in: &cancellables)
        viewModel.$stepsSubText.receive(on: DispatchQueue.main)
            .sink { [weak self] t in self?.stepsSubLabel.text = t }.store(in: &cancellables)
        viewModel.$stepsProgress.receive(on: DispatchQueue.main)
            .sink { [weak self] p in self?.ringView.setProgress(p, animated: true) }.store(in: &cancellables)
        viewModel.$stepsProgressPct.receive(on: DispatchQueue.main)
            .sink { [weak self] t in self?.pctLabel.text = t }.store(in: &cancellables)
        viewModel.$waterProgress.receive(on: DispatchQueue.main)
            .sink { [weak self] p in self?.waterWave.setWaterLevel(p, animated: true) }.store(in: &cancellables)
        viewModel.$waterText.receive(on: DispatchQueue.main)
            .sink { [weak self] t in self?.waterLabel.text = t }.store(in: &cancellables)
        viewModel.$waterSubText.receive(on: DispatchQueue.main)
            .sink { [weak self] t in self?.waterCard.subtitleLabel.text = t }.store(in: &cancellables)
        viewModel.$sleepHours.receive(on: DispatchQueue.main)
            .sink { [weak self] h in self?.sleepBar.hoursData = h; self?.sleepBar.reloadData() }.store(in: &cancellables)
        viewModel.$sleepSubText.receive(on: DispatchQueue.main)
            .sink { [weak self] t in self?.sleepCard.subtitleLabel.text = t }.store(in: &cancellables)
        viewModel.$moodRecords.receive(on: DispatchQueue.main)
            .sink { [weak self] r in self?.moodTrend.records = r; self?.moodTrend.reloadData() }.store(in: &cancellables)
        viewModel.$moodSubText.receive(on: DispatchQueue.main)
            .sink { [weak self] t in self?.moodCard.subtitleLabel.text = t }.store(in: &cancellables)
    }

    // MARK: - Theme

    @objc func applyTheme() {
        let dark = HDHealthDataModel.shared.isDarkMode
        let bg    = dark ? UIColor(red: 0.06, green: 0.08, blue: 0.14, alpha: 1)
                        : UIColor(red: 0.93, green: 0.95, blue: 0.97, alpha: 1)
        let cardC = dark ? UIColor(red: 0.12, green: 0.16, blue: 0.24, alpha: 1) : .white
        let textC: UIColor = dark ? .white : UIColor(red: 0.10, green: 0.12, blue: 0.18, alpha: 1)
        view.backgroundColor = bg
        scrollView.backgroundColor = bg
        contentView.backgroundColor = bg
        headerTitleLabel?.textColor = textC
        for card in [stepsCard, waterCard, sleepCard, moodCard] {
            card?.backgroundColor = cardC
            card?.titleLabel.textColor = textC
        }
        stepsLabel.textColor = textC
        waterLabel.textColor = textC
        ringView?.trackColor = dark ? UIColor(white: 0.18, alpha: 1) : UIColor(white: 0.88, alpha: 1)
        setNeedsStatusBarAppearanceUpdate()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return HDHealthDataModel.shared.isDarkMode ? .lightContent : .darkContent
    }

    @objc private func handleDataChange() { viewModel.refreshData() }

    // MARK: - ScrollView

    private func setupScrollView() {
        let sw = UIScreen.main.bounds.width
        let sh = UIScreen.main.bounds.height
        scrollView.frame = CGRect(x: 0, y: 0, width: sw, height: sh)
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)
        contentView.frame = CGRect(x: 0, y: 0, width: sw, height: 900)
        scrollView.addSubview(contentView)
        scrollView.contentSize = CGSize(width: sw, height: 900)
    }

    // MARK: - Header

    private func buildHeader() {
        let sw = view.bounds.width
        let topY: CGFloat = 54 + 12
        let df = DateFormatter()
        df.dateFormat = "MM月dd日"
        let dateLbl = UILabel(frame: CGRect(x: 20, y: topY, width: sw - 40, height: 20))
        dateLbl.text = "今天 · \(df.string(from: Date()))"
        dateLbl.font = .systemFont(ofSize: 13, weight: .medium)
        dateLbl.textColor = UIColor(white: 0.55, alpha: 1)
        contentView.addSubview(dateLbl)
        let titleLbl = UILabel(frame: CGRect(x: 20, y: topY + 22, width: sw - 40, height: 40))
        titleLbl.text = "健康仪表盘"
        titleLbl.font = .systemFont(ofSize: 28, weight: .heavy)
        titleLbl.textColor = .white
        contentView.addSubview(titleLbl)
        headerTitleLabel = titleLbl
    }

    // MARK: - 步数卡片

    private func buildStepsCard() {
        let sw = view.bounds.width; let pad: CGFloat = 16
        stepsCard = HDDashboardCardView(title: "今日步数", iconEmoji: "👟")
        stepsCard.frame = CGRect(x: pad, y: 54 + 90, width: sw - pad * 2, height: 180)
        contentView.addSubview(stepsCard)
        let rs: CGFloat = 110
        ringView = HDRingProgressView(frame: CGRect(x: 16, y: 56, width: rs, height: rs))
        ringView.ringColor  = UIColor(red: 0.22, green: 0.82, blue: 0.55, alpha: 1)
        ringView.trackColor = UIColor(white: 0.18, alpha: 1)
        ringView.lineWidth  = 12
        stepsCard.addContentView(ringView)
        let textX = rs + 32; let textW = sw - pad * 2 - textX - 16
        stepsLabel.frame = CGRect(x: textX, y: 60, width: textW, height: 52)
        stepsLabel.font = .monospacedDigitSystemFont(ofSize: 42, weight: .bold)
        stepsLabel.textColor = .white
        stepsLabel.adjustsFontSizeToFitWidth = true
        stepsCard.addContentView(stepsLabel)
        stepsSubLabel.frame = CGRect(x: textX, y: 116, width: textW, height: 20)
        stepsSubLabel.font = .systemFont(ofSize: 12)
        stepsSubLabel.textColor = UIColor(white: 0.55, alpha: 1)
        stepsCard.addContentView(stepsSubLabel)
        pctLabel.frame = CGRect(x: 16, y: 56 + rs / 2 - 10, width: rs, height: 20)
        pctLabel.textAlignment = .center
        pctLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        pctLabel.textColor = UIColor(white: 0.68, alpha: 1)
        stepsCard.addContentView(pctLabel)
    }

    // MARK: - 喝水卡片

    private func buildWaterCard() {
        let sw = view.bounds.width; let pad: CGFloat = 16
        waterCard = HDDashboardCardView(title: "今日喝水", iconEmoji: "💧")
        waterCard.frame = CGRect(x: pad, y: 54 + 90 + 196, width: sw - pad * 2, height: 150)
        contentView.addSubview(waterCard)
        let ww = sw - pad * 2 - 32
        waterWave = HDWaterView(frame: CGRect(x: 16, y: 56, width: ww, height: 72))
        waterCard.addContentView(waterWave)
        waterLabel.frame = CGRect(x: ww - 114, y: 64, width: 114, height: 24)
        waterLabel.textAlignment = .right
        waterLabel.font = .monospacedDigitSystemFont(ofSize: 17, weight: .bold)
        waterLabel.textColor = .white
        waterCard.addContentView(waterLabel)
    }

    // MARK: - 睡眠卡片

    private func buildSleepCard() {
        let sw = view.bounds.width; let pad: CGFloat = 16
        sleepCard = HDDashboardCardView(title: "近7天睡眠", iconEmoji: "🌙")
        sleepCard.frame = CGRect(x: pad, y: 54 + 90 + 196 + 166, width: sw - pad * 2, height: 170)
        contentView.addSubview(sleepCard)
        sleepBar = HDSleepBarView(frame: CGRect(x: 16, y: 56, width: sw - pad * 2 - 32, height: 100))
        sleepCard.addContentView(sleepBar)
    }

    // MARK: - 心情卡片

    private func buildMoodCard() {
        let sw = view.bounds.width; let pad: CGFloat = 16
        moodCard = HDDashboardCardView(title: "今日心情", iconEmoji: "🌟")
        moodCard.frame = CGRect(x: pad, y: 54 + 90 + 196 + 166 + 186, width: sw - pad * 2, height: 160)
        contentView.addSubview(moodCard)
        moodTrend = HDMoodTrendView(frame: CGRect(x: 16, y: 56, width: sw - pad * 2 - 32, height: 90))
        moodCard.addContentView(moodTrend)
    }

    // MARK: - FAB

    private func buildFAB() {
        let sw = view.bounds.width; let sh = view.bounds.height
        let tabBarH = tabBarController?.tabBar.frame.height ?? 83
        fabButton.frame = CGRect(x: sw - 76, y: sh - tabBarH - 16 - 56, width: 56, height: 56)
        fabButton.backgroundColor    = UIColor(red: 0.22, green: 0.54, blue: 0.95, alpha: 1)
        fabButton.layer.cornerRadius = 28
        fabButton.layer.shadowColor  = UIColor(red: 0.22, green: 0.54, blue: 0.95, alpha: 0.55).cgColor
        fabButton.layer.shadowOpacity = 0.9
        fabButton.layer.shadowRadius  = 14
        fabButton.layer.shadowOffset  = CGSize(width: 0, height: 4)
        fabButton.setTitle("+", for: .normal)
        fabButton.titleLabel?.font = .systemFont(ofSize: 30, weight: .light)
        fabButton.setTitleColor(.white, for: .normal)
        fabButton.addTarget(self, action: #selector(fabTapped), for: .touchUpInside)
        view.addSubview(fabButton)
    }

    @objc private func fabTapped() {
        UIView.animate(withDuration: 0.12) {
            self.fabButton.transform = CGAffineTransform(scaleX: 0.88, y: 0.88)
        } completion: { _ in
            UIView.animate(withDuration: 0.18) { self.fabButton.transform = .identity }
        }
        let vc = HDQuickAddViewController()
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle   = .crossDissolve
        present(vc, animated: false)
    }
}

// MARK: - HDQuickAddDelegate

extension HDDashboardViewController: HDQuickAddDelegate {
    func quickAddDidUpdateData() {
        viewModel.refreshData()
    }
}

