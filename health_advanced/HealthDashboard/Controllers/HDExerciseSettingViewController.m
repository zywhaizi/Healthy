//
//  HDExerciseSettingViewController.m
//  HealthDashboard
//
//  Created by zhang, haizi on 2026/3/21.
//

#import "HDExerciseSettingViewController.h"
#import "HDExerciseTimerViewController.h"
#import "../Models/HDHealthDataModel.h"

@interface HDExerciseSettingViewController ()
@property (nonatomic, strong) UILabel *distanceTitleLabel;
@property (nonatomic, strong) UITextField *distanceTextField;
@property (nonatomic, strong) UILabel *timeTitleLabel;
@property (nonatomic, strong) UITextField *timeTextField;
@property (nonatomic, strong) UIButton *startButton;
@end

@implementation HDExerciseSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self applyTheme];
}

- (void)setupUI {
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    self.title = @"设置目标";
    
    HDHealthDataModel *model = [HDHealthDataModel shared];
    
    // 距离标题
    _distanceTitleLabel = [UILabel new];
    _distanceTitleLabel.text = @"目标距离 (km)";
    _distanceTitleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    _distanceTitleLabel.textColor = UIColor.labelColor;
    [self.view addSubview:_distanceTitleLabel];
    
    // 距离输入框
    _distanceTextField = [UITextField new];
    _distanceTextField.borderStyle = UITextBorderStyleRoundedRect;
    _distanceTextField.keyboardType = UIKeyboardTypeDecimalPad;
    _distanceTextField.text = [NSString stringWithFormat:@"%ld", model.targetRunDistanceKM];
    _distanceTextField.placeholder = @"输入距离";
    [self.view addSubview:_distanceTextField];
    
    // 时间标题
    _timeTitleLabel = [UILabel new];
    _timeTitleLabel.text = @"目标时间 (分钟)";
    _timeTitleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    _timeTitleLabel.textColor = UIColor.labelColor;
    [self.view addSubview:_timeTitleLabel];
    
    // 时间输入框
    _timeTextField = [UITextField new];
    _timeTextField.borderStyle = UITextBorderStyleRoundedRect;
    _timeTextField.keyboardType = UIKeyboardTypeNumberPad;
    _timeTextField.text = [NSString stringWithFormat:@"%ld", model.targetRunMinutes];
    _timeTextField.placeholder = @"输入时间";
    [self.view addSubview:_timeTextField];
    
    // 开始按钮
    _startButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _startButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    [_startButton setTitle:@"开始运动" forState:UIControlStateNormal];
    _startButton.layer.cornerRadius = 8;
    _startButton.backgroundColor = UIColor.systemBlueColor;
    [_startButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [_startButton addTarget:self action:@selector(startExercise) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_startButton];
    
    // 布局
    [self layoutUI];
}

- (void)layoutUI {
    CGFloat padding = 16;
    CGFloat width = self.view.bounds.size.width - padding * 2;
    CGFloat topPadding = 100;
    
    _distanceTitleLabel.frame = CGRectMake(padding, topPadding, width, 24);
    _distanceTextField.frame = CGRectMake(padding, topPadding + 28, width, 44);
    
    _timeTitleLabel.frame = CGRectMake(padding, topPadding + 80, width, 24);
    _timeTextField.frame = CGRectMake(padding, topPadding + 108, width, 44);
    
    _startButton.frame = CGRectMake(padding, self.view.bounds.size.height - padding - 120, width, 50);
}

- (void)startExercise {
    // 验证输入
    NSString *distanceStr = _distanceTextField.text;
    NSString *timeStr = _timeTextField.text;
    
    if (distanceStr.length == 0 || timeStr.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入距离和时间" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    NSInteger distance = [distanceStr integerValue];
    NSInteger time = [timeStr integerValue];
    
    if (distance < 1 || distance > 50 || time < 1 || time > 180) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"距离: 1-50km, 时间: 1-180分钟" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    // 保存目标
    HDHealthDataModel *model = [HDHealthDataModel shared];
    model.targetRunDistanceKM = distance;
    model.targetRunMinutes = time;
    
    // 跳转到计时器页面
    HDExerciseTimerViewController *vc = [HDExerciseTimerViewController new];
    vc.exerciseType = 0; // 目标跑
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)applyTheme {
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    _distanceTitleLabel.textColor = UIColor.labelColor;
    _timeTitleLabel.textColor = UIColor.labelColor;
    _distanceTextField.backgroundColor = UIColor.secondarySystemBackgroundColor;
    _timeTextField.backgroundColor = UIColor.secondarySystemBackgroundColor;
    _startButton.backgroundColor = UIColor.systemBlueColor;
}

@end
