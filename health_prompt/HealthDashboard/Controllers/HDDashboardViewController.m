//
//  HDDashboardViewController.m
//  HealthDashboard - 首页仪表盘
//
//  Created by zhang, haizi on 2026/3/19.
//

#import "HDDashboardViewController.h"
#import "HDQuickAddViewController.h"
#import "../Models/HDHealthDataModel.h"
#import "../Views/HDRingProgressView.h"
#import "../Views/HDWaterView.h"
#import "../Views/HDSleepBarView.h"
#import "../Views/HDMoodTrendView.h"
#import "../Views/HDDashboardCardView.h"

@interface HDDashboardViewController () <HDQuickAddDelegate>
@property (nonatomic, strong) UIScrollView        *scrollView;
@property (nonatomic, strong) UIView              *contentView;
@property (nonatomic, strong) HDDashboardCardView *stepsCard;
@property (nonatomic, strong) HDDashboardCardView *waterCard;
@property (nonatomic, strong) HDDashboardCardView *sleepCard;
@property (nonatomic, strong) HDDashboardCardView *moodCard;
@property (nonatomic, strong) HDRingProgressView  *ringView;
@property (nonatomic, strong) UILabel             *stepsLabel;
@property (nonatomic, strong) UILabel             *stepsSubLabel;
@property (nonatomic, strong) HDWaterView         *waterWave;
@property (nonatomic, strong) UILabel             *waterLabel;
@property (nonatomic, strong) HDSleepBarView      *sleepBar;
@property (nonatomic, strong) HDMoodTrendView     *moodTrend;
@property (nonatomic, strong) UIButton            *fabButton;
@end

@implementation HDDashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.view.backgroundColor = [UIColor colorWithRed:0.06 green:0.08 blue:0.14 alpha:1.0];
    [self setupScrollView];
    [self buildHeader];
    [self buildStepsCard];
    [self buildWaterCard];
    [self buildSleepCard];
    [self buildMoodCard];
    [self buildFAB];
    [self refreshAll];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshAll)
                                                 name:@"HDDataDidChange"
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self applyTheme];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _scrollView.frame = self.view.bounds;
    UIEdgeInsets safe = self.view.safeAreaInsets;
    CGFloat sw = self.view.bounds.size.width;
    CGFloat sh = self.view.bounds.size.height;
    CGFloat tabBarH = self.tabBarController.tabBar.frame.size.height;
    if (tabBarH < 1) tabBarH = safe.bottom + 49.0;
    _fabButton.frame = CGRectMake(sw - 76, sh - tabBarH - 72, 56, 56);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - ScrollView

- (void)setupScrollView {
    CGFloat sw = UIScreen.mainScreen.bounds.size.width;
    CGFloat sh = UIScreen.mainScreen.bounds.size.height;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, sw, sh)];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:_scrollView];
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sw, 900)];
    [_scrollView addSubview:_contentView];
    _scrollView.contentSize = CGSizeMake(sw, 900);
}

#pragma mark - Header

- (void)buildHeader {
    CGFloat sw = self.view.bounds.size.width;
    CGFloat topY = 54 + 12; // safeArea top 默认54
    NSDateFormatter *df = [NSDateFormatter new];
    df.dateFormat = @"MM月dd日";
    UILabel *dateLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, topY, sw-40, 20)];
    dateLbl.text      = [NSString stringWithFormat:@"今天 · %@", [df stringFromDate:[NSDate date]]];
    dateLbl.font      = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
    dateLbl.textColor = [UIColor colorWithWhite:0.55 alpha:1.0];
    [_contentView addSubview:dateLbl];

    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, topY+22, sw-40, 40)];
    titleLbl.tag       = 902;
    titleLbl.text      = @"健康仪表盘";
    titleLbl.font      = [UIFont systemFontOfSize:28 weight:UIFontWeightHeavy];
    titleLbl.textColor = [UIColor whiteColor];
    [_contentView addSubview:titleLbl];
}

#pragma mark - 步数卡片

