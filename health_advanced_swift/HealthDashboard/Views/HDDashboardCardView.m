//
//  HDDashboardCardView.m
//  HealthDashboard - 卡片容器
//
//  Created by zhang, haizi on 2026/3/19.
//

#import "HDDashboardCardView.h"

@interface HDDashboardCardView ()
@property (nonatomic, strong) UILabel *_titleLabel;
@property (nonatomic, strong) UILabel *_subtitleLabel;
@end

@implementation HDDashboardCardView

- (instancetype)initWithTitle:(NSString *)title iconEmoji:(NSString *)emoji {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor    = [UIColor colorWithRed:0.12 green:0.16 blue:0.24 alpha:1.0];
        self.layer.cornerRadius = 16;
        self.layer.shadowColor  = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.18;
        self.layer.shadowRadius  = 8;
        self.layer.shadowOffset  = CGSizeMake(0, 2);

        // emoji 图标
        UILabel *icon = [[UILabel alloc] initWithFrame:CGRectMake(16, 14, 28, 28)];
        icon.text = emoji;
        icon.font = [UIFont systemFontOfSize:22];
        [self addSubview:icon];

        // 标题
        __titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 14, 200, 22)];
        __titleLabel.text      = title;
        __titleLabel.font      = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
        __titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:__titleLabel];

        // 副标题
        __subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 34, 240, 18)];
        __subtitleLabel.font      = [UIFont systemFontOfSize:11];
        __subtitleLabel.textColor = [UIColor colorWithWhite:0.55 alpha:1.0];
        [self addSubview:__subtitleLabel];
    }
    return self;
}

- (UILabel *)titleLabel    { return __titleLabel; }
- (UILabel *)subtitleLabel { return __subtitleLabel; }

- (void)addContentView:(UIView *)view {
    [self addSubview:view];
}

@end
