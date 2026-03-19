//
//  HCQuickAddViewController.m
//  健康伴侣 - 快速录入 Bottom Sheet
//
//  Created by zhang, haizi on 2026/3/19.
//

#import "HCQuickAddViewController.h"
#import "../Models/HCHealthDataModel.h"
#import "../Views/HCWaterView.h"

@interface HCQuickAddViewController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView              *sheetView;
@property (nonatomic, strong) UISegmentedControl  *tabControl;
@property (nonatomic, strong) UIView              *waterPage;
@property (nonatomic, strong) UIView              *stepsPage;
@property (nonatomic, strong) UIView              *moodPage;
// Water
@property (nonatomic, strong) HCWaterView         *miniWaterView;
@property (nonatomic, strong) UILabel             *waterAmountLabel;
@property (nonatomic, strong) UIButton            *addWaterButton;
// Steps
@property (nonatomic, strong) UISlider            *stepsSlider;
@property (nonatomic, strong) UILabel             *stepsValueLabel;
@property (nonatomic, strong) UILabel             *calorieLabel;
@property (nonatomic, strong) UIButton            *saveStepsButton;
// Mood
@property (nonatomic, strong) NSArray<UIButton *> *moodButtons;
@property (nonatomic, assign) CGFloat              sheetHeight;
@end

@implementation HCQuickAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.52];
    _sheetHeight = 400;
    [self buildSheet];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
        initWithTarget:self action:@selector(backgroundTapped:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self animateIn];
    [self refreshWaterPage];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)g shouldReceiveTouch:(UITouch *)t {
    return [t.view isEqual:self.view];
}

- (void)backgroundTapped:(id)sender { [self dismissSheet]; }

#pragma mark - Build Sheet UI

- (void)buildSheet {
    CGFloat sw = UIScreen.mainScreen.bounds.size.width;
    CGFloat sh = UIScreen.mainScreen.bounds.size.height;
    _sheetView = [[UIView alloc] initWithFrame:CGRectMake(0, sh, sw, _sheetHeight + 40)];
    _sheetView.backgroundColor     = [UIColor colorWithRed:0.10 green:0.13 blue:0.20 alpha:1.0];
    _sheetView.layer.cornerRadius  = 24;
    _sheetView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    _sheetView.clipsToBounds       = YES;
    [self.view addSubview:_sheetView];

    UIView *handle = [[UIView alloc] initWithFrame:CGRectMake(sw/2-22, 10, 44, 4)];
    handle.backgroundColor    = [UIColor colorWithWhite:0.38 alpha:1.0];
    handle.layer.cornerRadius = 2;
    [_sheetView addSubview:handle];

    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 24, sw-80, 26)];
    titleLbl.text      = @"快速记录";
    titleLbl.font      = [UIFont systemFontOfSize:19 weight:UIFontWeightBold];
    titleLbl.textColor = [UIColor whiteColor];
    [_sheetView addSubview:titleLbl];

    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    closeBtn.frame = CGRectMake(sw-52, 18, 36, 36);
    [closeBtn setTitle:@"✕" forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    [closeBtn setTitleColor:[UIColor colorWithWhite:0.55 alpha:1.0] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(dismissSheet) forControlEvents:UIControlEventTouchUpInside];
    [_sheetView addSubview:closeBtn];

    _tabControl = [[UISegmentedControl alloc] initWithItems:@[@"\U0001f4a7 喝水", @"\U0001f45f 步数", @"\U0001f60a 心情"]];
    _tabControl.frame = CGRectMake(16, 60, sw-32, 36);
    _tabControl.selectedSegmentIndex     = 0;
    _tabControl.selectedSegmentTintColor = [UIColor colorWithRed:0.22 green:0.54 blue:0.95 alpha:1.0];
    _tabControl.backgroundColor = [UIColor colorWithRed:0.15 green:0.19 blue:0.28 alpha:1.0];
    [_tabControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];
    [_tabControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.58 alpha:1.0]} forState:UIControlStateNormal];
    [_tabControl addTarget:self action:@selector(tabChanged:) forControlEvents:UIControlEventValueChanged];
    [_sheetView addSubview:_tabControl];

    CGFloat pageY = 108;
    CGFloat pageH = _sheetHeight - pageY;
    CGRect  pageR = CGRectMake(0, pageY, sw, pageH);
    [self buildWaterPage:pageR];
    [self buildStepsPage:pageR];
    [self buildMoodPage:pageR];
    _stepsPage.hidden = YES;
    _moodPage.hidden  = YES;

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [_sheetView addGestureRecognizer:pan];
}

