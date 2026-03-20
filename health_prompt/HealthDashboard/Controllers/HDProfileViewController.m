//
//  HDProfileViewController.m
//  HealthDashboard - 个人中心
//
//  Created by zhang, haizi on 2026/3/19.
//

#import "HDProfileViewController.h"
#import "../Models/HDHealthDataModel.h"

@interface HDProfileViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView       *contentView;
@property (nonatomic, strong) UISwitch     *themeSwitch;
@end

@implementation HDProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupScrollView];
    [self buildContent];
    [self applyTheme];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self applyTheme];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _scrollView.frame = self.view.bounds;
}

- (void)setupScrollView {
    CGFloat sw = UIScreen.mainScreen.bounds.size.width;
    CGFloat sh = UIScreen.mainScreen.bounds.size.height;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,sw,sh)];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0,0,sw,600)];
    [_scrollView addSubview:_contentView];
    _scrollView.contentSize = CGSizeMake(sw, 600);
}

- (void)buildContent {
    CGFloat sw = self.view.bounds.size.width;
    CGFloat topY = 60;

    // 页面标题
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, topY, sw-40, 40)];
    title.tag  = 801;
    title.text = @"个人中心";
    title.font = [UIFont systemFontOfSize:28 weight:UIFontWeightHeavy];
    title.textColor = UIColor.whiteColor;
    [_contentView addSubview:title];

    // 头像
    UIView *avatar = [[UIView alloc] initWithFrame:CGRectMake(sw/2-44, topY+58, 88, 88)];
    avatar.backgroundColor    = [UIColor colorWithRed:0.22 green:0.54 blue:0.95 alpha:1];
    avatar.layer.cornerRadius = 44;
    [_contentView addSubview:avatar];
    UILabel *avatarEmoji = [[UILabel alloc] initWithFrame:avatar.bounds];
    avatarEmoji.text = @"😊";
    avatarEmoji.font = [UIFont systemFontOfSize:44];
    avatarEmoji.textAlignment = NSTextAlignmentCenter;
    [avatar addSubview:avatarEmoji];

    // 用户名
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(20, topY+158, sw-40, 28)];
    name.tag  = 802;
    name.text = @"健康达人";
    name.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
    name.textColor     = UIColor.whiteColor;
    name.textAlignment = NSTextAlignmentCenter;
    [_contentView addSubview:name];

    // 统计行
    HDHealthDataModel *m = [HDHealthDataModel shared];
    NSArray *statTitles = @[@"今日步数", @"喝水", @"睡眠"];
    NSArray *statValues = @[
        [NSString stringWithFormat:@"%ld", (long)m.todaySteps],
        [NSString stringWithFormat:@"%.0fml", m.waterML],
        [NSString stringWithFormat:@"%.1fh", [m.sleepHours.lastObject floatValue]]
    ];
    CGFloat itemW = sw / 3.0;
    CGFloat statsY = topY + 200;
    for (NSInteger i = 0; i < 3; i++) {
        UILabel *val = [[UILabel alloc] initWithFrame:CGRectMake(i*itemW, statsY, itemW, 32)];
        val.text = statValues[i];
        val.font = [UIFont monospacedDigitSystemFontOfSize:20 weight:UIFontWeightBold];
        val.textColor = [UIColor colorWithRed:0.22 green:0.54 blue:0.95 alpha:1];
        val.textAlignment = NSTextAlignmentCenter;
        [_contentView addSubview:val];

        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(i*itemW, statsY+34, itemW, 18)];
        lbl.text = statTitles[i];
        lbl.font = [UIFont systemFontOfSize:12];
        lbl.textColor = [UIColor colorWithWhite:0.55 alpha:1];
        lbl.textAlignment = NSTextAlignmentCenter;
        [_contentView addSubview:lbl];
    }

    // 夜间模式卡片
    CGFloat themeY = statsY + 72;
    UIView *themeCard = [[UIView alloc] initWithFrame:CGRectMake(16, themeY, sw-32, 64)];
    themeCard.tag = 820;
    themeCard.backgroundColor    = [UIColor colorWithRed:0.12 green:0.16 blue:0.24 alpha:1];
    themeCard.layer.cornerRadius = 16;
    [_contentView addSubview:themeCard];

    UILabel *themeLbl = [[UILabel alloc] initWithFrame:CGRectMake(16, 18, sw-100, 28)];
    themeLbl.tag  = 821;
    themeLbl.text = @"🌙  夜间模式";
    themeLbl.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    themeLbl.textColor = UIColor.whiteColor;
    [themeCard addSubview:themeLbl];

    _themeSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(sw-32-70, 16, 51, 31)];
    _themeSwitch.on = m.isDarkMode;
    _themeSwitch.onTintColor = [UIColor colorWithRed:0.22 green:0.54 blue:0.95 alpha:1];
    [_themeSwitch addTarget:self action:@selector(themeSwitchChanged) forControlEvents:UIControlEventValueChanged];
    [themeCard addSubview:_themeSwitch];

    // 目标卡片
    CGFloat goalY = themeY + 80;
    UIView *goalCard = [[UIView alloc] initWithFrame:CGRectMake(16, goalY, sw-32, 120)];
    goalCard.tag = 830;
    goalCard.backgroundColor    = [UIColor colorWithRed:0.12 green:0.16 blue:0.24 alpha:1];
    goalCard.layer.cornerRadius = 16;
    [_contentView addSubview:goalCard];

    UILabel *goalTitle = [[UILabel alloc] initWithFrame:CGRectMake(16, 14, sw-64, 22)];
    goalTitle.tag  = 831;
    goalTitle.text = @"🎯  我的目标";
    goalTitle.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    goalTitle.textColor = UIColor.whiteColor;
    [goalCard addSubview:goalTitle];

    NSArray *goals = @[
        [NSString stringWithFormat:@"每日步数：%ld 步", (long)m.stepsGoal],
        [NSString stringWithFormat:@"每日喝水：%.0f ml", m.waterGoalML]
    ];
    for (NSInteger i = 0; i < 2; i++) {
        UILabel *gl = [[UILabel alloc] initWithFrame:CGRectMake(16, 44 + i*32, sw-64, 24)];
        gl.text = goals[i];
        gl.font = [UIFont systemFontOfSize:14];
        gl.textColor = [UIColor colorWithWhite:0.70 alpha:1];
        [goalCard addSubview:gl];
    }
}

