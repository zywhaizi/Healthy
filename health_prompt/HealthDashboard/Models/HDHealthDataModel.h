//
//  HDHealthDataModel.h
//  HealthDashboard - 健康数据模型
//
//  Created by zhang, haizi on 2026/3/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 心情记录
@interface HDMoodRecord : NSObject
@property (nonatomic, assign) NSInteger moodLevel; // 1-5
@property (nonatomic, strong) NSDate *timestamp;
@property (nonatomic, readonly) NSString *emojiString;
@end

/// 全局健康数据单例
@interface HDHealthDataModel : NSObject

+ (instancetype)shared;

// 步数
@property (nonatomic, assign) NSInteger todaySteps;
@property (nonatomic, assign) NSInteger stepsGoal;
@property (nonatomic, readonly) CGFloat stepsProgress; // 0.0~1.0

// 喝水
@property (nonatomic, assign) CGFloat waterML;
@property (nonatomic, assign) CGFloat waterGoalML;
@property (nonatomic, readonly) CGFloat waterProgress;

// 睡眠（近7天，小时）
@property (nonatomic, strong) NSArray<NSNumber *> *sleepHours;

// 心情
@property (nonatomic, strong) NSArray<HDMoodRecord *> *moodRecords;
@property (nonatomic, readonly, nullable) HDMoodRecord *latestMood;

// 主题
@property (nonatomic, assign) BOOL isDarkMode;

// 操作
- (void)addWater:(CGFloat)ml;
- (void)addSteps:(NSInteger)steps;
- (void)addMood:(NSInteger)level;
- (CGFloat)caloryForSteps:(NSInteger)steps;

@end

NS_ASSUME_NONNULL_END
