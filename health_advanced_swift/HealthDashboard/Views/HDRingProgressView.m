//
//  HDRingProgressView.m
//  HealthDashboard - 环形进度条
//
//  Created by zhang, haizi on 2026/3/19.
//

#import "HDRingProgressView.h"

@interface HDRingProgressView ()
@property (nonatomic, strong) CAShapeLayer *trackLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, assign) CGFloat _progress;
@end

@implementation HDRingProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _ringColor  = [UIColor colorWithRed:0.22 green:0.82 blue:0.55 alpha:1.0];
        _trackColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        _lineWidth  = 10;

        // 轨道层
        _trackLayer = [CAShapeLayer layer];
        _trackLayer.fillColor   = UIColor.clearColor.CGColor;
        _trackLayer.strokeColor = _trackColor.CGColor;
        _trackLayer.lineWidth   = _lineWidth;
        _trackLayer.lineCap     = kCALineCapRound;
        [self.layer addSublayer:_trackLayer];

        // 进度层
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.fillColor   = UIColor.clearColor.CGColor;
        _progressLayer.strokeColor = _ringColor.CGColor;
        _progressLayer.lineWidth   = _lineWidth;
        _progressLayer.lineCap     = kCALineCapRound;
        _progressLayer.strokeEnd   = 0;
        [self.layer addSublayer:_progressLayer];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGFloat radius = (MIN(self.bounds.size.width, self.bounds.size.height) - _lineWidth) / 2.0;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:radius
                                                    startAngle:-M_PI_2
                                                      endAngle:3*M_PI_2
                                                     clockwise:YES];
    _trackLayer.path    = path.CGPath;
    _progressLayer.path = path.CGPath;
    _trackLayer.lineWidth    = _lineWidth;
    _progressLayer.lineWidth = _lineWidth;
    _trackLayer.strokeColor    = _trackColor.CGColor;
    _progressLayer.strokeColor = _ringColor.CGColor;
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {
    __progress = MAX(0, MIN(1, progress));
    if (animated) {
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        anim.fromValue = @(_progressLayer.strokeEnd);
        anim.toValue   = @(__progress);
        anim.duration  = 0.8;
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [_progressLayer addAnimation:anim forKey:@"progress"];
    }
    _progressLayer.strokeEnd = __progress;
}

- (CGFloat)progress { return __progress; }

@end
