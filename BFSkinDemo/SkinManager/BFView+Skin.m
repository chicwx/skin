//
//  BFView+Skin.m
//  BFSkinDemo
//
//  Created by wangxiao on 2017/6/20.
//  Copyright © 2017年 tuniu. All rights reserved.
//

#import "BFView+Skin.h"
#import <objc/runtime.h>
#import "BFSkinManager.h"
#import "NSObject+DeallocBlock.h"

NSString *kThemeMapKeyImageName             = @"kThemeMapKeyImageName";
NSString *kThemeMapKeyHighlightedImageName  = @"kThemeMapKeyHighlightedImageName";
NSString *kThemeMapKeySelectedImageName     = @"kThemeMapKeySelectedImageName";
NSString *kThemeMapKeyDisabledImageName     = @"kThemeMapKeyDisabledImageName";

NSString *kThemeMapKeyColorName             = @"kThemeMapKeyColorName";
NSString *kThemeMapKeyHighlightedColorName  = @"kThemeMapKeyHighlightedColorName";
NSString *kThemeMapKeySelectedColorName     = @"kThemeMapKeySelectedColorName";
NSString *kThemeMapKeyDisabledColorName     = @"kThemeMapKeyDisabledColorName";

NSString *kThemeMapKeyBgColorName           = @"kThemeMapKeyBgColorName";

// Slider
NSString *kThemeMapKeyMinValueImageName     = @"kThemeMapKeyMinValueImageName";
NSString *kThemeMapKeyMaxValueImageName     = @"kThemeMapKeyMaxValueImageName";

NSString *kThemeMapKeyThumbImageName        = @"kThemeMapKeyThumbImageName";
NSString *kThemeMapKeyHighlightedThumbImageName = @"kThemeMapKeyHighlightedThumbImageName";
NSString *kThemeMapKeyDisabledThumbImageName    = @"kThemeMapKeyDisabledThumbImageName";

NSString *kThemeMapKeyMinTrackImageName     = @"kThemeMapKeyMinTrackImageName";
NSString *kThemeMapKeyHighlightedMinTrackImageName = @"kThemeMapKeyHighlightedMinTrackImageName";
NSString *kThemeMapKeyDisabledMinTrackImageName = @"kThemeMapKeyDisabledMinTrackImageName";

NSString *kThemeMapKeyMaxTrackImageName     = @"kThemeMapKeyMaxTrackImageName";
NSString *kThemeMapKeyHighlightedMaxTrackImageName = @"kThemeMapKeyHighlightedMaxTrackImageName";
NSString *kThemeMapKeyDisabledMaxTrackImageName = @"kThemeMapKeyDisabledMaxTrackImageName";

NSString *kThemeMapKeyMinTrackTintColorName = @"kThemeMapKeyMinTrackTintColorName";
NSString *kThemeMapKeyMaxTrackTintColorName = @"kThemeMapKeyMaxTrackTintColorName";

static void *kUIView_ThemeMap;
static void *kUIView_DeallocHelper;

@implementation UIView (Skin)

- (void)setThemeMap:(NSDictionary *)themeMap {
    objc_setAssociatedObject(self, &kUIView_ThemeMap, themeMap, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    if (themeMap) {
        @autoreleasepool {
            // Need to removeObserver in dealloc
            if (objc_getAssociatedObject(self, &kUIView_DeallocHelper) == nil) {
                __unsafe_unretained typeof(self) weakSelf = self; // NOTE: need to be __unsafe_unretained because __weak var will be reset to nil in dealloc
                id deallocHelper = [self bf_addDeallocBlock:^{
                    NSLog(@"deallocing %@", weakSelf);
                    [[NSNotificationCenter defaultCenter] removeObserver:weakSelf];
                }];
                objc_setAssociatedObject(self, &kUIView_DeallocHelper, deallocHelper, OBJC_ASSOCIATION_ASSIGN);
            }
            
            [[NSNotificationCenter defaultCenter] removeObserver:self name:kSkinDidChangeNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChanged) name:kSkinDidChangeNotification object:nil];
            [self themeChanged];
        }
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kSkinDidChangeNotification object:nil];
    }
    
}

- (NSDictionary *)themeMap {
    return objc_getAssociatedObject(self, &kUIView_ThemeMap);
}

- (void)themeChanged {
    // TODO: performace tuning
    if (self.hidden) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self changeTheme];
        });
    } else {
        [self changeTheme];
    }
}

