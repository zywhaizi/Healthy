//
//  HDQuickAddViewController.h
//  HealthDashboard - 快速录入
//
//  Created by zhang, haizi on 2026/3/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HDQuickAddDelegate <NSObject>
- (void)quickAddDidUpdateData;
@end

@interface HDQuickAddViewController : UIViewController
@property (nonatomic, weak) id<HDQuickAddDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
