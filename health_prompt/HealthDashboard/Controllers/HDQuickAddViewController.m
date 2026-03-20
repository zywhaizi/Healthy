//
//  HDQuickAddViewController.m
//  HealthDashboard - 快速录入底部弹窗
//
//  Created by zhang, haizi on 2026/3/19.
//

#import "HDQuickAddViewController.h"
#import "../Models/HDHealthDataModel.h"

@interface HDQuickAddViewController ()
@property (nonatomic, strong) UIView   *sheetView;
@property (nonatomic, strong) UISlider *stepsSlider;
@property (nonatomic, strong) UILabel  *stepsValueLabel;
@end

@implementation HDQuickAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self buildSheet];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 弹出动画
    [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.85 initialSpringVelocity:0.5 options:0 animations:^{
        self.sheetView.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)buildSheet {
    CGFloat sw = self.view.bounds.size.width;
    CGFloat sh = self.view.bounds.size.height;
    CGFloat sheetH = 380;
    BOOL dark = [HDHealthDataModel shared].isDarkMode;

    _sheetView = [[UIView alloc] initWithFrame:CGRectMake(0, sh - sheetH, sw, sheetH)];
    _sheetView.backgroundColor    = dark ? [UIColor colorWithRed:0.10 green:0.13 blue:0.20 alpha:1] : UIColor.whiteColor;
    _sheetView.layer.cornerRadius = 20;
    _sheetView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    _sheetView.transform = CGAffineTransformMakeTranslation(0, sheetH);
    [self.view addSubview:_sheetView];
    UITapGestureRecognizer *sheetTap = [[UITapGestureRecognizer alloc] init];
    [_sheetView addGestureRecognizer:sheetTap]; // 阻止穿透

    UIColor *textC = dark ? UIColor.whiteColor : [UIColor colorWithRed:0.1 green:0.12 blue:0.18 alpha:1];

    // 标题
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, sw-40, 28)];
    title.text      = @"快速录入";
    title.font      = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
    title.textColor = textC;
    [_sheetView addSubview:title];

    // 关闭按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    closeBtn.frame = CGRectMake(sw-56, 16, 36, 36);
    [closeBtn setTitle:@"✕" forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [closeBtn setTitleColor:[UIColor colorWithWhite:0.5 alpha:1] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [_sheetView addSubview:closeBtn];

    // 喝水按钮
    [self addActionButtonTitle:@"💧  喝一杯水 +200ml" y:68 color:[UIColor colorWithRed:0.20 green:0.55 blue:0.95 alpha:1] action:@selector(addWater)];

    // 步数滑块
    UILabel *stepsTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 138, sw-40, 22)];
    stepsTitle.text      = @"👟  记录步数";
    stepsTitle.font      = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
    stepsTitle.textColor = textC;
    [_sheetView addSubview:stepsTitle];

    _stepsSlider = [[UISlider alloc] initWithFrame:CGRectMake(20, 168, sw-40-120, 30)];
    _stepsSlider.minimumValue = 500;
    _stepsSlider.maximumValue = 10000;
    _stepsSlider.value        = 2000;
    _stepsSlider.tintColor    = [UIColor colorWithRed:0.22 green:0.82 blue:0.55 alpha:1];
    [_stepsSlider addTarget:self action:@selector(sliderChanged) forControlEvents:UIControlEventValueChanged];
    [_sheetView addSubview:_stepsSlider];

    _stepsValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(sw-130, 162, 110, 30)];
    _stepsValueLabel.text      = @"2000步";
    _stepsValueLabel.font      = [UIFont monospacedDigitSystemFontOfSize:14 weight:UIFontWeightSemibold];
    _stepsValueLabel.textColor = textC;
    _stepsValueLabel.textAlignment = NSTextAlignmentRight;
    [_sheetView addSubview:_stepsValueLabel];

    UIButton *stepsBtn = [self makeButtonTitle:@"确认步数" color:[UIColor colorWithRed:0.22 green:0.82 blue:0.55 alpha:1]];
    stepsBtn.frame = CGRectMake(20, 210, sw-40, 44);
    [stepsBtn addTarget:self action:@selector(addSteps) forControlEvents:UIControlEventTouchUpInside];
    [_sheetView addSubview:stepsBtn];

    // 心情打卡
    UILabel *moodTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 272, sw-40, 22)];
    moodTitle.text      = @"🌟  心情打卡";
    moodTitle.font      = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
    moodTitle.textColor = textC;
    [_sheetView addSubview:moodTitle];

    NSArray *emojis = @[@"😞",@"😕",@"😐",@"😊",@"😄"];
    CGFloat emojiW = (sw-40) / 5.0;
    for (NSInteger i = 0; i < 5; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(20 + i*emojiW, 302, emojiW, 44);
        [btn setTitle:emojis[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:28];
        btn.tag = 100 + i + 1;
        [btn addTarget:self action:@selector(moodTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_sheetView addSubview:btn];
    }
}

- (void)addActionButtonTitle:(NSString *)title y:(CGFloat)y color:(UIColor *)color action:(SEL)action {
    UIButton *btn = [self makeButtonTitle:title color:color];
    btn.frame = CGRectMake(20, y, self.view.bounds.size.width-40, 52);
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [_sheetView addSubview:btn];
}

- (UIButton *)makeButtonTitle:(NSString *)title color:(UIColor *)color {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor    = color;
    btn.layer.cornerRadius = 12;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
    [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    return btn;
}

- (void)sliderChanged {
    NSInteger steps = (NSInteger)_stepsSlider.value;
    CGFloat cal = [[HDHealthDataModel shared] caloryForSteps:steps];
    _stepsValueLabel.text = [NSString stringWithFormat:@"%ld步 %.0f卡", (long)steps, cal];
}

- (void)addWater {
    [[HDHealthDataModel shared] addWater:200];
    [self dismiss];
}

- (void)addSteps {
    [[HDHealthDataModel shared] addSteps:(NSInteger)_stepsSlider.value];
    [self dismiss];
}

- (void)moodTapped:(UIButton *)sender {
    NSInteger level = sender.tag - 100;
    [[HDHealthDataModel shared] addMood:level];
    [self dismiss];
}

- (void)dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        self.sheetView.transform = CGAffineTransformMakeTranslation(0, 400);
        self.view.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL f) {
        [self.delegate quickAddDidUpdateData];
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

@end