#pragma mark - Water Page

- (void)buildWaterPage:(CGRect)frame {
    _waterPage = [[UIView alloc] initWithFrame:frame];
    _waterPage.backgroundColor = [UIColor clearColor];
    [_sheetView addSubview:_waterPage];
    CGFloat w = frame.size.width;
    CGFloat wvSize = 90;
    _miniWaterView = [[HCWaterView alloc] initWithFrame:CGRectMake(w/2-wvSize/2, 14, wvSize, wvSize)];
    [_waterPage addSubview:_miniWaterView];

    _waterAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 116, w-40, 34)];
    _waterAmountLabel.textAlignment = NSTextAlignmentCenter;
    _waterAmountLabel.font          = [UIFont monospacedDigitSystemFontOfSize:28 weight:UIFontWeightBold];
    _waterAmountLabel.textColor     = [UIColor whiteColor];
    [_waterPage addSubview:_waterAmountLabel];

    UILabel *hint = [[UILabel alloc] initWithFrame:CGRectMake(20, 154, w-40, 20)];
    hint.text          = @"每次 +200ml · 目标 2000ml";
    hint.textAlignment = NSTextAlignmentCenter;
    hint.font          = [UIFont systemFontOfSize:13];
    hint.textColor     = [UIColor colorWithWhite:0.50 alpha:1.0];
    [_waterPage addSubview:hint];

    _addWaterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _addWaterButton.frame             = CGRectMake(w/2-100, 188, 200, 52);
    _addWaterButton.backgroundColor   = [UIColor colorWithRed:0.22 green:0.54 blue:0.95 alpha:1.0];
    _addWaterButton.layer.cornerRadius = 26;
    _addWaterButton.titleLabel.font   = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    [_addWaterButton setTitle:@"\U0001f4a7  喝一杯水" forState:UIControlStateNormal];
    [_addWaterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_addWaterButton addTarget:self action:@selector(addWaterTapped) forControlEvents:UIControlEventTouchUpInside];
    [_waterPage addSubview:_addWaterButton];
}

- (void)refreshWaterPage {
    HCHealthDataModel *m = [HCHealthDataModel shared];
    _waterAmountLabel.text = [NSString stringWithFormat:@"%.0f / %.0f ml", m.waterML, m.waterGoalML];
    [_miniWaterView setWaterLevel:m.waterProgress animated:YES];
}

- (void)addWaterTapped {
    [[HCHealthDataModel shared] addWater200ml];
    [self refreshWaterPage];
    [self rippleButton:_addWaterButton];
    [self notifyDelegate];
}

#pragma mark - Steps Page

