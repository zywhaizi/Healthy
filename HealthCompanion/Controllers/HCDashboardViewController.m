//
//  HCDashboardViewController.m
//  健康伴侣 - 首页仪表盘
//
//  Created by zhang, haizi on 2026/3/19.
//

#import "HCDashboardViewController.h"
#import "HCQuickAddViewController.h"
#import "../Models/HCHealthDataModel.h"
#import "../Views/HCRingProgressView.h"
#import "../Views/HCWaterView.h"
#import "../Views/HCSleepBarView.h"
#import "../Views/HCMoodTrendView.h"
#import "../Views/HCDashboardCardView.h"

@interface HCDashboardViewController () <HCQuickAddDelegate>
@property (nonatomic, strong) UIScrollView         *scrollView;
@property (nonatomic, strong) UIView               *contentView;
@property (nonatomic, strong) HCDashboardCardView  *stepsCard;
@property (nonatomic, strong) HCDashboardCardView  *waterCard;
@property (nonatomic, strong) HCDashboardCardView  *sleepCard;
@property (nonatomic, strong) HCDashboardCardView  *moodCard;
@property (nonatomic, strong) HCRingProgressView   *ringView;
@property (nonatomic, strong) UILabel              *stepsLabel;
@property (nonatomic, strong) UILabel              *stepsSubLabel;
@property (nonatomic, strong) HCWaterView          *waterWave;
@property (nonatomic, strong) UILabel              *waterLabel;
@property (nonatomic, strong) HCSleepBarView       *sleepBar;
@property (nonatomic, strong) HCMoodTrendView      *moodTrend;
@property (nonatomic, strong) UIButton             *fabButton;
@end

@implementation HCDashboardViewController

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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self applyTheme];
    // 每次出现时重新定位 FAB，避免与 TabBar 重叠
    CGFloat sw = self.view.bounds.size.width;
    CGFloat sh = self.view.bounds.size.height;
    CGFloat tabBarH = self.tabBarController.tabBar.frame.size.height;
    if (tabBarH < 1) tabBarH = 83.0;
    _fabButton.frame = CGRectMake(sw - 76, sh - tabBarH - 72, 56, 56);
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // 确保 scrollView 始终铺满整个 view
    _scrollView.frame = self.view.bounds;
    // 同步更新 FAB 位置
    UIEdgeInsets safe = self.view.safeAreaInsets;
    CGFloat sw = self.view.bounds.size.width;
    CGFloat sh = self.view.bounds.size.height;
    CGFloat tabBarH = self.tabBarController.tabBar.frame.size.height;
    if (tabBarH < 1) tabBarH = safe.bottom + 49.0;
    _fabButton.frame = CGRectMake(sw - 76, sh - tabBarH - 72, 56, 56);
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

    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sw, 840)];
    [_scrollView addSubview:_contentView];
    _scrollView.contentSize = CGSizeMake(sw, 840);
}

#pragma mark - Header

- (void)buildHeader {
    CGFloat sw = self.view.bounds.size.width;
    NSDateFormatter *df = [NSDateFormatter new];
    df.dateFormat = @"MM\u6708dd\u65e5";
    UILabel *dateLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 16, sw-40, 22)];
    dateLbl.text      = [NSString stringWithFormat:@"\u4eca\u5929 \u00b7 %@", [df stringFromDate:[NSDate date]]];
    dateLbl.font      = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    dateLbl.textColor = [UIColor colorWithWhite:0.55 alpha:1.0];
    [_contentView addSubview:dateLbl];

    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, sw-40, 36)];
    titleLbl.text      = @"\u5065\u5eb7\u4eea\u8868\u76d8";
    titleLbl.font      = [UIFont systemFontOfSize:28 weight:UIFontWeightHeavy];
    titleLbl.textColor = [UIColor whiteColor];
    [_contentView addSubview:titleLbl];
}

#pragma mark - Steps Card

