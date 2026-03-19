//
//  HCDashboardCardView.m
//  健康伴侣 - 卡片容器
//
//  Created by zhang, haizi on 2026/3/19.
//

#import "HCDashboardCardView.h"

@interface HCDashboardCardView ()
@property (nonatomic, strong) UILabel *emojiLabel;
@property (nonatomic, strong) UILabel *internalTitleLabel;
@property (nonatomic, strong) UILabel *internalSubtitleLabel;
@end

@implementation HCDashboardCardView

- (UILabel *)titleLabel    { return _internalTitleLabel; }
- (UILabel *)subtitleLabel { return _internalSubtitleLabel; }

- (instancetype)initWithTitle:(NSString *)title iconEmoji:(NSString *)emoji {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor    = [UIColor colorWithRed:0.12 green:0.16 blue:0.24 alpha:1.0];
        self.layer.cornerRadius = 20;
        self.layer.masksToBounds = NO;
        self.layer.shadowColor  = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.35;
        self.layer.shadowOffset  = CGSizeMake(0, 4);
        self.layer.shadowRadius  = 10;

        // Emoji icon
        _emojiLabel = [[UILabel alloc] init];
        _emojiLabel.text = emoji;
        _emojiLabel.font = [UIFont systemFontOfSize:22];
        [self addSubview:_emojiLabel];

        // Title
        _internalTitleLabel = [[UILabel alloc] init];
        _internalTitleLabel.text      = title;
        _internalTitleLabel.font      = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
        _internalTitleLabel.textColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        [self addSubview:_internalTitleLabel];

        // Subtitle
        _internalSubtitleLabel = [[UILabel alloc] init];
        _internalSubtitleLabel.text      = @"";
        _internalSubtitleLabel.font      = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        _internalSubtitleLabel.textColor = [UIColor colorWithWhite:0.55 alpha:1.0];
        [self addSubview:_internalSubtitleLabel];
    }
    return self;
}

- (void)addContentView:(UIView *)view {
    [self addSubview:view];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat w  = self.bounds.size.width;
    CGFloat pad = 16;

    _emojiLabel.frame          = CGRectMake(pad, 14, 28, 28);
    _internalTitleLabel.frame    = CGRectMake(pad + 32, 16, w - pad*2 - 32, 20);
    _internalSubtitleLabel.frame = CGRectMake(pad + 32, 36, w - pad*2 - 32, 16);
}

@end
