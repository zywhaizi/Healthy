//
//  HCQuickAddViewController.h
//  健康伴侣 - 快速录入 Bottom Sheet
//
//  Created by zhang, haizi on 2026/3/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HCQuickAddDelegate <NSObject>
- (void)quickAddDidUpdateData;
@end

@interface HCQuickAddViewController : UIViewController

@property (nonatomic, weak) id<HCQuickAddDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
