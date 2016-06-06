//
//  AppDelegate.m
//  TestRemoteNotification
//
//  Created by benlinhuo on 16/6/4.
//  Copyright © 2016年 Benlinhuo. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"



#pragma mark - define

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
#define MAX_ALLOWED_VERSION_GREATER_THAN_OR_EQUAL_TO_8
#endif

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self registerRemotePush];
//    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    ViewController *vc = [ViewController new];
    [vc printApnsData:launchOptions];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = nav;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [self registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    //当点击通知栏中的一条未读消息进入app以后，则其他未读消息自动消失
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"\n>>>[Receive RemoteNotification - Background Fetch]:%@\n\n",userInfo);
    
    // 静默推送，UI的更新
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title" message:@"测试 content－available" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
//    [alertView show];

    
    if (application.applicationState == UIApplicationStateActive) {
        // 当前程序正在前台运行
        
    } else if (application.applicationState == UIApplicationStateInactive) {
        // 当前app 点击系统通知，从后台切到前台
        [self application:application didReceiveRemoteNotification:userInfo];
        completionHandler(UIBackgroundFetchResultNewData);
        
    } else if (application.applicationState == UIApplicationStateBackground) {
       
    }
    
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
}

// 当我们上述添加了 category，点击 “View” 进入 APP 前台，调用的 APPDelegate
- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    NSLog(@"\n>>>[Receive RemoteNotification - Category didClick Action]:%@\n\n",userInfo);
    NSLog(@"\n>>>[Receive RemoteNotification - Category didClick Action] identifier :%@\n\n",identifier);
    if ([identifier isEqualToString:@"ACTION_IDENTIFIER"] ) {
        // balala 做自己想做的事情
    }
    completionHandler();
}

#pragma mark -  private method
- (void)registerDeviceToken:(NSData *)deviceToken
{
    const unsigned *tokenBytes = [deviceToken bytes];
    NSString *deviceTokenString = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                                   ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                                   ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                                   ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    
    NSLog(@"deviceToken = %@", deviceTokenString);
}

- (void)registerRemotePush
{
    // 创建一个按钮标题名为 “View” 的新交互通知，当交互通知被用户触发时打开 APP 并让其进入前台。这个交互动作的标识符是 ACTION_IDENTIFIER,这个标识符被用于区分同一通知的不同交互动作
    UIMutableUserNotificationAction *action = [UIMutableUserNotificationAction new];
    action.identifier = @"ACTION_IDENTIFIER";
    action.title = @"View";
    action.activationMode = UIUserNotificationActivationModeForeground;// 在前台激活 APP
    
    // 定义了一个新通知分类，设置交互动作为之前定义的 “View” 动作，设置标识符为 “CATEGORY_IDENTIFIER”。这个标识符表示你的装载体要包含的内容，以用其指示当前通知属于那个分类。
    UIMutableUserNotificationCategory *category = [UIMutableUserNotificationCategory new];
    category.identifier = @"CATEGORY_IDENTIFIER";
    [category setActions:@[action] forContext:UIUserNotificationActionContextDefault];
    
    NSMutableSet *set = [NSMutableSet new];
    [set addObject:category];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:set]];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)applicationWillResignActive:(UIApplication *)application {
 
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}



@end
