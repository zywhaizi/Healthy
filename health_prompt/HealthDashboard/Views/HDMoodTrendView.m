//
//  HDMoodTrendView.m
//  HealthDashboard - 心情趋势折线图
//
//  Created by zhang, haizi on 2026/3/19.
//

#import "HDMoodTrendView.h"

@implementation HDMoodTrendView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) { self.backgroundColor = [UIColor clearColor]; }
    return self;
}

- (void)reloadData { [self setNeedsDisplay]; }

- (void)drawRect:(CGRect)rect {
    if (!_records.count) return;
    NSInteger count = MIN(7, (NSInteger)_records.count);
    NSInteger start = _records.count - count;
    CGFloat w = rect.size.width;
    CGFloat h = rect.size.height;
    CGFloat stepX = w / (count - 1 > 0 ? count - 1 : 1);

    // 绘制折线
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    linePath.lineWidth = 2;
    [[UIColor colorWithRed:0.38 green:0.75 blue:0.95 alpha:1.0] setStroke];

    NSMutableArray *points = [NSMutableArray array];
    for (NSInteger i = 0; i < count; i++) {
        HDMoodRecord *r = _records[start + i];
        CGFloat x = i * stepX;
        CGFloat y = h - (r.moodLevel / 5.0) * (h - 16) - 8;
        CGPoint pt = CGPointMake(x, y);
        [points addObject:[NSValue valueWithCGPoint:pt]];
        if (i == 0) [linePath moveToPoint:pt];
        else        [linePath addLineToPoint:pt];
    }
    [linePath stroke];

    // 绘制节点和表情
    for (NSInteger i = 0; i < count; i++) {
        HDMoodRecord *r = _records[start + i];
        CGPoint pt = [points[i] CGPointValue];

        // 节点圆
        UIBezierPath *dot = [UIBezierPath bezierPathWithArcCenter:pt radius:4 startAngle:0 endAngle:2*M_PI clockwise:YES];
        [[UIColor colorWithRed:0.22 green:0.54 blue:0.95 alpha:1.0] setFill];
        [dot fill];

        // 表情文字（最后一个节点显示）
        if (i == count - 1) {
            NSString *emoji = r.emojiString;
            [emoji drawAtPoint:CGPointMake(pt.x - 8, pt.y - 22)
                withAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]}];
        }
    }
}

@end
