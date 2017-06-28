//
//  UIView+Skin.m
//  BFSkinDemo
//
//  Created by wangxiao on 2017/6/20.
//  Copyright © 2017年 tuniu. All rights reserved.
//

#import "UIView+Skin.h"
#import <objc/runtime.h>
#import "BFSkinManager.h"
#import "NSObject+DeallocBlock.h"
#import "YYModel.h"
#import "UIImageView+WebCache.h"

static void *kUIView_DeallocHelper;
static void *kUIView_BFSkinStyle;

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
            [self skinChanged];
        }
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kSkinDidChangeNotification object:nil];
    }
    
}

- (NSString *)bf_skinStyle {
    return objc_getAssociatedObject(self, &kUIView_BFSkinStyle);
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

@end
