//
//  HDHealthDataModel.swift
//  HealthDashboard - 健康数据模型
//
//  Created by AI Assistant on 2026/3/22.
//

import UIKit

// MARK: - HDMoodRecord

/// 心情记录
class HDMoodRecord: NSObject {
    /// 心情等级 1-5
    @objc var moodLevel: Int = 3
    /// 记录时间
    @objc var timestamp: Date = Date()
    /// 对应 emoji 字符串
    @objc var emojiString: String {
        let emojis = ["😞", "😕", "😐", "😊", "😄"]
        let idx = max(0, min(4, moodLevel - 1))
        return emojis[idx]
    }
}

// MARK: - HDExerciseRecord

/// 运动记录
class HDExerciseRecord: NSObject {
    /// 运动类型（0=目标跑, 1=自由跑）
    @objc var type: Int = 0
    /// 运动时长（秒）
    @objc var durationSeconds: Int = 0
    /// 运动距离（km）
    @objc var distanceKM: CGFloat = 0
    /// 消耗卡路里
    @objc var caloriesBurned: Int = 0
    /// 运动时间
    @objc var timestamp: Date = Date()
    /// 运动类型字符串
    @objc var typeString: String { type == 0 ? "目标跑" : "自由跑" }
}

// MARK: - HDHealthDataModel

/// 全局健康数据单例
@MainActor
@objc class HDHealthDataModel: NSObject {

    // MARK: - Singleton

    @objc static func shared() -> HDHealthDataModel { _shared }
    private static let _shared = HDHealthDataModel()

    // MARK: - 步数

    @objc var todaySteps: Int = 6842
    @objc var stepsGoal: Int = 10000
    @objc var stepsProgress: CGFloat { min(1.0, CGFloat(todaySteps) / CGFloat(stepsGoal)) }

    // MARK: - 喝水

    @objc var waterML: CGFloat = 600
    @objc var waterGoalML: CGFloat = 2000
    @objc var waterProgress: CGFloat { min(1.0, waterML / waterGoalML) }

    // MARK: - 睡眠

    @objc var sleepHours: [NSNumber] = [6.5, 7.2, 5.8, 8.0, 7.5, 6.0, 7.8]

    // MARK: - 心情

    @objc var moodRecords: [HDMoodRecord] = {
        let levels = [3, 4, 2, 5, 3, 4, 4]
        return (0..<7).map { i in
            let r = HDMoodRecord()
            r.moodLevel = levels[i]
            r.timestamp = Date(timeIntervalSinceNow: -Double(6 - i) * 86400)
            return r
        }
    }()
    @objc var latestMood: HDMoodRecord? { moodRecords.last }

    // MARK: - 运动

    @objc var targetRunDistanceKM: Int = 5
    @objc var targetRunMinutes: Int = 30
    @objc var exerciseHistory: [HDExerciseRecord] = []

    // MARK: - 主题

    @objc var isDarkMode: Bool = false

    // MARK: - 操作方法

    /// 添加饮水记录
    @objc func addWater(_ ml: CGFloat) {
        waterML = min(waterGoalML, waterML + ml)
        NotificationCenter.default.post(name: NSNotification.Name("HDDataDidChange"), object: nil)
    }

    /// 添加步数
    @objc func addSteps(_ steps: Int) {
        todaySteps += steps
        NotificationCenter.default.post(name: NSNotification.Name("HDDataDidChange"), object: nil)
    }

    /// 添加心情记录
    @objc func addMood(_ level: Int) {
        let r = HDMoodRecord()
        r.moodLevel = level
        r.timestamp = Date()
        moodRecords.append(r)
        NotificationCenter.default.post(name: NSNotification.Name("HDDataDidChange"), object: nil)
    }

    /// 保存运动记录
    @objc func saveExerciseRecord(_ record: HDExerciseRecord) {
        exerciseHistory.append(record)
        NotificationCenter.default.post(name: NSNotification.Name("HDDataDidChange"), object: nil)
    }

    /// 步数换算卡路里（约0.04千卡/步）
    @objc func calory(forSteps steps: Int) -> CGFloat {
        return CGFloat(steps) * 0.04
    }
}