- (void)buildStepsPage:(CGRect)frame {
    _stepsPage = [[UIView alloc] initWithFrame:frame];
    _stepsPage.backgroundColor = [UIColor clearColor];
    [_sheetView addSubview:_stepsPage];
    CGFloat w = frame.size.width;

    UILabel *hint = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, w-40, 22)];
    hint.text          = @"今日步数";
    hint.textAlignment = NSTextAlignmentCenter;
    hint.font          = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    hint.textColor     = [UIColor colorWithWhite:0.65 alpha:1.0];
    [_stepsPage addSubview:hint];

    _stepsValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 48, w-40, 52)];
    _stepsValueLabel.textAlignment = NSTextAlignmentCenter;
    _stepsValueLabel.font          = [UIFont monospacedDigitSystemFontOfSize:46 weight:UIFontWeightBold];
    _stepsValueLabel.textColor     = [UIColor whiteColor];
    _stepsValueLabel.text          = @"0";
    [_stepsPage addSubview:_stepsValueLabel];

    _calorieLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 104, w-40, 22)];
    _calorieLabel.textAlignment = NSTextAlignmentCenter;
    _calorieLabel.font          = [UIFont systemFontOfSize:14];
    _calorieLabel.textColor     = [UIColor colorWithRed:0.98 green:0.72 blue:0.30 alpha:1.0];
    _calorieLabel.text          = @"\U0001f525 消耗 0 千卡";
    [_stepsPage addSubview:_calorieLabel];

    _stepsSlider = [[UISlider alloc] initWithFrame:CGRectMake(24, 142, w-48, 32)];
    _stepsSlider.minimumValue   = 0;
    _stepsSlider.maximumValue   = 20000;
    _stepsSlider.value          = (float)[HCHealthDataModel shared].todaySteps;
    _stepsSlider.tintColor      = [UIColor colorWithRed:0.22 green:0.54 blue:0.95 alpha:1.0];
    _stepsSlider.thumbTintColor = [UIColor whiteColor];
    [_stepsSlider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    [_stepsPage addSubview:_stepsSlider];

    _saveStepsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveStepsButton.frame             = CGRectMake(w/2-100, 194, 200, 52);
    _saveStepsButton.backgroundColor   = [UIColor colorWithRed:0.22 green:0.72 blue:0.52 alpha:1.0];
    _saveStepsButton.layer.cornerRadius = 26;
    _saveStepsButton.titleLabel.font   = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    [_saveStepsButton setTitle:@"\U0001f45f  保存步数" forState:UIControlStateNormal];
    [_saveStepsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_saveStepsButton addTarget:self action:@selector(saveStepsTapped) forControlEvents:UIControlEventTouchUpInside];
    [_stepsPage addSubview:_saveStepsButton];
    [self sliderChanged:_stepsSlider];
}

- (void)sliderChanged:(UISlider *)slider {
    NSInteger steps = (NSInteger)slider.value;
    _stepsValueLabel.text = [NSString stringWithFormat:@"%ld", (long)steps];
    CGFloat cal = [[HCHealthDataModel shared] caloryForSteps:steps];
    _calorieLabel.text = [NSString stringWithFormat:@"\U0001f525 消耗 %.0f 千卡", cal];
}

- (void)saveStepsTapped {
    [[HCHealthDataModel shared] setSteps:(NSInteger)_stepsSlider.value];
    [self rippleButton:_saveStepsButton];
    [self notifyDelegate];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissSheet];
    });
}

#pragma mark - Mood Page

- (void)buildMoodPage:(CGRect)frame {
    _moodPage = [[UIView alloc] initWithFrame:frame];
    _moodPage.backgroundColor = [UIColor clearColor];
    [_sheetView addSubview:_moodPage];
    CGFloat w = frame.size.width;

    UILabel *hint = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, w-40, 22)];
    hint.text          = @"今天感觉怎么样？";
    hint.textAlignment = NSTextAlignmentCenter;
    hint.font          = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    hint.textColor     = [UIColor colorWithWhite:0.80 alpha:1.0];
    [_moodPage addSubview:hint];

    NSArray *emojis = @[@"\U0001f61e", @"\U0001f615", @"\U0001f610", @"\U0001f60a", @"\U0001f604"];
    NSArray *names  = @[@"很差", @"较差", @"一般", @"不错", @"很好"];
    NSMutableArray *btns = [NSMutableArray array];
    CGFloat btnW  = 54;
    CGFloat gap   = (w - 32 - btnW*5) / 4;
    CGFloat startX = 16;

    for (NSInteger i = 0; i < 5; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame              = CGRectMake(startX + i*(btnW+gap), 58, btnW, btnW+24);
        btn.tag                = i;
        btn.backgroundColor    = [UIColor colorWithRed:0.16 green:0.20 blue:0.30 alpha:1.0];
        btn.layer.cornerRadius = 14;

        UILabel *eLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, btnW, btnW)];
        eLbl.text = emojis[i]; eLbl.font = [UIFont systemFontOfSize:34];
        eLbl.textAlignment = NSTextAlignmentCenter;
        eLbl.userInteractionEnabled = NO;
        [btn addSubview:eLbl];

        UILabel *nLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, btnW+2, btnW, 18)];
        nLbl.text = names[i]; nLbl.font = [UIFont systemFontOfSize:11];
        nLbl.textAlignment = NSTextAlignmentCenter;
        nLbl.textColor = [UIColor colorWithWhite:0.55 alpha:1.0];
        nLbl.userInteractionEnabled = NO;
        [btn addSubview:nLbl];

        [btn addTarget:self action:@selector(moodTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_moodPage addSubview:btn];
        [btns addObject:btn];
    }
    _moodButtons = [btns copy];

    UILabel *ts = [[UILabel alloc] initWithFrame:CGRectMake(20, 196, w-40, 20)];
    ts.textAlignment = NSTextAlignmentCenter;
    ts.font          = [UIFont systemFontOfSize:12];
    ts.textColor     = [UIColor colorWithWhite:0.38 alpha:1.0];
    ts.text          = @"点击记录当前心情，自动保存时间戳";
    [_moodPage addSubview:ts];
}

