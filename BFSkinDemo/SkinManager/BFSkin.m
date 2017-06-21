//
//  BFSkin.m
//  BFSkinDemo
//
//  Created by wangxiao on 2017/6/20.
//  Copyright © 2017年 tuniu. All rights reserved.
//

#import "BFSkin.h"
#import "BFSkinManager.h"
#import "SDImageCache.h"

@interface BFSkin ()

//@property (nonatomic, strong) dispatch_queue_t readImageQueue;

@end

@implementation BFSkin

+ (UIColor *)colorFromHexString:(NSString *)stringToConvert {
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6) return [UIColor blackColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];

    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1];
}

+ (UIImage *)imageFromName:(NSString *)name {
    NSString *resourcePath = [[BFSkinManager sharedInstance] returnResourcePath:[BFSkinManager sharedInstance].styleId];
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@",resourcePath,name];
    
    //优先读缓存的图片
    UIImage *image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:imagePath];
    if (!image) {
        image = [UIImage imageWithContentsOfFile:imagePath];
        [[SDImageCache sharedImageCache] storeImage:image forKey:imagePath completion:nil];
    }
    
    return image;
}

@end
