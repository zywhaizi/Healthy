//
//  HDExerciseSummaryViewController.h
//  HealthDashboard
//
//  Created by zhang, haizi on 2026/3/21.
//

#import <UIKit/UIKit.h>
#import "../Models/HDHealthDataModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 运动总结 ViewController
@interface HDExerciseSummaryViewController : UIViewController

/// 运动记录
@property (nonatomic, strong) HDExerciseRecord *exerciseRecord;

/// 应用主题
- (void)applyTheme;

@end

NS_ASSUME_NONNULL_END