- (void)moodTapped:(UIButton *)btn {
    for (UIButton *b in _moodButtons) {
        BOOL sel = (b.tag == btn.tag);
        b.backgroundColor  = sel
            ? [UIColor colorWithRed:0.95 green:0.72 blue:0.20 alpha:0.22]
            : [UIColor colorWithRed:0.16 green:0.20 blue:0.30 alpha:1.0];
        b.layer.borderWidth = sel ? 2 : 0;
        b.layer.borderColor = sel
            ? [UIColor colorWithRed:0.95 green:0.72 blue:0.20 alpha:0.8].CGColor : nil;
    }
    [[HCHealthDataModel shared] addMoodRecord:(HCMoodType)btn.tag];
    [self notifyDelegate];
    [UIView animateWithDuration:0.15 animations:^{
        btn.transform = CGAffineTransformMakeScale(1.18, 1.18);
    } completion:^(BOOL f) {
        [UIView animateWithDuration:0.15 animations:^{ btn.transform = CGAffineTransformIdentity; }];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissSheet];
    });
}

#pragma mark - Tab Switch

- (void)tabChanged:(UISegmentedControl *)seg {
    _waterPage.hidden = (seg.selectedSegmentIndex != 0);
    _stepsPage.hidden = (seg.selectedSegmentIndex != 1);
    _moodPage.hidden  = (seg.selectedSegmentIndex != 2);
    if (seg.selectedSegmentIndex == 0) [self refreshWaterPage];
    if (seg.selectedSegmentIndex == 1) [self sliderChanged:_stepsSlider];
}

#pragma mark - Animation

- (void)animateIn {
    CGFloat sh = UIScreen.mainScreen.bounds.size.height;
    CGFloat sw = UIScreen.mainScreen.bounds.size.width;
    [UIView animateWithDuration:0.42 delay:0
         usingSpringWithDamping:0.82 initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        self->_sheetView.frame = CGRectMake(0, sh - self->_sheetHeight, sw, self->_sheetHeight + 40);
    } completion:nil];
}

- (void)dismissSheet {
    CGFloat sh = UIScreen.mainScreen.bounds.size.height;
    CGFloat sw = UIScreen.mainScreen.bounds.size.width;
    [UIView animateWithDuration:0.30 animations:^{
        self->_sheetView.frame = CGRectMake(0, sh, sw, self->_sheetHeight + 40);
        self.view.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL f) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

- (void)handlePan:(UIPanGestureRecognizer *)pan {
    CGFloat sh = UIScreen.mainScreen.bounds.size.height;
    CGFloat sw = UIScreen.mainScreen.bounds.size.width;
    CGFloat ty = [pan translationInView:self.view].y;
    if (pan.state == UIGestureRecognizerStateChanged) {
        if (ty > 0) _sheetView.frame = CGRectMake(0, sh - _sheetHeight + ty, sw, _sheetHeight + 40);
    } else if (pan.state == UIGestureRecognizerStateEnded) {
        if (ty > 100) {
            [self dismissSheet];
        } else {
            [UIView animateWithDuration:0.28 animations:^{
                self->_sheetView.frame = CGRectMake(0, sh - self->_sheetHeight, sw, self->_sheetHeight + 40);
            }];
        }
    }
}

- (void)rippleButton:(UIButton *)btn {
    [UIView animateWithDuration:0.10 animations:^{ btn.transform = CGAffineTransformMakeScale(0.93, 0.93); }
                     completion:^(BOOL f) {
        [UIView animateWithDuration:0.18 animations:^{ btn.transform = CGAffineTransformIdentity; }];
    }];
}

- (void)notifyDelegate {
    if ([self.delegate respondsToSelector:@selector(quickAddDidUpdateData)]) {
        [self.delegate quickAddDidUpdateData];
    }
}

@end
