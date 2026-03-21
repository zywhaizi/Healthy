//
//  HDTabBarController.m
//  HealthDashboard
//
//  Created by zhang, haizi on 2026/3/19.
//

#import "HDTabBarController.h"
#import "HDDashboardViewController.h"
#import "HDExerciseTypeViewController.h"
#import "HDProfileViewController.h"
#import "../Models/HDHealthDataModel.h"

@implementation HDTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTabs];
    [self applyTabBarStyle];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(themeChanged)
                                                 name:@"HDThemeDidChange"
                                               object:nil];
}

- (void)setupTabs {
    // 首页
    HDDashboardViewController *dash = [HDDashboardViewController new];
    dash.extendedLayoutIncludesOpaqueBars = YES;
    dash.edgesForExtendedLayout = UIRectEdgeAll;
    UINavigationController *dashNav = [[UINavigationController alloc] initWithRootViewController:dash];
    dashNav.navigationBarHidden = YES;
    dashNav.extendedLayoutIncludesOpaqueBars = YES;
    dashNav.edgesForExtendedLayout = UIRectEdgeAll;
    dashNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页"
                                                       image:[UIImage systemImageNamed:@"heart.fill"]
                                                         tag:0];
    
    // 运动
    HDExerciseTypeViewController *exercise = [HDExerciseTypeViewController new];
    UINavigationController *exerciseNav = [[UINavigationController alloc] initWithRootViewController:exercise];
    exerciseNav.navigationBarHidden = NO;
    exerciseNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"运动"
                                                           image:[UIImage systemImageNamed:@"figure.walk"]
                                                             tag:1];
    
    // 个人中心
    HDProfileViewController *profile = [HDProfileViewController new];
    UINavigationController *profNav  = [[UINavigationController alloc] initWithRootViewController:profile];
    profNav.navigationBarHidden = YES;
    profNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的"
                                                       image:[UIImage systemImageNamed:@"person.circle.fill"]
                                                         tag:2];
    self.viewControllers = @[dashNav, exerciseNav, profNav];
}

- (void)applyTabBarStyle {
    BOOL dark = [HDHealthDataModel shared].isDarkMode;
    UITabBar *tb = self.tabBar;
    if (@available(iOS 15, *)) {
        UITabBarAppearance *app = [UITabBarAppearance new];
        [app configureWithOpaqueBackground];
        app.backgroundColor = UIColor.systemBackgroundColor;
        tb.standardAppearance   = app;
        tb.scrollEdgeAppearance = app;
    } else {
        tb.barTintColor = UIColor.systemBackgroundColor;
        tb.translucent = NO;
    }
    tb.tintColor               = UIColor.systemBlueColor;
    tb.unselectedItemTintColor = UIColor.secondaryLabelColor;
}

- (void)themeChanged {
    [self applyTabBarStyle];
    for (UINavigationController *nav in self.viewControllers) {
        if ([nav.topViewController respondsToSelector:@selector(applyTheme)]) {
            [(id)nav.topViewController applyTheme];
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
