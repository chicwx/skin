//
//  BFSkinManager.h
//  BFSkinDemo
//
//  Created by wangxiao on 2017/6/19.
//  Copyright © 2017年 tuniu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BFSkin.h"

#define kSkinDidChangeNotification @"kSkinDidChangeNotification"
#define kSkinResetNotification @"kSkinResetNotification"

@interface BFSkinManager : NSObject

@property (nonatomic, strong) NSDictionary *skinConfigDictionary;
@property (nonatomic, strong) NSString *styleId;

+ (BFSkinManager *)sharedInstance;
- (void)changeToSkinWithStyleId:(NSString *)styleId;
- (void)resetSkinStyle;
- (NSString *)returnPlistPath:(NSString *)styleId;
- (NSString *)returnResourcePath:(NSString *)styleId;
- (NSString *)readCacheConfig;
- (void)configDefaultSkin;
- (void)downloadSkinResource;

@end
