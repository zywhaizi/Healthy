//
//  HDWaterView.h
//  HealthDashboard - 喝水波浪动画
//
//  Created by zhang, haizi on 2026/3/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 水波进度视图
@interface HDWaterView : UIView
- (void)setWaterLevel:(CGFloat)level animated:(BOOL)animated; // 0.0~1.0
@end

NS_ASSUME_NONNULL_END
