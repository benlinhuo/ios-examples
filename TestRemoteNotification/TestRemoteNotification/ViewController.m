//
//  ViewController.m
//  TestRemoteNotification
//
//  Created by benlinhuo on 16/6/4.
//  Copyright © 2016年 Benlinhuo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundIdentifier;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"测试 APNS 远程推送";
    
}

// 用于测试如下内容：如果你的应用当前不在运行,并且用户通过点击推送通知启动应用,通知内容会通过 application(_:didFinishLaunchingWithOptions:) 方法的 launchOptions 参数进行传递.
- (void)printApnsData:(NSDictionary *)data
{
    if (!data) {
        return;
    }
    NSString *text = [NSString stringWithFormat:@"%@", data];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"apns 传递的数据" message:text delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [alertView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backgroundTask
{
    __weak typeof(self) weakSelf = self;
    self.backgroundIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        // 此次 block 是在后台任务过期时执行
        if (weakSelf) {
            [[UIApplication sharedApplication] endBackgroundTask:weakSelf.backgroundIdentifier];
            weakSelf.backgroundIdentifier = UIBackgroundTaskInvalid; // 置为无效
        }
        
    }];
    
    if (self.backgroundIdentifier != UIBackgroundTaskInvalid) {
        
    }
}

@end