- (void)buildStepsCard {
    CGFloat sw = self.view.bounds.size.width, pad = 16;
    _stepsCard = [[HCDashboardCardView alloc] initWithTitle:@"\u4eca\u65e5\u6b65\u6570" iconEmoji:@"\U0001f45f"];
    _stepsCard.frame = CGRectMake(pad, 90, sw-pad*2, 180);
    [_contentView addSubview:_stepsCard];

    CGFloat rs = 110;
    _ringView = [[HCRingProgressView alloc] initWithFrame:CGRectMake(16, 56, rs, rs)];
    _ringView.ringColor  = [UIColor colorWithRed:0.22 green:0.82 blue:0.55 alpha:1.0];
    _ringView.trackColor = [UIColor colorWithWhite:0.18 alpha:1.0];
    _ringView.lineWidth  = 12;
    [_stepsCard addContentView:_ringView];

    CGFloat textX = rs + 32;
    CGFloat textW = sw - pad*2 - textX - 16;
    _stepsLabel = [[UILabel alloc] initWithFrame:CGRectMake(textX, 62, textW, 50)];
    _stepsLabel.font = [UIFont monospacedDigitSystemFontOfSize:42 weight:UIFontWeightBold];
    _stepsLabel.textColor = [UIColor whiteColor];
    _stepsLabel.adjustsFontSizeToFitWidth = YES;
    [_stepsCard addContentView:_stepsLabel];

    _stepsSubLabel = [[UILabel alloc] initWithFrame:CGRectMake(textX, 116, textW, 20)];
    _stepsSubLabel.font      = [UIFont systemFontOfSize:12];
    _stepsSubLabel.textColor = [UIColor colorWithWhite:0.55 alpha:1.0];
    [_stepsCard addContentView:_stepsSubLabel];

    UILabel *pct = [[UILabel alloc] initWithFrame:CGRectMake(16, 56 + rs/2 - 10, rs, 20)];
    pct.tag = 901;
    pct.textAlignment = NSTextAlignmentCenter;
    pct.font = [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
    pct.textColor = [UIColor colorWithWhite:0.68 alpha:1.0];
    [_stepsCard addContentView:pct];
}

#pragma mark - Water Card

- (void)buildWaterCard {
    CGFloat sw = self.view.bounds.size.width, pad = 16;
    _waterCard = [[HCDashboardCardView alloc] initWithTitle:@"\u4eca\u65e5\u996e\u6c34" iconEmoji:@"\U0001f4a7"];
    _waterCard.frame = CGRectMake(pad, 286, sw-pad*2, 150);
    [_contentView addSubview:_waterCard];

    CGFloat ww = sw - pad*2 - 32;
    _waterWave = [[HCWaterView alloc] initWithFrame:CGRectMake(16, 58, ww, 72)];
    [_waterCard addContentView:_waterWave];

    _waterLabel = [[UILabel alloc] initWithFrame:CGRectMake(ww - 114, 66, 114, 24)];
    _waterLabel.textAlignment = NSTextAlignmentRight;
    _waterLabel.font = [UIFont monospacedDigitSystemFontOfSize:17 weight:UIFontWeightBold];
    _waterLabel.textColor = [UIColor whiteColor];
    [_waterCard addContentView:_waterLabel];
}

#pragma mark - Sleep Card

- (void)buildSleepCard {
    CGFloat sw = self.view.bounds.size.width, pad = 16;
    _sleepCard = [[HCDashboardCardView alloc] initWithTitle:@"\u8fd7 7 \u5929\u7761\u7720" iconEmoji:@"\U0001f319"];
    _sleepCard.frame = CGRectMake(pad, 452, sw-pad*2, 170);
    [_contentView addSubview:_sleepCard];

    _sleepBar = [[HCSleepBarView alloc] initWithFrame:CGRectMake(16, 58, sw-pad*2-32, 100)];
    [_sleepCard addContentView:_sleepBar];
}

#pragma mark - Mood Card

- (void)buildMoodCard {
    CGFloat sw = self.view.bounds.size.width, pad = 16;
    _moodCard = [[HCDashboardCardView alloc] initWithTitle:@"\u4eca\u65e5\u5fc3\u60c5" iconEmoji:@"\U0001f31f"];
    _moodCard.frame = CGRectMake(pad, 638, sw-pad*2, 160);
    [_contentView addSubview:_moodCard];

    _moodTrend = [[HCMoodTrendView alloc] initWithFrame:CGRectMake(16, 58, sw-pad*2-32, 90)];
    [_moodCard addContentView:_moodTrend];
}

#pragma mark - FAB

- (void)buildFAB {
    CGFloat sw = self.view.bounds.size.width;
    CGFloat sh = self.view.bounds.size.height;
    CGFloat tabBarH = self.tabBarController.tabBar.frame.size.height ?: 83.0;
    _fabButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _fabButton.frame = CGRectMake(sw - 76, sh - tabBarH - 72, 56, 56);
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

#pragma mark - Refresh

- (void)refreshAll {
    HCHealthDataModel *m = [HCHealthDataModel shared];

    _stepsLabel.text    = [NSString stringWithFormat:@"%ld", (long)m.todaySteps];
    _stepsSubLabel.text = [NSString stringWithFormat:@"\u76ee\u6807 %ld \u6b65 \u00b7 \u6d88\u8017 %.0f \u5343\u5361",
                           (long)m.stepsGoal, [m caloryForSteps:m.todaySteps]];
    [_ringView setProgress:m.stepsProgress animated:YES];
    UILabel *pct = (UILabel *)[_stepsCard viewWithTag:901];
    pct.text = [NSString stringWithFormat:@"%.0f%%", m.stepsProgress * 100];

    [_waterWave setWaterLevel:m.waterProgress animated:YES];
    _waterLabel.text = [NSString stringWithFormat:@"%.0f/%.0fml", m.waterML, m.waterGoalML];
    _waterCard.subtitleLabel.text = [NSString stringWithFormat:@"\u5df2\u559d %.0f ml", m.waterML];

    _sleepBar.hoursData = m.sleepHours;
    [_sleepBar reloadData];
    CGFloat last = [m.sleepHours.lastObject floatValue];
    _sleepCard.subtitleLabel.text = [NSString stringWithFormat:@"\u6628\u665a %.1f \u5c0f\u65f6", last];

    _moodTrend.records = m.moodRecords;
    [_moodTrend reloadData];
    HCMoodRecord *latest = m.latestMood;
    if (latest) {
        NSDateFormatter *df = [NSDateFormatter new];
        df.dateFormat = @"HH:mm";
        _moodCard.subtitleLabel.text = [NSString stringWithFormat:@"\u6700\u65b0: %@ %@",
                                        latest.emojiString, [df stringFromDate:latest.timestamp]];
    } else {
        _moodCard.subtitleLabel.text = @"\u4eca\u5929\u8fd8\u6ca1\u8bb0\u5f55\u5fc3\u60c5";
    }
}

#pragma mark - Theme

- (void)applyTheme {
    BOOL dark = [HCHealthDataModel shared].isDarkMode;
    UIColor *bg    = dark ? [UIColor colorWithRed:0.06 green:0.08 blue:0.14 alpha:1.0]
                          : [UIColor colorWithRed:0.93 green:0.95 blue:0.97 alpha:1.0];
    UIColor *cardC = dark ? [UIColor colorWithRed:0.12 green:0.16 blue:0.24 alpha:1.0]
                          : [UIColor whiteColor];
    UIColor *textC = dark ? [UIColor whiteColor]
                          : [UIColor colorWithRed:0.10 green:0.12 blue:0.18 alpha:1.0];
    self.view.backgroundColor    = bg;
    _scrollView.backgroundColor  = bg;
    _contentView.backgroundColor = bg;
    for (HCDashboardCardView *c in @[_stepsCard, _waterCard, _sleepCard, _moodCard]) {
        c.backgroundColor = cardC;
        c.titleLabel.textColor = textC;
    }
    _stepsLabel.textColor = textC;
    _waterLabel.textColor = textC;
    _ringView.trackColor  = dark ? [UIColor colorWithWhite:0.18 alpha:1.0]
                                 : [UIColor colorWithWhite:0.88 alpha:1.0];
}

#pragma mark - FAB Action

- (void)fabTapped {
    [UIView animateWithDuration:0.12 animations:^{
        self.fabButton.transform = CGAffineTransformMakeScale(0.88, 0.88);
    } completion:^(BOOL f) {
        [UIView animateWithDuration:0.18 animations:^{ self.fabButton.transform = CGAffineTransformIdentity; }];
    }];
    HCQuickAddViewController *vc = [HCQuickAddViewController new];
    vc.delegate = self;
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    vc.modalTransitionStyle   = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:NO completion:nil];
}

- (void)quickAddDidUpdateData {
    [self refreshAll];
}

@end
