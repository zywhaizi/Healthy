//
//  HCWaterView.m
//  健康伴侣 - 喝水波浪 View
//
//  Created by zhang, haizi on 2026/3/19.
//

#import "HCWaterView.h"

@interface HCWaterView ()
@property (nonatomic, assign) CGFloat displayLevel;
@property (nonatomic, strong) CAShapeLayer *waveLayer1;
@property (nonatomic, strong) CAShapeLayer *waveLayer2;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) CFTimeInterval startTime;
@end

@implementation HCWaterView

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
    _waterLevel   = 0;
    _displayLevel = 0;
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 16;
    self.backgroundColor = [UIColor colorWithRed:0.08 green:0.14 blue:0.26 alpha:1.0];

    _waveLayer1 = [CAShapeLayer layer];
    _waveLayer1.fillColor = [UIColor colorWithRed:0.20 green:0.56 blue:0.95 alpha:0.75].CGColor;
    [self.layer addSublayer:_waveLayer1];

    _waveLayer2 = [CAShapeLayer layer];
    _waveLayer2.fillColor = [UIColor colorWithRed:0.30 green:0.68 blue:1.0 alpha:0.5].CGColor;
    [self.layer addSublayer:_waveLayer2];

    _startTime = CACurrentMediaTime();
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)dealloc {
    [_displayLink invalidate];
}

- (void)setWaterLevel:(CGFloat)level animated:(BOOL)animated {
    _waterLevel = MAX(0.0, MIN(1.0, level));
    if (!animated) {
        _displayLevel = _waterLevel;
    }
}

- (void)setWaterLevel:(CGFloat)waterLevel {
    [self setWaterLevel:waterLevel animated:YES];
}

- (void)tick:(CADisplayLink *)link {
    CGFloat diff = _waterLevel - _displayLevel;
    _displayLevel += diff * 0.05f;
    [self drawWave];
}

- (void)drawWave {
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    if (w <= 0 || h <= 0) return;

    CFTimeInterval elapsed = CACurrentMediaTime() - _startTime;
    CGFloat waveH  = 10.0f;
    CGFloat waveL  = w * 1.5f;
    CGFloat baseY  = h * (1.0f - _displayLevel);

    // Wave 1 — faster
    CGFloat phase1 = (float)fmod(elapsed * 50.0, waveL);
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    [path1 moveToPoint:CGPointMake(-waveL + phase1, baseY)];
    for (CGFloat x = -waveL; x <= w + waveL; x += 1) {
        CGFloat y = baseY + waveH * sinf((x / waveL) * 2 * M_PI);
        [path1 addLineToPoint:CGPointMake(x + phase1, y)];
    }
    [path1 addLineToPoint:CGPointMake(w + waveL + phase1, h)];
    [path1 addLineToPoint:CGPointMake(-waveL + phase1, h)];
    [path1 closePath];
    _waveLayer1.path  = path1.CGPath;
    _waveLayer1.frame = self.bounds;

    // Wave 2 — slower, offset phase
    CGFloat phase2 = (float)fmod(elapsed * 30.0, waveL);
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    [path2 moveToPoint:CGPointMake(-waveL + phase2, baseY + 4)];
    for (CGFloat x = -waveL; x <= w + waveL; x += 1) {
        CGFloat y = (baseY + 4) + waveH * sinf((x / waveL) * 2 * M_PI + M_PI_2);
        [path2 addLineToPoint:CGPointMake(x + phase2, y)];
    }
    [path2 addLineToPoint:CGPointMake(w + waveL + phase2, h)];
    [path2 addLineToPoint:CGPointMake(-waveL + phase2, h)];
    [path2 closePath];
    _waveLayer2.path  = path2.CGPath;
    _waveLayer2.frame = self.bounds;
}

@end
