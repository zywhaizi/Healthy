//
//  HCProfileViewController.m
//  健康伴侣 - 个人中心
//
//  Created by zhang, haizi on 2026/3/19.
//

#import "HCProfileViewController.h"
#import "../Models/HCHealthDataModel.h"

@interface HCProfileViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel      *themeValueLabel;
@end

@implementation HCProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupScrollView];
    [self buildAvatarHeader];
    [self buildStatsRow];
    [self buildThemeCard];
    [self buildGoalCards];
    [self applyTheme];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self applyTheme];
}

- (void)setupScrollView {
    CGFloat sw = self.view.bounds.size.width;
    CGFloat sh = self.view.bounds.size.height;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, sw, sh)];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.alwaysBounceVertical = YES;
    _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self.view addSubview:_scrollView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UIEdgeInsets safe = self.view.safeAreaInsets;
    _scrollView.contentInset = UIEdgeInsetsMake(safe.top, 0, safe.bottom, 0);
}

- (void)buildAvatarHeader {
    CGFloat sw = self.view.bounds.size.width;
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sw, 220)];
    CAGradientLayer *g = [CAGradientLayer layer];
    g.frame  = bg.bounds;
    g.colors = @[(id)[UIColor colorWithRed:0.14 green:0.22 blue:0.42 alpha:1.0].CGColor,
                 (id)[UIColor colorWithRed:0.08 green:0.12 blue:0.22 alpha:1.0].CGColor];
    g.startPoint = CGPointMake(0,0); g.endPoint = CGPointMake(1,1);
    [bg.layer addSublayer:g];
    [_scrollView addSubview:bg];

    UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(sw/2-44, 36, 88, 88)];
    circle.backgroundColor    = [UIColor colorWithRed:0.22 green:0.54 blue:0.95 alpha:0.20];
    circle.layer.cornerRadius = 44;
    circle.layer.borderWidth  = 3;
    circle.layer.borderColor  = [UIColor colorWithRed:0.22 green:0.54 blue:0.95 alpha:0.75].CGColor;
    [_scrollView addSubview:circle];

    UILabel *emojiLbl = [[UILabel alloc] initWithFrame:CGRectMake(sw/2-44, 36, 88, 88)];
    emojiLbl.text = @"\U0001f9d1";
    emojiLbl.font = [UIFont systemFontOfSize:48];
    emojiLbl.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:emojiLbl];

    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, 136, sw, 28)];
    name.text = @"\u5065\u5eb7\u8fbe\u4eba"; // 健康达人
    name.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
    name.textColor = [UIColor whiteColor];
    name.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:name];

    UILabel *sub = [[UILabel alloc] initWithFrame:CGRectMake(0, 166, sw, 20)];
    sub.text = @"\u5750\u6301\u5065\u5eb7\u751f\u6d3b\u6bcf\u4e00\u5929 \U0001f31f";
    sub.font = [UIFont systemFontOfSize:13];
    sub.textColor = [UIColor colorWithWhite:0.62 alpha:1.0];
    sub.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:sub];
}
- (void)buildStatsRow {
    CGFloat sw = self.view.bounds.size.width, pad = 16;
    HCHealthDataModel *m = [HCHealthDataModel shared];
    UIView *row = [[UIView alloc] initWithFrame:CGRectMake(pad, 228, sw-pad*2, 80)];
    row.backgroundColor    = [UIColor colorWithRed:0.12 green:0.16 blue:0.24 alpha:1.0];
    row.layer.cornerRadius = 16;
    [_scrollView addSubview:row];

    NSArray *vals   = @[[NSString stringWithFormat:@"%ld", (long)m.todaySteps],
                        [NSString stringWithFormat:@"%.0f", m.waterML],
                        [NSString stringWithFormat:@"%.1fh", [m.sleepHours.lastObject floatValue]]];
    NSArray *labels = @[@"\u6b65\u6570", @"\u996e\u6c34(ml)", @"\u7761\u7720"];
    CGFloat colW = (sw-pad*2) / 3;
    for (NSInteger i = 0; i < 3; i++) {
        CGFloat x = i * colW;
        if (i > 0) {
            UIView *div = [[UIView alloc] initWithFrame:CGRectMake(x, 14, 1, 52)];
            div.backgroundColor = [UIColor colorWithWhite:0.25 alpha:1.0];
            [row addSubview:div];
        }
        UILabel *vl = [[UILabel alloc] initWithFrame:CGRectMake(x, 14, colW, 32)];
        vl.text = vals[i]; vl.font = [UIFont monospacedDigitSystemFontOfSize:22 weight:UIFontWeightBold];
        vl.textColor = [UIColor whiteColor]; vl.textAlignment = NSTextAlignmentCenter;
        [row addSubview:vl];
        UILabel *ll = [[UILabel alloc] initWithFrame:CGRectMake(x, 48, colW, 18)];
        ll.text = labels[i]; ll.font = [UIFont systemFontOfSize:11];
        ll.textColor = [UIColor colorWithWhite:0.50 alpha:1.0]; ll.textAlignment = NSTextAlignmentCenter;
        [row addSubview:ll];
    }
}
- (void)buildThemeCard {
    CGFloat sw = self.view.bounds.size.width, pad = 16;
    UIView *card = [[UIView alloc] initWithFrame:CGRectMake(pad, 324, sw-pad*2, 64)];
    card.backgroundColor    = [UIColor colorWithRed:0.12 green:0.16 blue:0.24 alpha:1.0];
    card.layer.cornerRadius = 16;
    [_scrollView addSubview:card];

    UILabel *icon = [[UILabel alloc] initWithFrame:CGRectMake(16, 14, 36, 36)];
    icon.text = @"\U0001f319"; icon.font = [UIFont systemFontOfSize:22]; icon.textAlignment = NSTextAlignmentCenter;
    [card addSubview:icon];

    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(58, 21, 150, 22)];
    lbl.text = @"\u6df1\u8272/\u6d45\u8272\u6a21\u5f0f"; // 深色/浅色模式
    lbl.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    lbl.textColor = [UIColor whiteColor];
    [card addSubview:lbl];

    _themeValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(sw-pad*2-100, 21, 70, 22)];
    _themeValueLabel.text = [HCHealthDataModel shared].isDarkMode ? @"\U0001f319 \u591c\u95f4" : @"\u2600\ufe0f \u65e5\u95f4";
    _themeValueLabel.font = [UIFont systemFontOfSize:13];
    _themeValueLabel.textColor = [UIColor colorWithWhite:0.55 alpha:1.0];
    _themeValueLabel.textAlignment = NSTextAlignmentRight;
    [card addSubview:_themeValueLabel];

    UISwitch *sw2 = [[UISwitch alloc] init];
    sw2.center = CGPointMake(sw-pad*2-24, 32);
    sw2.on     = [HCHealthDataModel shared].isDarkMode;
    sw2.onTintColor = [UIColor colorWithRed:0.22 green:0.54 blue:0.95 alpha:1.0];
    [sw2 addTarget:self action:@selector(themeSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    [card addSubview:sw2];
}
- (void)buildGoalCards {
    CGFloat sw = self.view.bounds.size.width, pad = 16;
    NSArray *icons   = @[@"\U0001f45f", @"\U0001f4a7", @"\U0001f319"];
    NSArray *titles  = @[@"\u6b65\u6570\u76ee\u6807", @"\u996e\u6c34\u76ee\u6807", @"\u7761\u7720\u76ee\u6807"];
    NSArray *values  = @[@"10,000 \u6b65", @"2,000 ml", @"8 \u5c0f\u65f6"];
    NSArray *subtitles = @[@"\u6bcf\u65e5\u5efa\u8bae", @"\u6bcf\u65e5\u5efa\u8bae", @"\u4f18\u8d28\u7761\u7720"];

    for (NSInteger i = 0; i < 3; i++) {
        UIView *c = [[UIView alloc] initWithFrame:CGRectMake(pad, 404 + i*76, sw-pad*2, 64)];
        c.backgroundColor    = [UIColor colorWithRed:0.12 green:0.16 blue:0.24 alpha:1.0];
        c.layer.cornerRadius = 16;
        [_scrollView addSubview:c];

        UILabel *iLbl = [[UILabel alloc] initWithFrame:CGRectMake(16,14,36,36)];
        iLbl.text=icons[i]; iLbl.font=[UIFont systemFontOfSize:22]; iLbl.textAlignment=NSTextAlignmentCenter;
        [c addSubview:iLbl];

        UILabel *tLbl = [[UILabel alloc] initWithFrame:CGRectMake(58,12,sw-pad*2-160,20)];
        tLbl.text=titles[i]; tLbl.font=[UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        tLbl.textColor=[UIColor whiteColor]; [c addSubview:tLbl];

        UILabel *sLbl = [[UILabel alloc] initWithFrame:CGRectMake(58,34,sw-pad*2-160,16)];
        sLbl.text=subtitles[i]; sLbl.font=[UIFont systemFontOfSize:11];
        sLbl.textColor=[UIColor colorWithWhite:0.45 alpha:1.0]; [c addSubview:sLbl];

        UILabel *vLbl = [[UILabel alloc] initWithFrame:CGRectMake(sw-pad*2-120,18,110,28)];
        vLbl.text=values[i]; vLbl.font=[UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
        vLbl.textColor=[UIColor colorWithRed:0.22 green:0.82 blue:0.55 alpha:1.0];
        vLbl.textAlignment=NSTextAlignmentRight; [c addSubview:vLbl];
    }
    _scrollView.contentSize = CGSizeMake(sw, 680);
}

- (void)themeSwitchChanged:(UISwitch *)sw {
    [HCHealthDataModel shared].isDarkMode = sw.isOn;
    [[HCHealthDataModel shared] save];
    _themeValueLabel.text = sw.isOn ? @"\U0001f319 \u591c\u95f4" : @"\u2600\ufe0f \u65e5\u95f4";
    [self applyTheme];
    // Notify root to update all tabs
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HCThemeDidChange" object:nil];
}

- (void)applyTheme {
    BOOL dark = [HCHealthDataModel shared].isDarkMode;
    UIColor *bg = dark ? [UIColor colorWithRed:0.06 green:0.08 blue:0.14 alpha:1.0]
                       : [UIColor colorWithRed:0.93 green:0.95 blue:0.97 alpha:1.0];
    self.view.backgroundColor   = bg;
    _scrollView.backgroundColor = bg;
}

@end

