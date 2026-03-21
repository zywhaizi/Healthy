//
//  HDExerciseTypeViewController.m
//  HealthDashboard
//
//  Created by zhang, haizi on 2026/3/21.
//

#import "HDExerciseTypeViewController.h"
#import "HDExerciseTypeView.h"
#import "HDExerciseSettingViewController.h"
#import "../Models/HDHealthDataModel.h"

@interface HDExerciseTypeViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) HDExerciseTypeView *targetRunView;
@property (nonatomic, strong) HDExerciseTypeView *freeRunView;
@end

@implementation HDExerciseTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self applyTheme];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self applyTheme];
}

- (void)setupUI {
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    self.title = @"选择运动类型";
    
    // ScrollView
    _scrollView = [UIScrollView new];
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    // 目标跑卡片
    _targetRunView = [HDExerciseTypeView new];
    _targetRunView.exerciseType = 0;
    _targetRunView.titleLabel.text = @"🏃 目标跑";
    _targetRunView.descriptionLabel.text = @"设置距离和时间目标\n开始计时运动";
    [_targetRunView.startButton addTarget:self action:@selector(startTargetRun) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_targetRunView];
    
    // 自由跑卡片
    _freeRunView = [HDExerciseTypeView new];
    _freeRunView.exerciseType = 1;
    _freeRunView.titleLabel.text = @"🏃 自由跑";
    _freeRunView.descriptionLabel.text = @"无目标限制\n尽情享受运动";
    [_freeRunView.startButton addTarget:self action:@selector(startFreeRun) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_freeRunView];
    
    // 布局
    [self layoutUI];
}

- (void)layoutUI {
    CGFloat padding = 16;
    CGFloat width = self.view.bounds.size.width - padding * 2;
    
    _scrollView.frame = self.view.bounds;
    
    _targetRunView.frame = CGRectMake(padding, padding, width, 180);
    _freeRunView.frame = CGRectMake(padding, padding * 2 + 180, width, 180);
    
    _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, padding * 3 + 360);
}

- (void)startTargetRun {
    HDExerciseSettingViewController *vc = [HDExerciseSettingViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)startFreeRun {
    // TODO: 跳转到计时器页面（自由跑）
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"自由跑" message:@"功能开发中..." preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)applyTheme {
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    [_targetRunView applyTheme];
    [_freeRunView applyTheme];
}

@end
