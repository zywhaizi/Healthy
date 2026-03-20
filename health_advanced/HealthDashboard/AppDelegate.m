//
//  AppDelegate.m
//  HealthDashboard
//
//  Created by zhang, haizi on 2026/3/19.
//

#import "AppDelegate.h"
#import "Controllers/HDTabBarController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [HDTabBarController new];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
