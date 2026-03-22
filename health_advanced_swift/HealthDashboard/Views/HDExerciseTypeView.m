//
//  HDExerciseTypeView.m
//  HealthDashboard
//
//  Created by zhang, haizi on 2026/3/21.
//

#import "HDExerciseTypeView.h"

@implementation HDExerciseTypeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.layer.cornerRadius = 12;
    self.layer.masksToBounds = YES;
    self.backgroundColor = UIColor.secondarySystemBackgroundColor;
    
    // 标题
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    _titleLabel.textColor = UIColor.labelColor;
    [self addSubview:_titleLabel];
    
    // 描述
    _descriptionLabel = [UILabel new];
    _descriptionLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    _descriptionLabel.textColor = UIColor.secondaryLabelColor;
    _descriptionLabel.numberOfLines = 2;
    [self addSubview:_descriptionLabel];
    
    // 开始按钮
    _startButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _startButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    [_startButton setTitle:@"开始" forState:UIControlStateNormal];
    _startButton.layer.cornerRadius = 8;
    _startButton.backgroundColor = UIColor.systemBlueColor;
    [_startButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self addSubview:_startButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat padding = 16;
    CGFloat width = self.bounds.size.width - padding * 2;
    
    _titleLabel.frame = CGRectMake(padding, padding, width, 24);
    _descriptionLabel.frame = CGRectMake(padding, padding + 28, width, 40);
    _startButton.frame = CGRectMake(padding, self.bounds.size.height - padding - 44, width, 44);
}

- (void)applyTheme {
    self.backgroundColor = UIColor.secondarySystemBackgroundColor;
    _titleLabel.textColor = UIColor.labelColor;
    _descriptionLabel.textColor = UIColor.secondaryLabelColor;
    _startButton.backgroundColor = UIColor.systemBlueColor;
}

@end
