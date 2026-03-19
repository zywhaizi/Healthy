//
//  HCMoodTrendView.m
//  健康伴侣 - 心情趋势折线图
//
//  Created by zhang, haizi on 2026/3/19.
//

#import "HCMoodTrendView.h"

@interface HCMoodTrendView ()
@property (nonatomic, strong) CAShapeLayer *lineLayer;
@property (nonatomic, strong) CAShapeLayer *gradientMask;
@property (nonatomic, strong) CAGradientLayer *fillGradient;
@property (nonatomic, strong) NSMutableArray<UILabel *> *emojiLabels;
@property (nonatomic, strong) NSMutableArray<CAShapeLayer *> *dotLayers;
@end

@implementation HCMoodTrendView

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
    _emojiLabels = [NSMutableArray array];
    _dotLayers   = [NSMutableArray array];

    _fillGradient = [CAGradientLayer layer];
    _fillGradient.colors = @[
        (id)[UIColor colorWithRed:0.98 green:0.72 blue:0.30 alpha:0.45].CGColor,
        (id)[UIColor colorWithRed:0.98 green:0.72 blue:0.30 alpha:0.0].CGColor
    ];
    _fillGradient.startPoint = CGPointMake(0.5, 0);
    _fillGradient.endPoint   = CGPointMake(0.5, 1);
    [self.layer addSublayer:_fillGradient];

    _gradientMask = [CAShapeLayer layer];
    _fillGradient.mask = _gradientMask;

    _lineLayer = [CAShapeLayer layer];
    _lineLayer.strokeColor = [UIColor colorWithRed:0.98 green:0.78 blue:0.20 alpha:1.0].CGColor;
    _lineLayer.fillColor   = [UIColor clearColor].CGColor;
    _lineLayer.lineWidth   = 2.5;
    _lineLayer.lineCap     = kCALineCapRound;
    _lineLayer.lineJoin    = kCALineJoinRound;
    [self.layer addSublayer:_lineLayer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _fillGradient.frame = self.bounds;
    [self reloadData];
}

- (void)reloadData {
    for (UILabel *l in _emojiLabels) [l removeFromSuperview];
    [_emojiLabels removeAllObjects];
    for (CAShapeLayer *d in _dotLayers) [d removeFromSuperlayer];
    [_dotLayers removeAllObjects];
    _lineLayer.path    = nil;
    _gradientMask.path = nil;

    NSArray<HCMoodRecord *> *recs = _records;
    if (recs.count == 0) {
        UILabel *ph = [[UILabel alloc] initWithFrame:self.bounds];
        ph.text          = @"今日还没有心情记录 😶";
        ph.textAlignment = NSTextAlignmentCenter;
        ph.font          = [UIFont systemFontOfSize:13];
        ph.textColor     = [UIColor colorWithWhite:0.5 alpha:1.0];
        [self addSubview:ph];
        [_emojiLabels addObject:ph];
        return;
    }

    CGFloat w        = self.bounds.size.width;
    CGFloat h        = self.bounds.size.height;
    CGFloat emojiArea = 24;
    CGFloat chartH   = h - emojiArea;
    NSInteger count  = (NSInteger)recs.count;
    NSInteger maxMood = 4;
    CGFloat stepX = (count > 1) ? (w / (CGFloat)(count - 1)) : w / 2.0;

    UIBezierPath *linePath = [UIBezierPath bezierPath];
    UIBezierPath *fillPath = [UIBezierPath bezierPath];
    CGFloat firstX = 0, lastX = 0, lastY = 0;

    for (NSInteger i = 0; i < count; i++) {
        HCMoodRecord *r = recs[i];
        CGFloat x = (count == 1) ? w / 2.0 : i * stepX;
        CGFloat ratio = (CGFloat)r.moodType / (CGFloat)maxMood;
        CGFloat y = chartH - ratio * (chartH - 20) - 10;

        if (i == 0) {
            [linePath moveToPoint:CGPointMake(x, y)];
            [fillPath moveToPoint:CGPointMake(x, y)];
            firstX = x;
        } else {
            [linePath addLineToPoint:CGPointMake(x, y)];
            [fillPath addLineToPoint:CGPointMake(x, y)];
        }
        lastX = x;
        lastY = y;

        // Dot
        CAShapeLayer *dot = [CAShapeLayer layer];
        CGFloat dotR = 4;
        dot.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x - dotR, y - dotR, dotR*2, dotR*2)].CGPath;
        dot.fillColor = [UIColor colorWithRed:0.98 green:0.78 blue:0.20 alpha:1.0].CGColor;
        dot.frame = self.bounds;
        [self.layer addSublayer:dot];
        [_dotLayers addObject:dot];

        // Emoji label
        UILabel *emoji = [[UILabel alloc] initWithFrame:CGRectMake(x - 12, h - emojiArea, 24, emojiArea)];
        emoji.text          = [r emojiString];
        emoji.textAlignment = NSTextAlignmentCenter;
        emoji.font          = [UIFont systemFontOfSize:15];
        [self addSubview:emoji];
        [_emojiLabels addObject:emoji];
    }
    (void)lastY;

    // Close fill path to bottom
    [fillPath addLineToPoint:CGPointMake(lastX, chartH)];
    [fillPath addLineToPoint:CGPointMake(firstX, chartH)];
    [fillPath closePath];

    _lineLayer.path    = linePath.CGPath;
    _lineLayer.frame   = self.bounds;
    _gradientMask.path = fillPath.CGPath;
    _gradientMask.frame = self.bounds;

    // Animate line draw
    CABasicAnimation *drawAnim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnim.fromValue = @0;
    drawAnim.toValue   = @1;
    drawAnim.duration  = 0.8;
    drawAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [_lineLayer addAnimation:drawAnim forKey:@"draw"];
}

@end
