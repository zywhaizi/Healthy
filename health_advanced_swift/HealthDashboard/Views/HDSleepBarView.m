//
//  HDSleepBarView.m
//  HealthDashboard - 睡眠柱状图
//
//  Created by zhang, haizi on 2026/3/19.
//

#import "HDSleepBarView.h"

@implementation HDSleepBarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)reloadData {
    // 移除旧子视图
    for (UIView *v in self.subviews) [v removeFromSuperview];

    if (!_hoursData.count) return;
    NSInteger count = MIN(7, (NSInteger)_hoursData.count);
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    CGFloat barW = (w - 8 * (count - 1)) / count;
    CGFloat maxH = [_hoursData valueForKeyPath:@"@max.floatValue"] ? [[_hoursData valueForKeyPath:@"@max.floatValue"] floatValue] : 10.0;
    if (maxH < 1) maxH = 10;

    NSArray *days = @[@"一",@"二",@"三",@"四",@"五",@"六",@"日"];
    NSInteger startIdx = _hoursData.count - count;

    for (NSInteger i = 0; i < count; i++) {
        CGFloat hours = [_hoursData[startIdx + i] floatValue];
        CGFloat ratio = hours / maxH;
        CGFloat barH  = MAX(4, ratio * (h - 20));
        CGFloat x     = i * (barW + 8);

        // 柱子
        UIView *bar = [[UIView alloc] initWithFrame:CGRectMake(x, h - barH - 16, barW, barH)];
        bar.backgroundColor  = [UIColor colorWithRed:0.38 green:0.60 blue:0.95 alpha:1.0];
        bar.layer.cornerRadius = barW / 2;
        [self addSubview:bar];

        // 星期标签
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(x, h - 14, barW, 14)];
        lbl.text      = days[i % 7];
        lbl.font      = [UIFont systemFontOfSize:10];
        lbl.textColor = [UIColor colorWithWhite:0.55 alpha:1.0];
        lbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lbl];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self reloadData];
}

@end
