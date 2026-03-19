//
//  HCMoodTrendView.h
//  健康伴侣 - 心情趋势折线图
//
//  Created by zhang, haizi on 2026/3/19.
//

#import <UIKit/UIKit.h>
#import "../Models/HCHealthDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HCMoodTrendView : UIView

/// Array of HCMoodRecord
@property (nonatomic, strong) NSArray<HCMoodRecord *> *records;
- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
