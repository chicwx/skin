//
//  BFDeallocBlockExecutor.m
//  WonderPlayerDemo
//
//  Created by Yanjun Zhuang on 14/6/15.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import "BFDeallocBlockExecutor.h"

@implementation BFDeallocBlockExecutor

+ (instancetype)executorWithDeallocBlock:(void (^)())deallocBlock {
    BFDeallocBlockExecutor *executor = [BFDeallocBlockExecutor new];
    executor.deallocBlock = deallocBlock;
    return executor;
}

- (void)dealloc {
    if (self.deallocBlock) {
        self.deallocBlock();
        self.deallocBlock = nil;
    }
}

@end
