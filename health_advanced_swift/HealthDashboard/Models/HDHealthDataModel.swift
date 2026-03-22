//
//  HDHealthDataModel.swift
//  HealthDashboard - 健康数据模型
//
//  Created by AI Assistant on 2026/3/22.
//

import UIKit

// MARK: - 通知名称常量

extension Notification.Name {
    /// 健康数据变更通知
    static let hdDataDidChange = Notification.Name("HDDataDidChange")
    /// 主题变更通知
    static let hdThemeDidChange = Notification.Name("HDThemeDidChange")
}

// MARK: - HDMoodRecord

/// 心情记录
class HDMoodRecord {
    /// 心情等级 1-5
    var moodLevel: Int
    /// 记录时间
    var timestamp: Date
    /// 对应 emoji 字符串
    var emojiString: String {
        let emojis = ["😞", "😕", "😐", "😊", "😄"]
        let idx = max(0, min(4, moodLevel - 1))
        return emojis[idx]
    }

    init(moodLevel: Int = 3, timestamp: Date = Date()) {
        self.moodLevel = moodLevel
        self.timestamp = timestamp
    }
}

// MARK: - HDExerciseRecord

/// 运动记录
class HDExerciseRecord {
    /// 运动类型（0=目标跑, 1=自由跑）
    var type: Int = 0
    /// 运动时长（秒）
    var durationSeconds: Int = 0
    /// 运动距离（km）
    var distanceKM: CGFloat = 0
    /// 消耗卡路里
    var caloriesBurned: Int = 0
    /// 运动时间
    var timestamp: Date = Date()
    /// 运动类型字符串
    var typeString: String { type == 0 ? "目标跑" : "自由跑" }
}

// MARK: - HDHealthDataModel

/// 全局健康数据单例
@MainActor
class HDHealthDataModel {

    // MARK: - Singleton

    static let shared = HDHealthDataModel()
    private init() {}

    // MARK: - 步数

    var todaySteps: Int = 6842
    var stepsGoal: Int = 10000
    var stepsProgress: CGFloat { min(1.0, CGFloat(todaySteps) / CGFloat(stepsGoal)) }

    // MARK: - 喝水

    var waterML: CGFloat = 600
    var waterGoalML: CGFloat = 2000
    var waterProgress: CGFloat { min(1.0, waterML / waterGoalML) }

    // MARK: - 睡眠

    var sleepHours: [Double] = [6.5, 7.2, 5.8, 8.0, 7.5, 6.0, 7.8]

    // MARK: - 心情

    var moodRecords: [HDMoodRecord] = {
        let levels = [3, 4, 2, 5, 3, 4, 4]
        return (0..<7).map { i in
            HDMoodRecord(moodLevel: levels[i],
                         timestamp: Date(timeIntervalSinceNow: -Double(6 - i) * 86400))
        }
    }()
    var latestMood: HDMoodRecord? { moodRecords.last }

    // MARK: - 运动

    var targetRunDistanceKM: Int = 5
    var targetRunMinutes: Int = 30
    var exerciseHistory: [HDExerciseRecord] = []

    // MARK: - 主题

    var isDarkMode: Bool = false

    // MARK: - 操作方法

    /// 添加饮水记录
    func addWater(_ ml: CGFloat) {
        waterML = min(waterGoalML, waterML + ml)
        NotificationCenter.default.post(name: .hdDataDidChange, object: nil)
    }

    /// 添加步数
    func addSteps(_ steps: Int) {
        todaySteps += steps
        NotificationCenter.default.post(name: .hdDataDidChange, object: nil)
    }

    /// 添加心情记录
    func addMood(_ level: Int) {
        moodRecords.append(HDMoodRecord(moodLevel: level))
        NotificationCenter.default.post(name: .hdDataDidChange, object: nil)
    }

    /// 保存运动记录
    func saveExerciseRecord(_ record: HDExerciseRecord) {
        exerciseHistory.append(record)
        NotificationCenter.default.post(name: .hdDataDidChange, object: nil)
    }

    /// 步数换算卡路里（约0.04千卡/步）
    func calory(forSteps steps: Int) -> CGFloat {
        return CGFloat(steps) * 0.04
    }
}
