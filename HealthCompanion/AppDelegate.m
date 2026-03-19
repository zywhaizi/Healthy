//
//  AppDelegate.m
//  HealthCompanion
//
//  Created by zhang, haizi on 2026/3/19.
//

#import "AppDelegate.h"
#import "Controllers/HCTabBarController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
    HCTabBarController *tab = [HCTabBarController new];
    self.window.rootViewController = tab;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
