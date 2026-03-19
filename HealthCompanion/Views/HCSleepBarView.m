//
//  HCSleepBarView.m
//  健康伴侣 - 睡眠柱状图
//
//  Created by zhang, haizi on 2026/3/19.
//

#import "HCSleepBarView.h"

@interface HCSleepBarView ()
@property (nonatomic, strong) NSMutableArray<CAShapeLayer *> *barLayers;
@property (nonatomic, strong) NSMutableArray<UILabel *> *labelViews;
@end

@implementation HCSleepBarView

static NSArray *kDayLabels;

+ (void)initialize {
    kDayLabels = @[@"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat", @"Sun"];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) { [self commonInit]; }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) { [self commonInit]; }
    return self;
}

- (void)commonInit {
    self.backgroundColor = [UIColor clearColor];
    _barLayers  = [NSMutableArray array];
    _labelViews = [NSMutableArray array];
    _hoursData  = @[@7.5, @6.0, @8.0, @7.0, @6.5, @7.8, @8.2];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self reloadData];
}

- (void)reloadData {
    // Remove old
    for (CAShapeLayer *l in _barLayers) [l removeFromSuperlayer];
    for (UILabel *lbl in _labelViews) [lbl removeFromSuperview];
    [_barLayers removeAllObjects];
    [_labelViews removeAllObjects];

    NSInteger count = MIN((NSInteger)_hoursData.count, 7);
    if (count == 0) return;

    CGFloat w       = self.bounds.size.width;
    CGFloat h       = self.bounds.size.height;
    CGFloat labelH  = 18;
    CGFloat chartH  = h - labelH - 4;
    CGFloat barW    = floorf((w - (count - 1) * 6) / count);
    CGFloat maxHour = 10.0;   // scale to 10h

    UIColor *barColor     = [UIColor colorWithRed:0.40 green:0.76 blue:0.60 alpha:1.0];
    UIColor *barColorGoal = [UIColor colorWithRed:0.25 green:0.58 blue:0.95 alpha:1.0];
    CGFloat goalH         = 8.0; // goal line at 8h

    for (NSInteger i = 0; i < count; i++) {
        CGFloat hours     = [_hoursData[i] floatValue];
        CGFloat barH      = (hours / maxHour) * chartH;
        CGFloat x         = i * (barW + 6);
        CGFloat y         = chartH - barH;
        CGRect  barRect   = CGRectMake(x, y, barW, barH);

        UIColor *color = (hours >= goalH) ? barColor : barColorGoal;
        CAShapeLayer *bar = [CAShapeLayer layer];
        bar.fillColor     = color.CGColor;
        UIBezierPath *bp  = [UIBezierPath bezierPathWithRoundedRect:barRect
                                                  byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                        cornerRadii:CGSizeMake(4, 4)];
        bar.path  = bp.CGPath;
        bar.frame = self.bounds;
        [self.layer addSublayer:bar];
        [_barLayers addObject:bar];

        // Animate bar height
        bar.opacity = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i * 0.07 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            bar.opacity = 1;
            CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
            anim.fromValue    = @0;
            anim.toValue      = @1;
            anim.duration     = 0.5;
            anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            [bar addAnimation:anim forKey:@"scaleY"];
        });

        // Day label
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(x, h - labelH, barW, labelH)];
        lbl.text          = (i < kDayLabels.count) ? kDayLabels[i] : @"";
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.font          = [UIFont systemFontOfSize:10 weight:UIFontWeightMedium];
        lbl.textColor     = [UIColor colorWithWhite:0.6 alpha:1.0];
        [self addSubview:lbl];
        [_labelViews addObject:lbl];
    }

    // Goal dashed line at 8h
    CGFloat goalY = chartH - (goalH / maxHour) * chartH;
    CAShapeLayer *goalLine = [CAShapeLayer layer];
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:CGPointMake(0, goalY)];
    [linePath addLineToPoint:CGPointMake(w, goalY)];
    goalLine.path        = linePath.CGPath;
    goalLine.strokeColor = [UIColor colorWithWhite:0.5 alpha:0.5].CGColor;
    goalLine.lineWidth   = 1;
    goalLine.lineDashPattern = @[@4, @4];
    goalLine.frame       = self.bounds;
    [self.layer addSublayer:goalLine];
}

@end
