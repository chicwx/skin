//
//  UIView+Skin.m
//  BFSkinDemo
//
//  Created by wangxiao on 2017/6/20.
//  Copyright © 2017年 tuniu. All rights reserved.
//

#import "UIView+Skin.h"
#import <objc/runtime.h>
#import "NSObject+DeallocBlock.h"
#import "YYModel.h"
#import "UIImageView+WebCache.h"

static void *kUIView_DeallocHelper;
static void *kUIView_BFSkinStyle;
static void *kUIView_SkinCache;

@implementation UIView (Skin)

- (void)setBf_skinStyle:(NSString *)bf_skinStyle {
    objc_setAssociatedObject(self, &kUIView_BFSkinStyle, bf_skinStyle, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    if (bf_skinStyle) {
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
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(skinChanged) name:kSkinDidChangeNotification object:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:kSkinResetNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetStyle) name:kSkinResetNotification object:nil];

            [self skinChanged];
        }
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kSkinDidChangeNotification object:nil];
    }
    
}

- (NSString *)bf_skinStyle {
    return objc_getAssociatedObject(self, &kUIView_BFSkinStyle);
}

- (void)setBf_skinCache:(BFSkinCache *)bf_skinCache {
    objc_setAssociatedObject(self, &kUIView_SkinCache, bf_skinCache, OBJC_ASSOCIATION_RETAIN);
}

- (BFSkinCache *)bf_skinCache {
    return objc_getAssociatedObject(self, &kUIView_SkinCache);
}

- (void)skinChanged {
    // TODO: performace tuning
    if (self.hidden) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self changeSkin];
        });
    } else {
        [self changeSkin];
    }
}

