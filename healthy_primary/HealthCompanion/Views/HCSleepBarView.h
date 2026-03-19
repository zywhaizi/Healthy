//
//  HCSleepBarView.h
//  健康伴侣 - 睡眠柱状图
//
//  Created by zhang, haizi on 2026/3/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCSleepBarView : UIView

/// Array of NSNumber (float hours), up to 7 values (Mon~Sun)
@property (nonatomic, strong) NSArray<NSNumber *> *hoursData;
- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
