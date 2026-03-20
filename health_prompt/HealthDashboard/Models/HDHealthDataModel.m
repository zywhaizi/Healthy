//
//  HDHealthDataModel.m
//  HealthDashboard - 健康数据模型
//
//  Created by zhang, haizi on 2026/3/19.
//

#import "HDHealthDataModel.h"

@implementation HDMoodRecord
- (NSString *)emojiString {
    NSArray *emojis = @[@"😞",@"😕",@"😐",@"😊",@"😄"];
    NSInteger idx = MAX(0, MIN(4, self.moodLevel - 1));
    return emojis[idx];
}
@end

@implementation HDHealthDataModel

+ (instancetype)shared {
    static HDHealthDataModel *_inst;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ _inst = [self new]; });
    return _inst;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // 初始化模拟数据
        _todaySteps  = 6842;
        _stepsGoal   = 10000;
        _waterML     = 600;
        _waterGoalML = 2000;
        _sleepHours  = @[@6.5, @7.2, @5.8, @8.0, @7.5, @6.0, @7.8];
        _isDarkMode  = NO;

        // 模拟心情记录
        NSMutableArray *moods = [NSMutableArray array];
        NSInteger levels[] = {3,4,2,5,3,4,4};
        for (int i = 6; i >= 0; i--) {
            HDMoodRecord *r = [HDMoodRecord new];
            r.moodLevel  = levels[6-i];
            r.timestamp  = [NSDate dateWithTimeIntervalSinceNow:-i*86400];
            [moods addObject:r];
        }
        _moodRecords = moods;
    }
    return self;
}

- (CGFloat)stepsProgress { return MIN(1.0, (CGFloat)_todaySteps / _stepsGoal); }
- (CGFloat)waterProgress { return MIN(1.0, _waterML / _waterGoalML); }
- (HDMoodRecord *)latestMood { return _moodRecords.lastObject; }

- (void)addWater:(CGFloat)ml {
    _waterML = MIN(_waterGoalML, _waterML + ml);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HDDataDidChange" object:nil];
}

- (void)addSteps:(NSInteger)steps {
    _todaySteps += steps;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HDDataDidChange" object:nil];
}

- (void)addMood:(NSInteger)level {
    HDMoodRecord *r = [HDMoodRecord new];
    r.moodLevel  = level;
    r.timestamp  = [NSDate date];
    NSMutableArray *arr = [_moodRecords mutableCopy];
    [arr addObject:r];
    _moodRecords = arr;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HDDataDidChange" object:nil];
}

- (CGFloat)caloryForSteps:(NSInteger)steps {
    // 平均每步消耗约0.04千卡
    return steps * 0.04;
}

@end
