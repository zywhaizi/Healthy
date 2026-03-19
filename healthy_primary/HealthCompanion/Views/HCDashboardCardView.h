//
//  HCDashboardCardView.h
//  健康伴侣 - 卡片容器
//
//  Created by zhang, haizi on 2026/3/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCDashboardCardView : UIView

@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *subtitleLabel;

- (instancetype)initWithTitle:(NSString *)title iconEmoji:(NSString *)emoji;
- (void)addContentView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
