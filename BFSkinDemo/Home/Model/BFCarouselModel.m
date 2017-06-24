//
//  BFCarouselModel.m
//  Pods
//
//  Created by LXY on 2017/5/2.
//
//

#import "BFCarouselModel.h"

@implementation BFCarouselModel

@end

@implementation BFAccountInfo


@end

@implementation BFHomeTabIcon

@end

@implementation BFHomeLayout
+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"bannerList" : [BFCarouselModel class],
             @"tabs" : [BFHomeTabIcon class]};
}
@end