#pragma mark - 主题切换

- (void)themeSwitchChanged {
    [HDHealthDataModel shared].isDarkMode = _themeSwitch.isOn;
    [self applyTheme];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HDThemeDidChange" object:nil];
}

- (void)applyTheme {
    BOOL dark = [HDHealthDataModel shared].isDarkMode;
    UIColor *bg    = dark ? [UIColor colorWithRed:0.06 green:0.08 blue:0.14 alpha:1.0]
                          : [UIColor colorWithRed:0.93 green:0.95 blue:0.97 alpha:1.0];
    UIColor *cardC = dark ? [UIColor colorWithRed:0.12 green:0.16 blue:0.24 alpha:1.0] : UIColor.whiteColor;
    UIColor *textC = dark ? UIColor.whiteColor : [UIColor colorWithRed:0.10 green:0.12 blue:0.18 alpha:1.0];

    self.view.backgroundColor    = bg;
    _scrollView.backgroundColor  = bg;
    _contentView.backgroundColor = bg;

    // 标题
    UILabel *title = (UILabel *)[_contentView viewWithTag:801];
    if (title) title.textColor = textC;
    UILabel *name = (UILabel *)[_contentView viewWithTag:802];
    if (name) name.textColor = textC;

    // 夜间模式卡片
    UIView *themeCard = [_contentView viewWithTag:820];
    if (themeCard) themeCard.backgroundColor = cardC;
    UILabel *themeLbl = (UILabel *)[_contentView viewWithTag:821];
    if (themeLbl) themeLbl.textColor = textC;

    // 目标卡片
    UIView *goalCard = [_contentView viewWithTag:830];
    if (goalCard) goalCard.backgroundColor = cardC;
    UILabel *goalTitle = (UILabel *)[_contentView viewWithTag:831];
    if (goalTitle) goalTitle.textColor = textC;

    _themeSwitch.on = dark;
}

@end
