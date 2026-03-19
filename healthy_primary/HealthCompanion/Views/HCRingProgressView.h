//
//  HCRingProgressView.h
//  健康伴侣 - 环形进度条
//
//  Created by zhang, haizi on 2026/3/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCRingProgressView : UIView

@property (nonatomic, assign) CGFloat progress;     // 0.0 ~ 1.0, animatable
@property (nonatomic, strong) UIColor *ringColor;
@property (nonatomic, strong) UIColor *trackColor;
@property (nonatomic, assign) CGFloat lineWidth;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
