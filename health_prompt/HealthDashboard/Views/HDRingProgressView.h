//
//  HDRingProgressView.h
//  HealthDashboard - 环形进度条
//
//  Created by zhang, haizi on 2026/3/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 环形进度条，支持动画
@interface HDRingProgressView : UIView
@property (nonatomic, strong) UIColor *ringColor;   // 进度颜色
@property (nonatomic, strong) UIColor *trackColor;  // 轨道颜色
@property (nonatomic, assign) CGFloat lineWidth;    // 线宽
@property (nonatomic, assign, readonly) CGFloat progress; // 0.0~1.0
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
