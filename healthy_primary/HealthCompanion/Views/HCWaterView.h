//
//  HCWaterView.h
//  健康伴侣 - 喝水波浪 View
//
//  Created by zhang, haizi on 2026/3/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCWaterView : UIView

/// 0.0 ~ 1.0
@property (nonatomic, assign) CGFloat waterLevel;
- (void)setWaterLevel:(CGFloat)level animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