- (void)buildStepsCard {
    CGFloat sw = self.view.bounds.size.width, pad = 16;
    CGFloat topY = 54 + 90;
    _stepsCard = [[HDDashboardCardView alloc] initWithTitle:@"今日步数" iconEmoji:@"👟"];
    _stepsCard.frame = CGRectMake(pad, topY, sw-pad*2, 180);
    [_contentView addSubview:_stepsCard];

    CGFloat rs = 110;
    _ringView = [[HDRingProgressView alloc] initWithFrame:CGRectMake(16, 56, rs, rs)];
    _ringView.ringColor  = [UIColor colorWithRed:0.22 green:0.82 blue:0.55 alpha:1.0];
    _ringView.trackColor = [UIColor colorWithWhite:0.18 alpha:1.0];
    _ringView.lineWidth  = 12;
    [_stepsCard addContentView:_ringView];

    CGFloat textX = rs+32, textW = sw-pad*2-textX-16;
    _stepsLabel = [[UILabel alloc] initWithFrame:CGRectMake(textX, 60, textW, 52)];
    _stepsLabel.font = [UIFont monospacedDigitSystemFontOfSize:42 weight:UIFontWeightBold];
    _stepsLabel.textColor = [UIColor whiteColor];
    _stepsLabel.adjustsFontSizeToFitWidth = YES;
    [_stepsCard addContentView:_stepsLabel];

    _stepsSubLabel = [[UILabel alloc] initWithFrame:CGRectMake(textX, 116, textW, 20)];
    _stepsSubLabel.font      = [UIFont systemFontOfSize:12];
    _stepsSubLabel.textColor = [UIColor colorWithWhite:0.55 alpha:1.0];
    [_stepsCard addContentView:_stepsSubLabel];

    UILabel *pct = [[UILabel alloc] initWithFrame:CGRectMake(16, 56+rs/2-10, rs, 20)];
    pct.tag = 901;
    pct.textAlignment = NSTextAlignmentCenter;
    pct.font = [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
    pct.textColor = [UIColor colorWithWhite:0.68 alpha:1.0];
    [_stepsCard addContentView:pct];
}

#pragma mark - 喝水卡片

- (void)buildWaterCard {
    CGFloat sw = self.view.bounds.size.width, pad = 16;
    CGFloat topY = 54 + 90 + 196;
    _waterCard = [[HDDashboardCardView alloc] initWithTitle:@"今日喝水" iconEmoji:@"💧"];
    _waterCard.frame = CGRectMake(pad, topY, sw-pad*2, 150);
    [_contentView addSubview:_waterCard];

    CGFloat ww = sw-pad*2-32;
    _waterWave = [[HDWaterView alloc] initWithFrame:CGRectMake(16, 56, ww, 72)];
    [_waterCard addContentView:_waterWave];

    _waterLabel = [[UILabel alloc] initWithFrame:CGRectMake(ww-114, 64, 114, 24)];
    _waterLabel.textAlignment = NSTextAlignmentRight;
    _waterLabel.font = [UIFont monospacedDigitSystemFontOfSize:17 weight:UIFontWeightBold];
    _waterLabel.textColor = [UIColor whiteColor];
    [_waterCard addContentView:_waterLabel];
}

#pragma mark - 睡眠卡片

- (void)buildSleepCard {
    CGFloat sw = self.view.bounds.size.width, pad = 16;
    CGFloat topY = 54 + 90 + 196 + 166;
    _sleepCard = [[HDDashboardCardView alloc] initWithTitle:@"近7天睡眠" iconEmoji:@"🌙"];
    _sleepCard.frame = CGRectMake(pad, topY, sw-pad*2, 170);
    [_contentView addSubview:_sleepCard];
    _sleepBar = [[HDSleepBarView alloc] initWithFrame:CGRectMake(16, 56, sw-pad*2-32, 100)];
    [_sleepCard addContentView:_sleepBar];
}

#pragma mark - 心情卡片

- (void)buildMoodCard {
    CGFloat sw = self.view.bounds.size.width, pad = 16;
    CGFloat topY = 54 + 90 + 196 + 166 + 186;
    _moodCard = [[HDDashboardCardView alloc] initWithTitle:@"今日心情" iconEmoji:@"🌟"];
    _moodCard.frame = CGRectMake(pad, topY, sw-pad*2, 160);
    [_contentView addSubview:_moodCard];
    _moodTrend = [[HDMoodTrendView alloc] initWithFrame:CGRectMake(16, 56, sw-pad*2-32, 90)];
    [_moodCard addContentView:_moodTrend];
}

#pragma mark - FAB

- (void)buildFAB {
    CGFloat sw = self.view.bounds.size.width;
    CGFloat sh = self.view.bounds.size.height;
    CGFloat tabBarH = self.tabBarController.tabBar.frame.size.height ?: 83.0;
    _fabButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _fabButton.frame = CGRectMake(sw-76, sh-tabBarH-72, 56, 56);
    _fabButton.backgroundColor    = [UIColor colorWithRed:0.22 green:0.54 blue:0.95 alpha:1.0];
    _fabButton.layer.cornerRadius = 28;
    _fabButton.layer.shadowColor  = [UIColor colorWithRed:0.22 green:0.54 blue:0.95 alpha:0.55].CGColor;
    _fabButton.layer.shadowOpacity = 0.9;
    _fabButton.layer.shadowRadius  = 14;
    _fabButton.layer.shadowOffset  = CGSizeMake(0, 4);
    [_fabButton setTitle:@"+" forState:UIControlStateNormal];
    _fabButton.titleLabel.font = [UIFont systemFontOfSize:30 weight:UIFontWeightLight];
    [_fabButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_fabButton addTarget:self action:@selector(fabTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_fabButton];
}

#pragma mark - 刷新数据

- (void)refreshAll {
    HDHealthDataModel *m = [HDHealthDataModel shared];
    _stepsLabel.text    = [NSString stringWithFormat:@"%ld", (long)m.todaySteps];
    _stepsSubLabel.text = [NSString stringWithFormat:@"目标%ld步 · 消耗%.0f千卡", (long)m.stepsGoal, [m caloryForSteps:m.todaySteps]];
    [_ringView setProgress:m.stepsProgress animated:YES];
    UILabel *pct = (UILabel *)[_stepsCard viewWithTag:901];
    pct.text = [NSString stringWithFormat:@"%.0f%%", m.stepsProgress*100];

    [_waterWave setWaterLevel:m.waterProgress animated:YES];
    _waterLabel.text = [NSString stringWithFormat:@"%.0f/%.0fml", m.waterML, m.waterGoalML];
    _waterCard.subtitleLabel.text = [NSString stringWithFormat:@"已喝 %.0f ml", m.waterML];

    _sleepBar.hoursData = m.sleepHours;
    [_sleepBar reloadData];
    CGFloat last = [m.sleepHours.lastObject floatValue];
    _sleepCard.subtitleLabel.text = [NSString stringWithFormat:@"昨晚 %.1f 小时", last];

    _moodTrend.records = m.moodRecords;
    [_moodTrend reloadData];
    HDMoodRecord *latest = m.latestMood;
    _moodCard.subtitleLabel.text = latest
        ? [NSString stringWithFormat:@"最新: %@", latest.emojiString]
        : @"今天还没记录心情";
}

#pragma mark - 主题

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (@available(iOS 13.0, *)) {
        return [HDHealthDataModel shared].isDarkMode ? UIStatusBarStyleLightContent : UIStatusBarStyleDarkContent;
    }
    return UIStatusBarStyleLightContent;
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
    UILabel *title = (UILabel *)[_contentView viewWithTag:902];
    if (title) title.textColor = textC;
    for (HDDashboardCardView *c in @[_stepsCard, _waterCard, _sleepCard, _moodCard]) {
        c.backgroundColor = cardC;
        c.titleLabel.textColor = textC;
    }
    _stepsLabel.textColor = textC;
    _waterLabel.textColor = textC;
    _ringView.trackColor  = dark ? [UIColor colorWithWhite:0.18 alpha:1.0] : [UIColor colorWithWhite:0.88 alpha:1.0];
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark - FAB 点击

- (void)fabTapped {
    [UIView animateWithDuration:0.12 animations:^{
        self.fabButton.transform = CGAffineTransformMakeScale(0.88, 0.88);
    } completion:^(BOOL f) {
        [UIView animateWithDuration:0.18 animations:^{ self.fabButton.transform = CGAffineTransformIdentity; }];
    }];
    HDQuickAddViewController *vc = [HDQuickAddViewController new];
    vc.delegate = self;
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    vc.modalTransitionStyle   = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:NO completion:nil];
}

- (void)quickAddDidUpdateData { [self refreshAll]; }

@end

