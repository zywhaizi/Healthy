//
//  HDHealthDataModel.swift
//  HealthDashboard - 健康数据模型
//
//  Created by AI Assistant on 2026/3/22.
//

import UIKit
import Combine

// MARK: - HDMoodRecord

/// 心情记录
class HDMoodRecord {
    var moodLevel: Int
    var timestamp: Date
    var emojiString: String {
        let emojis = ["😞", "😕", "😐", "😊", "😄"]
        return emojis[max(0, min(4, moodLevel - 1))]
    }
    init(moodLevel: Int = 3, timestamp: Date = Date()) {
        self.moodLevel = moodLevel
        self.timestamp = timestamp
    }
}

// MARK: - HDExerciseRecord

/// 运动记录
class HDExerciseRecord {
    var type: Int = 0
    var durationSeconds: Int = 0
    var distanceKM: CGFloat = 0
    var caloriesBurned: Int = 0
    var timestamp: Date = Date()
    var typeString: String { type == 0 ? "目标跑" : "自由跑" }
}

// MARK: - HDHealthDataModel

/// 全局健康数据单例（ObservableObject，@Published 驱动 UI）
@MainActor
final class HDHealthDataModel: ObservableObject {

    // MARK: - Singleton

    static let shared = HDHealthDataModel()
    private init() {}

    // MARK: - 步数

    @Published var todaySteps: Int = 6842
    @Published var stepsGoal: Int = 10000
    var stepsProgress: CGFloat { min(1.0, CGFloat(todaySteps) / CGFloat(stepsGoal)) }

    // MARK: - 喝水

    @Published var waterML: CGFloat = 600
    @Published var waterGoalML: CGFloat = 2000
    var waterProgress: CGFloat { min(1.0, waterML / waterGoalML) }

    // MARK: - 睡眠

    @Published var sleepHours: [Double] = [6.5, 7.2, 5.8, 8.0, 7.5, 6.0, 7.8]

    // MARK: - 心情

    @Published var moodRecords: [HDMoodRecord] = {
        let levels = [3, 4, 2, 5, 3, 4, 4]
        return (0..<7).map { i in
            HDMoodRecord(moodLevel: levels[i],
                         timestamp: Date(timeIntervalSinceNow: -Double(6 - i) * 86400))
        }
    }()
    var latestMood: HDMoodRecord? { moodRecords.last }

    // MARK: - 运动

    @Published var targetRunDistanceKM: Int = 5
    @Published var targetRunMinutes: Int = 30
    @Published var exerciseHistory: [HDExerciseRecord] = []

    // MARK: - 主题

    @Published var isDarkMode: Bool = false

    // MARK: - 操作方法

    /// 添加饮水记录
    func addWater(_ ml: CGFloat) {
        waterML = min(waterGoalML, waterML + ml)
    }

    /// 添加步数
    func addSteps(_ steps: Int) {
        todaySteps += steps
    }

    /// 添加心情记录
    func addMood(_ level: Int) {
        moodRecords.append(HDMoodRecord(moodLevel: level))
    }

    /// 保存运动记录
    func saveExerciseRecord(_ record: HDExerciseRecord) {
        exerciseHistory.append(record)
    }

    /// 步数换算卡路里（约0.04千卡/步）
    func calory(forSteps steps: Int) -> CGFloat {
        CGFloat(steps) * 0.04
    }
}
