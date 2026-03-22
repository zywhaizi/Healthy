//
//  HDMoodTrendView.h
//  HealthDashboard - 心情趋势折线图
//
//  Created by zhang, haizi on 2026/3/19.
//

#import <UIKit/UIKit.h>
#import "../Models/HDHealthDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HDMoodTrendView : UIView
@property (nonatomic, strong) NSArray<HDMoodRecord *> *records;
- (void)reloadData;
@end

NS_ASSUME_NONNULL_END
