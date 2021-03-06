//
//  BFSkinManager.m
//  BFSkinDemo
//
//  Created by wangxiao on 2017/6/19.
//  Copyright © 2017年 tuniu. All rights reserved.
//

#import "BFSkinManager.h"
#import "AFNetworking.h"
#import "ZipArchive.h"

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

#pragma mark - Public
- (void)resetSkinStyle {
    [[NSNotificationCenter defaultCenter] postNotificationName:kSkinResetNotification object:nil];
}

- (void)configDefaultSkin {
    //TODO:默认从bundle解压Skin
    NSString *skinBundlePath = [[NSBundle mainBundle] pathForResource:@"Default" ofType:@"skin"];

    NSString *skinPath = [self returnSkinPath];
    
    NSLog(@"skinPath = %@",skinPath);

    [SSZipArchive unzipFileAtPath:skinBundlePath toDestination:skinPath progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {
        
    } completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
        [self changeToSkinWithStyleId:@"Default"];
    }];
}

- (void)changeToSkinWithStyleId:(NSString *)styleId {
    [self loadSkinWithStyleId:styleId];
    [[NSNotificationCenter defaultCenter] postNotificationName:kSkinDidChangeNotification object:nil];
}

- (NSString *)returnPlistPath:(NSString *)styleId {
//    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"Skin/%@/style.plist",styleId]];
    NSString *fullPath = [[self returnSkinPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/style.plist",styleId]];
    return fullPath;
}

- (NSString *)returnResourcePath:(NSString *)styleId {
    //fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"Skin/%@/Resource/",styleId]];

    NSString *fullPath = [[self returnSkinPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/Resource/",styleId]];
    
    return fullPath;
}

- (NSString *)returnSkinPath {
    NSString *documentsPath = [BFDeviceUtils applicationDocumentsDirectory];
    NSString *skinPath = [documentsPath stringByAppendingPathComponent:@"Skin"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:skinPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:skinPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return skinPath;
}

//从网络下载ZIP资源文件，TODO:
- (void)downloadSkinResource {
    
    NSString *tempPath = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"];
    NSString *skinPath = [self returnSkinPath];
    __block NSString *fileName = @"";
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://172.31.2.199:8098/SkinDemo/Default.skin"]];
    NSURLSessionDownloadTask *task = [sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        fileName = response.suggestedFilename;
        NSString *path = [tempPath stringByAppendingPathComponent:fileName];
        return [NSURL fileURLWithPath:path];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSString *filePathString = [filePath path];
        [SSZipArchive unzipFileAtPath:filePathString toDestination:skinPath];
        
        NSArray *array = [fileName componentsSeparatedByString:@"."];
        NSString *styleName = [array firstObject];
        if (styleName.length > 0) {
            [self changeToSkinWithStyleId:styleName];
        }
        
    }];
    [task resume];
    
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
