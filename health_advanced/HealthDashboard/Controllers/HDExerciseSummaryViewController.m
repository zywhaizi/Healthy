//
//  HDExerciseSummaryViewController.m
//  HealthDashboard
//
//  Created by zhang, haizi on 2026/3/21.
//

#import "HDExerciseSummaryViewController.h"

@interface HDExerciseSummaryViewController ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UILabel *paceLabel;
@property (nonatomic, strong) UILabel *calorieLabel;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIButton *cancelButton;
@end

@implementation HDExerciseSummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self applyTheme];
}

- (void)setupUI {
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    self.title = @"运动总结";
    
    // 标题
    _titleLabel = [UILabel new];
    _titleLabel.text = [NSString stringWithFormat:@"🎉 %@完成", self.exerciseRecord.typeString];
    _titleLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightBold];
    _titleLabel.textColor = UIColor.labelColor;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_titleLabel];
    
    // 时间
    _timeLabel = [UILabel new];
    NSInteger hours = self.exerciseRecord.durationSeconds / 3600;
    NSInteger minutes = (self.exerciseRecord.durationSeconds % 3600) / 60;
    NSInteger seconds = self.exerciseRecord.durationSeconds % 60;
    _timeLabel.text = [NSString stringWithFormat:@"⏱ 时间: %02ld:%02ld:%02ld", hours, minutes, seconds];
    _timeLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    _timeLabel.textColor = UIColor.labelColor;
    [self.view addSubview:_timeLabel];
    
    // 距离
    _distanceLabel = [UILabel new];
    _distanceLabel.text = [NSString stringWithFormat:@"📍 距离: %.1f km", self.exerciseRecord.distanceKM];
    _distanceLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    _distanceLabel.textColor = UIColor.systemBlueColor;
    [self.view addSubview:_distanceLabel];
    
    // 配速
    _paceLabel = [UILabel new];
    CGFloat paceMinutes = self.exerciseRecord.durationSeconds / 60.0 / self.exerciseRecord.distanceKM;
    NSInteger paceMin = (NSInteger)paceMinutes;
    NSInteger paceSec = (NSInteger)((paceMinutes - paceMin) * 60);
    _paceLabel.text = [NSString stringWithFormat:@"🏃 配速: %ld:%02ld /km", paceMin, paceSec];
    _paceLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    _paceLabel.textColor = UIColor.labelColor;
    [self.view addSubview:_paceLabel];
    
    // 卡路里
    _calorieLabel = [UILabel new];
    _calorieLabel.text = [NSString stringWithFormat:@"🔥 卡路里: %ld kcal", self.exerciseRecord.caloriesBurned];
    _calorieLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    _calorieLabel.textColor = UIColor.systemOrangeColor;
    [self.view addSubview:_calorieLabel];
    
    // 保存按钮
    _saveButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _saveButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
    _saveButton.layer.cornerRadius = 8;
    _saveButton.backgroundColor = UIColor.systemGreenColor;
    [_saveButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [_saveButton addTarget:self action:@selector(saveExercise) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_saveButton];
    
    // 放弃按钮
    _cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _cancelButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    [_cancelButton setTitle:@"放弃" forState:UIControlStateNormal];
    _cancelButton.layer.cornerRadius = 8;
    _cancelButton.backgroundColor = UIColor.systemRedColor;
    [_cancelButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(cancelExercise) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelButton];
    
    [self layoutUI];
}

- (void)layoutUI {
    CGFloat padding = 16;
    CGFloat width = self.view.bounds.size.width - padding * 2;
    
    _titleLabel.frame = CGRectMake(padding, 100, width, 40);
    _timeLabel.frame = CGRectMake(padding, 140, width, 30);
    _distanceLabel.frame = CGRectMake(padding, 180, width, 30);
    _paceLabel.frame = CGRectMake(padding, 220, width, 30);
    _calorieLabel.frame = CGRectMake(padding, 260, width, 30);
    
    _saveButton.frame = CGRectMake(padding, self.view.bounds.size.height - padding - 120, width / 2 - 8, 50);
    _cancelButton.frame = CGRectMake(padding + width / 2 + 8, self.view.bounds.size.height - padding - 120, width / 2 - 8, 50);
}

- (void)saveExercise {
    // 数据已在计时器中保存，这里只需返回
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)cancelExercise {
    // 返回到类型选择页面
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)applyTheme {
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    _titleLabel.textColor = UIColor.labelColor;
    _timeLabel.textColor = UIColor.labelColor;
    _distanceLabel.textColor = UIColor.systemBlueColor;
    _paceLabel.textColor = UIColor.labelColor;
    _calorieLabel.textColor = UIColor.systemOrangeColor;
}

@end
