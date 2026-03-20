//
//  HDSleepBarView.h
//  HealthDashboard - 睡眠柱状图
//
//  Created by zhang, haizi on 2026/3/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 近7天睡眠横向柱状图
@interface HDSleepBarView : UIView
@property (nonatomic, strong) NSArray<NSNumber *> *hoursData; // 7个元素
- (void)reloadData;
@end

NS_ASSUME_NONNULL_END
