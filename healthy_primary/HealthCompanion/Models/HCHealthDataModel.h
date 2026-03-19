//
//  HCHealthDataModel.h
//  ZywTest - 健康伴侣
//
//  Created by zhang, haizi on 2026/3/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HCMoodType) {
    HCMoodTypeAwful = 0,
    HCMoodTypeBad,
    HCMoodTypeNeutral,
    HCMoodTypeGood,
    HCMoodTypeGreat
};

@interface HCMoodRecord : NSObject
@property (nonatomic, assign) HCMoodType moodType;
@property (nonatomic, strong) NSDate *timestamp;
+ (instancetype)recordWithMood:(HCMoodType)mood;
- (NSString *)emojiString;
@end

@interface HCHealthDataModel : NSObject

// Singleton
+ (instancetype)shared;

// Steps
@property (nonatomic, assign) NSInteger todaySteps;
@property (nonatomic, assign) NSInteger stepsGoal;

// Water
@property (nonatomic, assign) CGFloat waterML;          // in mL
@property (nonatomic, assign) CGFloat waterGoalML;

// Sleep
@property (nonatomic, strong) NSArray<NSNumber *> *sleepHours; // last 7 days

// Mood
@property (nonatomic, strong) NSArray<HCMoodRecord *> *moodRecords; // today

// Dark Mode
@property (nonatomic, assign) BOOL isDarkMode;

// Actions
- (void)addWater200ml;
- (void)setSteps:(NSInteger)steps;
- (void)addMoodRecord:(HCMoodType)mood;
- (CGFloat)stepsProgress;       // 0.0 ~ 1.0
- (CGFloat)waterProgress;       // 0.0 ~ 1.0
- (CGFloat)caloryForSteps:(NSInteger)steps;
- (HCMoodRecord *_Nullable)latestMood;

// Persistence
- (void)save;
- (void)load;

@end

NS_ASSUME_NONNULL_END
