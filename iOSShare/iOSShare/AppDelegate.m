//
//  AppDelegate.m
//  iOSShare
//
//  Created by IanChen on 2018/3/12.
//  Copyright © 2018年 IanChen. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

NSString* groupSuitName = @"group.com.xjyc.sldemo";
NSString* shareUrlKey = @"share-url";
NSString* hasNewShare = @"has-new-share";
NSString* urlSuggestTitle = @"urlSuggetTitle";
NSString* shareTypeKey = @"shareTypeKey";
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"ios9以下调用了OpenURL的接口。。。。。。。。。。。返回的内容为=============================");
    NSLog(@"url = %@", url);
    NSLog(@"sourceApplication = %@", sourceApplication);
    NSLog(@"annotation = %@", annotation);
    return YES;
}

#else
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options
{
    NSLog(@"ios9以上调用了OpenURL的接口。。。。。。。。。。。返回的内容为=============================");
    NSLog(@"url = %@", url);
    NSLog(@"options = %@", options);
    
    //新建立一个页面用于预览该图片
    
    return YES;
}
#endif


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    NSLog(@"=============  %s  =============================", __FUNCTION__);
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"=============  %s  =============================", __FUNCTION__);
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    NSLog(@"=============  %s  =============================", __FUNCTION__);
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"=============  %s  =============================", __FUNCTION__);
    
    //获取共享的UserDefaults
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:groupSuitName];
    if ([userDefaults boolForKey:hasNewShare])
    {
        NSLog(@"新的分享 : %@", [userDefaults valueForKey:shareUrlKey]);
        NSLog(@"新的分享 : %@", [userDefaults valueForKey:urlSuggestTitle]);
        NSLog(@"新的分享 : %@", [userDefaults valueForKey:shareTypeKey]);
        
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 100, 200, 200)];
        NSData* imageData = [NSData dataWithContentsOfFile:[userDefaults valueForKey:shareUrlKey]];
        imageView.image = [UIImage imageWithData:imageData];
        [self.window addSubview:imageView];
        
        //重置分享标识
        [userDefaults setBool:NO forKey:@"has-new-share"];
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"=============  %s  =============================", __FUNCTION__);
}


@end
