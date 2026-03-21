//
//  HDExerciseTypeView.h
//  HealthDashboard
//
//  Created by zhang, haizi on 2026/3/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 运动类型选择卡片
@interface HDExerciseTypeView : UIView

/// 运动类型（0=目标跑, 1=自由跑）
@property (nonatomic, assign) NSInteger exerciseType;

/// 标题
@property (nonatomic, strong) UILabel *titleLabel;

/// 描述
@property (nonatomic, strong) UILabel *descriptionLabel;

/// 开始按钮
@property (nonatomic, strong) UIButton *startButton;

/// 应用主题
- (void)applyTheme;

@end

NS_ASSUME_NONNULL_END
