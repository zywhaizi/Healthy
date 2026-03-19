//
//  HCHealthDataModel.m
//  ZywTest - 健康伴侣
//
//  Created by zhang, haizi on 2026/3/19.
//

#import "HCHealthDataModel.h"

#pragma mark - HCMoodRecord

@implementation HCMoodRecord

+ (instancetype)recordWithMood:(HCMoodType)mood {
    HCMoodRecord *r = [HCMoodRecord new];
    r.moodType = mood;
    r.timestamp = [NSDate date];
    return r;
}

- (NSString *)emojiString {
    switch (self.moodType) {
        case HCMoodTypeAwful:   return @"😞";
        case HCMoodTypeBad:     return @"😕";
        case HCMoodTypeNeutral: return @"😐";
        case HCMoodTypeGood:    return @"😊";
        case HCMoodTypeGreat:   return @"😄";
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ %@", self.emojiString, self.timestamp];
}

@end

#pragma mark - HCHealthDataModel

static NSString *const kStepsKey      = @"hc_steps";
static NSString *const kWaterKey      = @"hc_water";
static NSString *const kSleepKey      = @"hc_sleep";
static NSString *const kMoodKey       = @"hc_mood";
static NSString *const kDarkModeKey   = @"hc_dark_mode";

@implementation HCHealthDataModel

+ (instancetype)shared {
    static HCHealthDataModel *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [HCHealthDataModel new];
        [_instance load];
    });
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _stepsGoal    = 10000;
        _waterGoalML  = 2000;
        _todaySteps   = 0;
        _waterML      = 0;
        _sleepHours   = @[@7.5, @6.0, @8.0, @7.0, @6.5, @7.8, @8.2];
        _moodRecords  = @[];
        _isDarkMode   = NO;
    }
    return self;
}

- (void)addWater200ml {
    _waterML += 200;
    if (_waterML > _waterGoalML) _waterML = _waterGoalML;
    [self save];
}

- (void)setSteps:(NSInteger)steps {
    _todaySteps = steps;
    [self save];
}

- (void)addMoodRecord:(HCMoodType)mood {
    HCMoodRecord *r = [HCMoodRecord recordWithMood:mood];
    NSMutableArray *arr = [self.moodRecords mutableCopy];
    [arr addObject:r];
    _moodRecords = [arr copy];
    [self save];
}

- (CGFloat)stepsProgress {
    return MIN(1.0, (CGFloat)_todaySteps / (CGFloat)_stepsGoal);
}

- (CGFloat)waterProgress {
    return MIN(1.0, _waterML / _waterGoalML);
}

- (CGFloat)caloryForSteps:(NSInteger)steps {
    // ~0.04 kcal per step (average person)
    return steps * 0.04f;
}

- (HCMoodRecord *)latestMood {
    return _moodRecords.lastObject;
}

#pragma mark - Persistence

- (void)save {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:_todaySteps forKey:kStepsKey];
    [ud setFloat:_waterML      forKey:kWaterKey];
    [ud setBool:_isDarkMode    forKey:kDarkModeKey];

    // Sleep (NSArray of floats)
    NSMutableArray *sleepArr = [NSMutableArray array];
    for (NSNumber *n in _sleepHours) [sleepArr addObject:n];
    [ud setObject:sleepArr forKey:kSleepKey];

    // Mood records
    NSMutableArray *moodArr = [NSMutableArray array];
    for (HCMoodRecord *r in _moodRecords) {
        NSDictionary *dict = @{@"type": @(r.moodType), @"ts": r.timestamp};
        [moodArr addObject:dict];
    }
    [ud setObject:moodArr forKey:kMoodKey];
    [ud synchronize];
}

- (void)load {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    _todaySteps = [ud integerForKey:kStepsKey];
    _waterML    = [ud floatForKey:kWaterKey];
    _isDarkMode = [ud boolForKey:kDarkModeKey];

    NSArray *sleepArr = [ud arrayForKey:kSleepKey];
    if (sleepArr.count > 0) _sleepHours = sleepArr;

    NSArray *moodArr = [ud arrayForKey:kMoodKey];
    NSMutableArray *records = [NSMutableArray array];
    for (NSDictionary *dict in moodArr) {
        HCMoodRecord *r = [HCMoodRecord new];
        r.moodType  = [dict[@"type"] integerValue];
        r.timestamp = dict[@"ts"];
        [records addObject:r];
    }
    _moodRecords = [records copy];
}

@end
