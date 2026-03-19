//
//  HCRingProgressView.m
//  健康伴侣 - 环形进度条
//
//  Created by zhang, haizi on 2026/3/19.
//

#import "HCRingProgressView.h"

@interface HCRingProgressView ()
@property (nonatomic, strong) CAShapeLayer *trackLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@end

static inline CGFloat CLAMP(CGFloat val, CGFloat lo, CGFloat hi) {
    return MAX(lo, MIN(hi, val));
}

@implementation HCRingProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _progress   = 0;
        _lineWidth  = 14;
        _ringColor  = [UIColor systemGreenColor];
        _trackColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [self setupLayers];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        _progress   = 0;
        _lineWidth  = 14;
        _ringColor  = [UIColor systemGreenColor];
        _trackColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [self setupLayers];
    }
    return self;
}

- (void)setupLayers {
    self.backgroundColor = [UIColor clearColor];

    _trackLayer = [CAShapeLayer layer];
    _trackLayer.fillColor   = [UIColor clearColor].CGColor;
    _trackLayer.strokeColor = _trackColor.CGColor;
    _trackLayer.lineWidth   = _lineWidth;
    _trackLayer.lineCap     = kCALineCapRound;
    [self.layer addSublayer:_trackLayer];

    _progressLayer = [CAShapeLayer layer];
    _progressLayer.fillColor   = [UIColor clearColor].CGColor;
    _progressLayer.strokeColor = _ringColor.CGColor;
    _progressLayer.lineWidth   = _lineWidth;
    _progressLayer.lineCap     = kCALineCapRound;
    _progressLayer.strokeEnd   = 0;
    [self.layer addSublayer:_progressLayer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    CGFloat radius = MIN(self.bounds.size.width, self.bounds.size.height) / 2 - _lineWidth / 2;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:radius
                                                    startAngle:-M_PI_2
                                                      endAngle:3 * M_PI_2
                                                     clockwise:YES];
    _trackLayer.path    = path.CGPath;
    _progressLayer.path = path.CGPath;
    _trackLayer.frame   = self.bounds;
    _progressLayer.frame = self.bounds;
}

- (void)setProgress:(CGFloat)progress {
    _progress = CLAMP(progress, 0, 1);
    _progressLayer.strokeEnd = _progress;
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {
    _progress = CLAMP(progress, 0, 1);
    if (animated) {
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        anim.fromValue = @(_progressLayer.strokeEnd);
        anim.toValue   = @(_progress);
        anim.duration  = 1.2;
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        _progressLayer.strokeEnd = _progress;
        [_progressLayer addAnimation:anim forKey:@"strokeEnd"];
    } else {
        _progressLayer.strokeEnd = _progress;
    }
}

- (void)setRingColor:(UIColor *)ringColor {
    _ringColor = ringColor;
    _progressLayer.strokeColor = ringColor.CGColor;
}

- (void)setTrackColor:(UIColor *)trackColor {
    _trackColor = trackColor;
    _trackLayer.strokeColor = trackColor.CGColor;
}

@end
