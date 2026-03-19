//
//  HCTabBarController.m
//
//  Created by zhang, haizi on 2026/3/19.
//

#import "HCTabBarController.h"
#import "HCDashboardViewController.h"
#import "HCProfileViewController.h"
#import "../Models/HCHealthDataModel.h"

@implementation HCTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"[DEBUG] TabBar view bounds at viewDidLoad: %@", NSStringFromCGRect(self.view.bounds));
    self.view.backgroundColor = UIColor.redColor;
    [self setupTabs];
    [self applyTabBarStyle];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(themeChanged)
                                                 name:@"HCThemeDidChange"
                                               object:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    NSLog(@"[DEBUG] TabBar view bounds at viewDidLayoutSubviews: %@", NSStringFromCGRect(self.view.bounds));
    NSLog(@"[DEBUG] UIScreen bounds: %@", NSStringFromCGRect(UIScreen.mainScreen.bounds));
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupTabs {
    HCDashboardViewController *dash = [HCDashboardViewController new];
    dash.extendedLayoutIncludesOpaqueBars = YES;
    dash.edgesForExtendedLayout = UIRectEdgeAll;
    UINavigationController *dashNav = [[UINavigationController alloc] initWithRootViewController:dash];
    dashNav.navigationBarHidden = YES;
    dashNav.extendedLayoutIncludesOpaqueBars = YES;
    dashNav.edgesForExtendedLayout = UIRectEdgeAll;
    dashNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"\u9996\u9875"
                                                       image:[UIImage systemImageNamed:@"heart.fill"]
                                                         tag:0];

    HCProfileViewController *profile = [HCProfileViewController new];
//    profile.view.backgroundColor = UIColor.redColor;
    UINavigationController *profNav  = [[UINavigationController alloc] initWithRootViewController:profile];
    profNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"\u6211\u7684"
                                                       image:[UIImage systemImageNamed:@"person.circle.fill"]
                                                         tag:1];

    self.viewControllers = @[dashNav, profNav];
}

- (void)applyTabBarStyle {
    BOOL dark = [HCHealthDataModel shared].isDarkMode;
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
    tb.tintColor         = [UIColor colorWithRed:0.22 green:0.54 blue:0.95 alpha:1.0];
    tb.unselectedItemTintColor = [UIColor colorWithWhite:0.45 alpha:1.0];
}

- (void)themeChanged {
    [self applyTabBarStyle];
    for (UINavigationController *nav in self.viewControllers) {
        [nav.topViewController viewWillAppear:NO];
    }
}

@end
