//
//  BFSkin.h
//  BFSkinDemo
//
//  Created by wangxiao on 2017/6/20.
//  Copyright © 2017年 tuniu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BFSkinColor : NSObject

@property (nonatomic, copy) NSString *textColorNormal;
@property (nonatomic, copy) NSString *textColorPress;
@property (nonatomic, copy) NSString *textColorDisable;

@end

@interface BFSkinBackgroundColor : NSObject

@property (nonatomic, copy) NSString *backgroundColorNormal;
@property (nonatomic, copy) NSString *backgroundColorPress;
@property (nonatomic, copy) NSString *backgroundColorDisable;

@end

@interface BFSkinBackgroundImage : NSObject

@property (nonatomic, copy) NSString *backgroundImageNormal;
@property (nonatomic, copy) NSString *backgroundImagePress;
@property (nonatomic, copy) NSString *backgroundImageDisable;

@end

@interface BFSkin : NSObject

+ (UIColor *)colorFromHexString:(NSString *)stringToConvert;
+ (UIImage *)imageFromName:(NSString *)name;

@property (nonatomic, copy) NSString *radius;
@property (nonatomic, copy) NSString *textFontSize;
@property (nonatomic, strong) BFSkinColor *textColor;
@property (nonatomic, strong) BFSkinBackgroundColor *backgroundColor;
@property (nonatomic, strong) BFSkinBackgroundImage *backgroundImage;

@end

#pragma mark - BFSkinCache
@interface BFSkinCache : NSObject

@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColorNormal;
@property (nonatomic, strong) UIColor *textColorPress;
@property (nonatomic, strong) UIColor *textColorDisable;
@property (nonatomic, strong) UIColor *backgroundColorNormal;
//@property (nonatomic, strong) UIColor *backgroundColorPress;
//@property (nonatomic, strong) UIColor *backgroundColorDisable;
@property (nonatomic, strong) UIImage *backgroundImageNormal;
@property (nonatomic, strong) UIImage *backgroundImagePress;
@property (nonatomic, strong) UIImage *backgroundImageDisable;

@end
