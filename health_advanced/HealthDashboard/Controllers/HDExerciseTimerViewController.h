//
//  HDExerciseTimerViewController.h
//  HealthDashboard
//
//  Created by zhang, haizi on 2026/3/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 运动计时 ViewController
@interface HDExerciseTimerViewController : UIViewController

/// 运动类型（0=目标跑, 1=自由跑）
@property (nonatomic, assign) NSInteger exerciseType;

/// 应用主题
- (void)applyTheme;

@end

NS_ASSUME_NONNULL_END
