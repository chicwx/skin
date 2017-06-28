//
//  UIView+Skin.h
//  BFSkinDemo
//
//  Created by wangxiao on 2017/6/20.
//  Copyright © 2017年 tuniu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BFSkinManager.h"
#import <UIKit/UIKit.h>

@interface UIView (Skin)

@property (nonatomic, strong) NSString *bf_skinStyle;
@property (nonatomic, strong) BFSkinCache *bf_skinCache;

@end
