//
//  AppDelegate.m
//  BFSkinDemo
//
//  Created by wangxiao on 2017/6/19.
//  Copyright © 2017年 tuniu. All rights reserved.
//

#import "AppDelegate.h"
#import "ZipArchive.h"
#import "BFSkinManager.h"
#import "BFHomeViewController.h"
#import "ViewController.h"
#import "AFNetworking.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    [self configDefaultZIP];
    
    BFHomeViewController *homeViewController = [BFHomeViewController new];
    homeViewController.title = @"首页";
    
    ViewController *viewController = [ViewController new];
    viewController.title = @"配置";
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[homeViewController,viewController];
    
    UINavigationController *navigationControlelr = [[UINavigationController alloc] initWithRootViewController:tabBarController];
    navigationControlelr.view.backgroundColor = [UIColor whiteColor];
    
    self.window.rootViewController = navigationControlelr;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)configDefaultZIP {
    //TODO:默认从bundle解压Skin
    NSString *skinPath = [[NSBundle mainBundle] pathForResource:@"Skin" ofType:@"zip"];
    NSString *fullPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *plistPath = [[BFSkinManager sharedInstance] returnPlistPath:@"Default"];
    
    NSLog(@"fullPath = %@",fullPath);

    //若有则不需再解压
    if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        return;
    }
    
    [SSZipArchive unzipFileAtPath:skinPath toDestination:fullPath progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {
        
    } completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
        [[BFSkinManager sharedInstance] changeToSkinWithStyleId:@"Default"];
    }];
    
}

//从网络下载ZIP资源文件，TODO:
- (void)downloadZIP {
    
    NSString *tempPath = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"];
    NSString *documentPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost/SkinDemo/Skin.zip"]];
    NSURLSessionDownloadTask *task = [sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"progress = %@",downloadProgress);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:documentPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [SSZipArchive unzipFileAtPath:tempPath toDestination:documentPath];
    }];
    [task resume];

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
