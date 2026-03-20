//
//  HDWaterView.m
//  HealthDashboard - 喝水波浪动画
//
//  Created by zhang, haizi on 2026/3/19.
//

#import "HDWaterView.h"

@interface HDWaterView ()
@property (nonatomic, assign) CGFloat level;
@property (nonatomic, strong) CAShapeLayer *waveLayer;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) CGFloat waveOffset;
@end

@implementation HDWaterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds  = YES;
        self.layer.cornerRadius = 8;
        self.backgroundColor = [UIColor colorWithRed:0.10 green:0.18 blue:0.30 alpha:1.0];
        _level = 0.3;

        _waveLayer = [CAShapeLayer layer];
        _waveLayer.fillColor = [UIColor colorWithRed:0.20 green:0.60 blue:0.95 alpha:0.75].CGColor;
        [self.layer addSublayer:_waveLayer];

        // 波浪动画定时器
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateWave)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (void)updateWave {
    _waveOffset += 0.03;
    [self drawWave];
}

- (void)drawWave {
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    CGFloat waterY = h * (1 - _level);
    CGFloat amplitude = 4.0;

    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, waterY)];
    for (CGFloat x = 0; x <= w; x++) {
        CGFloat y = waterY + amplitude * sin((x / w * 2 * M_PI) + _waveOffset);
        [path addLineToPoint:CGPointMake(x, y)];
    }
    [path addLineToPoint:CGPointMake(w, h)];
    [path addLineToPoint:CGPointMake(0, h)];
    [path closePath];
    _waveLayer.path = path.CGPath;
}

- (void)setWaterLevel:(CGFloat)level animated:(BOOL)animated {
    _level = MAX(0, MIN(1, level));
}

- (void)dealloc {
    [_displayLink invalidate];
}

@end