- (void)changeTheme {
    NSDictionary *map = self.themeMap;
    if ([self isKindOfClass:[UILabel class]]) {
        UILabel *obj = (UILabel *)self;
        if (map[kThemeMapKeyColorName]) {
            obj.textColor = BFSkinColor(map[kThemeMapKeyColorName]);
        }
        if (map[kThemeMapKeyHighlightedColorName]) {
            obj.highlightedTextColor = BFSkinColor(map[kThemeMapKeyHighlightedColorName]);
        }
        if (map[kThemeMapKeyBgColorName]) {
            obj.backgroundColor = BFSkinColor(map[kThemeMapKeyBgColorName]);
        }
    } else if ([self isKindOfClass:[UIButton class]]) {
        UIButton *obj = (UIButton *)self;
        if (map[kThemeMapKeyColorName]) {
            [obj setTitleColor:BFSkinColor(map[kThemeMapKeyColorName]) forState:UIControlStateNormal];
        }
        if (map[kThemeMapKeyHighlightedColorName]) {
            [obj setTitleColor:BFSkinColor(map[kThemeMapKeyHighlightedColorName]) forState:UIControlStateHighlighted];
        }
        if (map[kThemeMapKeySelectedColorName]) {
            [obj setTitleColor:BFSkinColor(map[kThemeMapKeySelectedColorName]) forState:UIControlStateSelected];
        }
        if (map[kThemeMapKeyDisabledColorName]) {
            [obj setTitleColor:BFSkinColor(map[kThemeMapKeyDisabledColorName]) forState:UIControlStateDisabled];
        }
        if (map[kThemeMapKeyImageName]) {
            [obj setImage:BFSkinImage(map[kThemeMapKeyImageName]) forState:UIControlStateNormal];
        }
        if (map[kThemeMapKeyHighlightedImageName]) {
            [obj setImage:BFSkinImage(map[kThemeMapKeyHighlightedImageName]) forState:UIControlStateHighlighted];
        }
        if (map[kThemeMapKeySelectedImageName]) {
            [obj setImage:BFSkinImage(map[kThemeMapKeySelectedImageName]) forState:UIControlStateSelected];
        }
        if (map[kThemeMapKeyDisabledImageName]) {
            [obj setImage:BFSkinImage(map[kThemeMapKeyDisabledImageName]) forState:UIControlStateDisabled];
        }
        if (map[kThemeMapKeyBgColorName]) {
            obj.backgroundColor = BFSkinColor(map[kThemeMapKeyBgColorName]);
        }
    } else if ([self isKindOfClass:[UIImageView class]]) {
        UIImageView *obj = (UIImageView *)self;
        if (map[kThemeMapKeyImageName]) {
            obj.image = BFSkinImage(map[kThemeMapKeyImageName]);
        }
        if (map[kThemeMapKeyHighlightedImageName]) {
            obj.highlightedImage = BFSkinImage(map[kThemeMapKeyHighlightedImageName]);
        }
        if (map[kThemeMapKeyColorName]) {
            obj.backgroundColor = BFSkinColor(map[kThemeMapKeyColorName]);
        }
    } else if ([self isKindOfClass:[UISlider class]]) {
        UISlider *obj = (UISlider *)self;
        if (map[kThemeMapKeyMinValueImageName]) {
            obj.minimumValueImage = BFSkinImage(map[kThemeMapKeyMinValueImageName]);
        }
        if (map[kThemeMapKeyMaxValueImageName]) {
            obj.maximumValueImage = BFSkinImage(map[kThemeMapKeyMaxValueImageName]);
        }
        
        if (map[kThemeMapKeyThumbImageName]) {
            [obj setThumbImage:BFSkinImage(map[kThemeMapKeyThumbImageName]) forState:UIControlStateNormal];
        }
        if (map[kThemeMapKeyHighlightedThumbImageName]) {
            [obj setThumbImage:BFSkinImage(map[kThemeMapKeyHighlightedThumbImageName]) forState:UIControlStateHighlighted];
        }
        if (map[kThemeMapKeyDisabledThumbImageName]) {
            [obj setThumbImage:BFSkinImage(map[kThemeMapKeyDisabledThumbImageName]) forState:UIControlStateDisabled];
        }
        
        if (map[kThemeMapKeyMinTrackImageName]) {
            [obj setMinimumTrackImage:BFSkinImage(map[kThemeMapKeyMinTrackImageName]) forState:UIControlStateNormal];
        }
        if (map[kThemeMapKeyHighlightedMinTrackImageName]) {
            [obj setMinimumTrackImage:BFSkinImage(map[kThemeMapKeyHighlightedMinTrackImageName]) forState:UIControlStateHighlighted];
        }
        if (map[kThemeMapKeyDisabledMinTrackImageName]) {
            [obj setMinimumTrackImage:BFSkinImage(map[kThemeMapKeyDisabledMinTrackImageName]) forState:UIControlStateDisabled];
        }
        
        if (map[kThemeMapKeyMaxTrackImageName]) {
            [obj setMaximumTrackImage:BFSkinImage(map[kThemeMapKeyMaxTrackImageName]) forState:UIControlStateNormal];
        }
        if (map[kThemeMapKeyHighlightedMaxTrackImageName]) {
            [obj setMaximumTrackImage:BFSkinImage(map[kThemeMapKeyHighlightedMaxTrackImageName]) forState:UIControlStateHighlighted];
        }
        if (map[kThemeMapKeyDisabledMaxTrackImageName]) {
            [obj setMaximumTrackImage:BFSkinImage(map[kThemeMapKeyDisabledMaxTrackImageName]) forState:UIControlStateDisabled];
        }
        
        if (map[kThemeMapKeyMinTrackTintColorName]) {
            obj.minimumTrackTintColor = BFSkinColor(map[kThemeMapKeyMinTrackTintColorName]);
        }
        if (map[kThemeMapKeyMaxTrackTintColorName]) {
            obj.maximumTrackTintColor = BFSkinColor(map[kThemeMapKeyMaxTrackTintColorName]);
        }
    } else if ([self isKindOfClass:[UITextField class]]) {
        UITextField *obj = (UITextField *)self;
        if (map[kThemeMapKeyColorName]) {
            obj.textColor = BFSkinColor(map[kThemeMapKeyColorName]);
        }
    } else if ([self isKindOfClass:[UITextView class]]) {
        UITextView *obj = (UITextView *)self;
        if (map[kThemeMapKeyColorName]) {
            obj.textColor = BFSkinColor(map[kThemeMapKeyColorName]);
        }
    } else {
        if (map[kThemeMapKeyColorName]) {
            self.backgroundColor = BFSkinColor(map[kThemeMapKeyColorName]);
        }
    }
}

@end
