//
//  HDTabBarController.m
//  HealthDashboard
//
//  Created by zhang, haizi on 2026/3/19.
//

#import "HDTabBarController.h"
#import "HDDashboardViewController.h"
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
    // 个人中心
    HDProfileViewController *profile = [HDProfileViewController new];
    UINavigationController *profNav  = [[UINavigationController alloc] initWithRootViewController:profile];
    profNav.navigationBarHidden = YES;
    profNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的"
                                                       image:[UIImage systemImageNamed:@"person.circle.fill"]
                                                         tag:1];
    self.viewControllers = @[dashNav, profNav];
}

- (void)applyTabBarStyle {
    BOOL dark = [HDHealthDataModel shared].isDarkMode;
    UITabBar *tb = self.tabBar;
    if (@available(iOS 15, *)) {
        UITabBarAppearance *app = [UITabBarAppearance new];
        [app configureWithOpaqueBackground];
        app.backgroundColor = dark
            ? [UIColor colorWithRed:0.08 green:0.11 blue:0.18 alpha:1.0]
            : [UIColor colorWithRed:0.97 green:0.97 blue:0.99 alpha:1.0];
        tb.standardAppearance   = app;
        tb.scrollEdgeAppearance = app;
    } else {
        tb.barTintColor = dark
            ? [UIColor colorWithRed:0.08 green:0.11 blue:0.18 alpha:1.0]
            : [UIColor colorWithRed:0.97 green:0.97 blue:0.99 alpha:1.0];
        tb.translucent = NO;
    }
    tb.tintColor               = [UIColor colorWithRed:0.22 green:0.54 blue:0.95 alpha:1.0];
    tb.unselectedItemTintColor = [UIColor colorWithWhite:0.45 alpha:1.0];
}

- (void)themeChanged {
    [self applyTabBarStyle];
    for (UINavigationController *nav in self.viewControllers) {
        if ([nav.topViewController respondsToSelector:@selector(applyTheme)]) {
            [nav.topViewController performSelector:@selector(applyTheme)];
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
