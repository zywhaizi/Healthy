//
//  HDExerciseTimerViewController.m
//  HealthDashboard
//
//  Created by zhang, haizi on 2026/3/21.
//

#import "HDExerciseTimerViewController.h"
#import "HDExerciseSummaryViewController.h"
#import "../Models/HDHealthDataModel.h"

@interface HDExerciseTimerViewController ()
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UILabel *paceLabel;
@property (nonatomic, strong) UILabel *calorieLabel;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UIButton *pauseButton;
@property (nonatomic, strong) UIButton *endButton;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger elapsedSeconds;
@property (nonatomic, assign) CGFloat currentDistance;
@property (nonatomic, assign) BOOL isRunning;
@end

@implementation HDExerciseTimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self applyTheme];
    [self startTimer];
}

- (void)setupUI {
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    self.title = @"运动中";
    
    // 时间显示
    _timeLabel = [UILabel new];
    _timeLabel.text = @"00:00:00";
    _timeLabel.font = [UIFont monospacedDigitSystemFontOfSize:48 weight:UIFontWeightBold];
    _timeLabel.textColor = UIColor.labelColor;
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_timeLabel];
    
    // 距离显示
    _distanceLabel = [UILabel new];
    _distanceLabel.text = @"0.0 km";
    _distanceLabel.font = [UIFont monospacedDigitSystemFontOfSize:32 weight:UIFontWeightBold];
    _distanceLabel.textColor = UIColor.systemBlueColor;
    _distanceLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_distanceLabel];
    
    // 配速显示
    _paceLabel = [UILabel new];
    _paceLabel.text = @"配速: 0:00 /km";
    _paceLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    _paceLabel.textColor = UIColor.secondaryLabelColor;
    _paceLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_paceLabel];
    
    // 卡路里显示
    _calorieLabel = [UILabel new];
    _calorieLabel.text = @"0 kcal";
    _calorieLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    _calorieLabel.textColor = UIColor.secondaryLabelColor;
    _calorieLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_calorieLabel];
    
    // 进度条
    _progressView = [UIProgressView new];
    _progressView.progressTintColor = UIColor.systemBlueColor;
    _progressView.trackTintColor = UIColor.tertiaryLabelColor;
    [self.view addSubview:_progressView];
    
    // 暂停按钮
    _pauseButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _pauseButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    [_pauseButton setTitle:@"暂停" forState:UIControlStateNormal];
    _pauseButton.layer.cornerRadius = 8;
    _pauseButton.backgroundColor = UIColor.systemOrangeColor;
    [_pauseButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [_pauseButton addTarget:self action:@selector(togglePause) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_pauseButton];
    
    // 结束按钮
    _endButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _endButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    [_endButton setTitle:@"结束" forState:UIControlStateNormal];
    _endButton.layer.cornerRadius = 8;
    _endButton.backgroundColor = UIColor.systemRedColor;
    [_endButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [_endButton addTarget:self action:@selector(endExercise) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_endButton];
    
    [self layoutUI];
}

- (void)layoutUI {
    CGFloat padding = 16;
    CGFloat width = self.view.bounds.size.width - padding * 2;
    
    _timeLabel.frame = CGRectMake(padding, 100, width, 60);
    _distanceLabel.frame = CGRectMake(padding, 170, width, 50);
    _paceLabel.frame = CGRectMake(padding, 230, width, 24);
    _calorieLabel.frame = CGRectMake(padding, 260, width, 24);
    
    _progressView.frame = CGRectMake(padding, 300, width, 4);
    
    _pauseButton.frame = CGRectMake(padding, self.view.bounds.size.height - padding - 120, width / 2 - 8, 50);
    _endButton.frame = CGRectMake(padding + width / 2 + 8, self.view.bounds.size.height - padding - 120, width / 2 - 8, 50);
}

- (void)startTimer {
    _isRunning = YES;
    _elapsedSeconds = 0;
    _currentDistance = 0;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
}

- (void)updateTimer {
    _elapsedSeconds++;
    _currentDistance += 0.01; // 模拟距离增加
    
    // 更新时间显示
    NSInteger hours = _elapsedSeconds / 3600;
    NSInteger minutes = (_elapsedSeconds % 3600) / 60;
    NSInteger seconds = _elapsedSeconds % 60;
    _timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hours, minutes, seconds];
    
    // 更新距离显示
    _distanceLabel.text = [NSString stringWithFormat:@"%.1f km", _currentDistance];
    
    // 更新配速
    if (_currentDistance > 0) {
        CGFloat paceMinutes = _elapsedSeconds / 60.0 / _currentDistance;
        NSInteger paceMin = (NSInteger)paceMinutes;
        NSInteger paceSec = (NSInteger)((paceMinutes - paceMin) * 60);
        _paceLabel.text = [NSString stringWithFormat:@"配速: %ld:%02ld /km", paceMin, paceSec];
    }
    
    // 更新卡路里（约0.1 kcal/秒）
    NSInteger calories = (NSInteger)(_elapsedSeconds * 0.1);
    _calorieLabel.text = [NSString stringWithFormat:@"%ld kcal", calories];
    
    // 更新进度条（目标跑）
    if (_exerciseType == 0) {
        HDHealthDataModel *model = [HDHealthDataModel shared];
        CGFloat targetDistance = model.targetRunDistanceKM;
        _progressView.progress = MIN(1.0, _currentDistance / targetDistance);
    }
}

- (void)togglePause {
    if (_isRunning) {
        [_timer invalidate];
        _timer = nil;
        _isRunning = NO;
        [_pauseButton setTitle:@"继续" forState:UIControlStateNormal];
    } else {
        _isRunning = YES;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
        [_pauseButton setTitle:@"暂停" forState:UIControlStateNormal];
    }
}

- (void)endExercise {
    [_timer invalidate];
    _timer = nil;
    
    // 创建运动记录
    HDExerciseRecord *record = [HDExerciseRecord new];
    record.type = _exerciseType;
    record.durationSeconds = _elapsedSeconds;
    record.distanceKM = _currentDistance;
    record.caloriesBurned = (NSInteger)(_elapsedSeconds * 0.1);
    record.timestamp = [NSDate date];
    
    // 保存到 Model
    [[HDHealthDataModel shared] saveExerciseRecord:record];
    
    // 跳转到总结页面
    HDExerciseSummaryViewController *vc = [HDExerciseSummaryViewController new];
    vc.exerciseRecord = record;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)applyTheme {
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    _timeLabel.textColor = UIColor.labelColor;
    _distanceLabel.textColor = UIColor.systemBlueColor;
    _paceLabel.textColor = UIColor.secondaryLabelColor;
    _calorieLabel.textColor = UIColor.secondaryLabelColor;
}

- (void)dealloc {
    [_timer invalidate];
}

@end