- (void)changeSkin {
    //缓存代码中的样式
    if (!self.bf_skinCache) {
        BFSkinCache *skinCache = [BFSkinCache new];
        skinCache.backgroundColorNormal = self.backgroundColor;
        skinCache.radius = self.layer.cornerRadius;
        if ([self isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)self;
            skinCache.font = label.font;
            skinCache.textColorNormal = label.textColor;
        }
        if ([self isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)self;
            skinCache.font = button.titleLabel.font;
            skinCache.textColorNormal = [button titleColorForState:UIControlStateNormal];
            skinCache.textColorPress = [button titleColorForState:UIControlStateFocused];
            skinCache.textColorDisable = [button titleColorForState:UIControlStateDisabled];
            
            skinCache.backgroundImageNormal = [button imageForState:UIControlStateNormal];
            skinCache.backgroundImagePress = [button imageForState:UIControlStateFocused];
            skinCache.backgroundImageDisable = [button imageForState:UIControlStateDisabled];
            
        }
        if ([self isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView = (UIImageView *)self;
            skinCache.backgroundImageNormal = imageView.image;
        }
        self.bf_skinCache = skinCache;
    }
    
    //重置为代码样式
    [self resetStyle];
    
    //读取配置文件样式
    NSString *skinStyle = self.bf_skinStyle;
    NSDictionary *styleInfo = [BFSkinManager sharedInstance].skinConfigDictionary[skinStyle];
    BFSkin *skin = [BFSkin yy_modelWithJSON:styleInfo];
    
    if (skin.backgroundColor.backgroundColorNormal.length > 0) {
        self.backgroundColor = [BFSkin colorFromHexString:skin.backgroundColor.backgroundColorNormal];
    }
    
    if (skin.radius.length > 0) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = [skin.radius floatValue];
    }
    
    if ([self isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)self;

        if (skin.textColor.textColorNormal) {
            label.textColor = [BFSkin colorFromHexString:skin.textColor.textColorNormal];
        }

        if (skin.textFontSize) {
            label.font = [UIFont systemFontOfSize:[skin.textFontSize floatValue]];
        }
    }
    if ([self isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)self;
        if (skin.textColor.textColorNormal) {
            [button setTitleColor:[BFSkin colorFromHexString:skin.textColor.textColorNormal] forState:UIControlStateNormal];
        }
        if (skin.textColor.textColorPress) {
            [button setTitleColor:[BFSkin colorFromHexString:skin.textColor.textColorPress] forState:UIControlStateFocused];
        }
        if (skin.textColor.textColorDisable) {
            [button setTitleColor:[BFSkin colorFromHexString:skin.textColor.textColorDisable] forState:UIControlStateDisabled];
        }
        
        if (skin.backgroundColor.backgroundColorNormal) {
            [button setImage:[UIImage bf_imageWithColor:[BFSkin colorFromHexString:skin.backgroundColor.backgroundColorNormal]] forState:UIControlStateNormal];
        }
        if (skin.backgroundColor.backgroundColorPress) {
            [button setImage:[UIImage bf_imageWithColor:[BFSkin colorFromHexString:skin.backgroundColor.backgroundColorPress]] forState:UIControlStateFocused];
        }
        if (skin.backgroundColor.backgroundColorDisable) {
            [button setImage:[UIImage bf_imageWithColor:[BFSkin colorFromHexString:skin.backgroundColor.backgroundColorDisable]] forState:UIControlStateDisabled];
        }
        
        if (skin.backgroundImage.backgroundImageNormal) {
            [button setImage:[BFSkin imageFromName:skin.backgroundImage.backgroundImageNormal] forState:UIControlStateNormal];
        }
        if (skin.backgroundImage.backgroundImagePress) {
            [button setImage:[BFSkin imageFromName:skin.backgroundImage.backgroundImagePress] forState:UIControlStateFocused];
        }
        if (skin.backgroundImage.backgroundImageDisable) {
            [button setImage:[BFSkin imageFromName:skin.backgroundImage.backgroundImageDisable] forState:UIControlStateDisabled];
        }
        
    }
    if ([self isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView *)self;
        if (skin.backgroundImage.backgroundImageNormal) {
//            imageView.image = [BFSkin imageFromName:skin.backgroundImage];
            
            NSString *resourcePath = [[BFSkinManager sharedInstance] returnResourcePath:[BFSkinManager sharedInstance].styleId];
            NSString *imagePath = [NSString stringWithFormat:@"%@/%@",resourcePath,skin.backgroundImage.backgroundImageNormal];
            [imageView sd_setImageWithURL:[NSURL fileURLWithPath:imagePath]];
            
        }
    }
    
}

- (void)resetStyle {
    self.backgroundColor = self.bf_skinCache.backgroundColorNormal;
    if (self.bf_skinCache.radius > 0) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = self.bf_skinCache.radius;
    }
    if ([self isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)self;
        label.textColor = self.bf_skinCache.textColorNormal;
        label.font = self.bf_skinCache.font;
    }
    if ([self isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)self;
        
        if (self.bf_skinCache.textColorNormal) {
            [button setTitleColor:self.bf_skinCache.textColorNormal forState:UIControlStateNormal];
        }
        if (self.bf_skinCache.textColorPress) {
            [button setTitleColor:self.bf_skinCache.textColorPress forState:UIControlStateFocused];
        }
        if (self.bf_skinCache.textColorDisable) {
            [button setTitleColor:self.bf_skinCache.textColorDisable forState:UIControlStateDisabled];
        }
        
        if (self.bf_skinCache.backgroundImageNormal) {
            [button setImage:self.bf_skinCache.backgroundImageNormal forState:UIControlStateNormal];
        }
        if (self.bf_skinCache.backgroundImagePress) {
            [button setImage:self.bf_skinCache.backgroundImagePress forState:UIControlStateFocused];
        }
        if (self.bf_skinCache.backgroundImageDisable) {
            [button setImage:self.bf_skinCache.backgroundImageDisable forState:UIControlStateDisabled];
        }
        
    }
    if ([self isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView *)self;
        if (self.bf_skinCache.backgroundImageNormal) {
            imageView.image = self.bf_skinCache.backgroundImageNormal;
        }
    }
}

@end
