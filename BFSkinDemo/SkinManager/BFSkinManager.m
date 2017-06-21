//
//  BFSkinManager.m
//  BFSkinDemo
//
//  Created by wangxiao on 2017/6/19.
//  Copyright © 2017年 tuniu. All rights reserved.
//

#import "BFSkinManager.h"

NSString *const kBFSkinUserDefaultConfig = @"kBFSkinUserDefaultConfig";

@implementation BFSkinManager

+ (BFSkinManager *)sharedInstance {
    static BFSkinManager *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[BFSkinManager alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self loadSkinWithStyleId:[self readCacheConfig]];
    }
    return self;
}

#pragma mark - Change Skin
- (void)loadSkinWithStyleId:(NSString *)styleId {
    if (styleId.length == 0) {
        return;
    }

    NSString *fullPath = [self returnPlistPath:styleId];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
        self.skinConfigDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:fullPath];
        [self saveCacheConfig:styleId];
        self.styleId = styleId;
    } else {
        NSLog(@"error %@",fullPath);
    }
}

- (void)changeToSkinWithStyleId:(NSString *)styleId {
    [self loadSkinWithStyleId:styleId];
    [[NSNotificationCenter defaultCenter] postNotificationName:kSkinDidChangeNotification object:nil];
}

#pragma mark - Public
- (NSString *)returnPlistPath:(NSString *)styleId {
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"Skin/%@/style.plist",styleId]];
    return fullPath;
}

- (NSString *)returnResourcePath:(NSString *)styleId {
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"Skin/%@/Resource/",styleId]];
    return fullPath;
}

#pragma mark - NSUserDefaults
- (NSString *)readCacheConfig {
    NSString *styleId = @"";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    styleId = [userDefaults objectForKey:kBFSkinUserDefaultConfig];
    if (!styleId) {
        styleId = @"Default";
    }
    return styleId;
}

- (void)saveCacheConfig:(NSString *)styleId {
    if (!styleId) {
        return;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:styleId forKey:kBFSkinUserDefaultConfig];
}

@end
