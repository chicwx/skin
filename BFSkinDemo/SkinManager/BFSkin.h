//
//  BFSkin.h
//  BFSkinDemo
//
//  Created by wangxiao on 2017/6/20.
//  Copyright © 2017年 tuniu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BFSkin : NSObject

+ (UIColor *)colorFromHexString:(NSString *)stringToConvert;
+ (UIImage *)imageFromName:(NSString *)name;

@property (nonatomic, copy) NSString *textColor;
@property (nonatomic, copy) NSString *textColorPress;
@property (nonatomic, copy) NSString *textColorDisable;
@property (nonatomic, copy) NSString *textFontSize;
@property (nonatomic, copy) NSString *backgroundColor;
@property (nonatomic, copy) NSString *backgroundImage;

@end
