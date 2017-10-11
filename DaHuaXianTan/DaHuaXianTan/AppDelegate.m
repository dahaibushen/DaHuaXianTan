//
//  AppDelegate.m
//  DaHuaXianTan
//
//  Created by huyiyong on 17/2/9.
//  Copyright © 2017年 huyiyong. All rights reserved.
//

#import "AppDelegate.h"
#import <Bugly/Bugly.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    BuglyConfig * config = [[BuglyConfig alloc] init];
//    // 设置自定义日志上报的级别，默认不上报自定义日志
//    config.reportLogLevel = BuglyLogLevelWarn;
//    
//    [Bugly startWithAppId:@"764a19b3d6" config:config];
    
    [self initBugly];
    return YES;
}
-(void)initBugly{
    // Get the default config
    BuglyConfig * config = [[BuglyConfig alloc] init];
    
    //SDK Debug信息开关, 默认关闭
    config.debugMode = YES;
    //卡顿监控开关，默认关闭
    config.blockMonitorEnable = YES;
    
    //卡顿监控判断间隔，单位为秒
    config.blockMonitorTimeout = 1.5;
    
//    config.delegate = self;
    
    //控制台日志上报开关，默认开启
    config.consolelogEnable = NO;
    
    //页面信息记录开关，默认开启
    config.viewControllerTrackingEnable = YES;
    
#if DEBUG
    // 设置自定义渠道标识  开发环uu境
    config.channel = @"Development";
    [Bugly startWithAppId:@"764a19b3d6" developmentDevice:YES config:config];
    
#else
    // 设置自定义渠道标识  线上环境
    config.channel = @"Product";
    [Bugly startWithAppId:@"764a19b3d6" developmentDevice:NO config:config];
    
#endif
    
    
    [Bugly setUserIdentifier:[NSString stringWithFormat:@"User: %@", [UIDevice currentDevice].name]];
    
    [Bugly setUserValue:[NSProcessInfo processInfo].processName forKey:@"Process"];
    
    //[self performSelectorInBackground:@selector(testLogOnBackground) withObject:nil];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
