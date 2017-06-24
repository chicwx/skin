//
//  BFCarouselView.h
//  Pods
//
//  Created by LXY on 2017/5/2.
//
//

#import <UIKit/UIKit.h>

@interface BFCarouselView : UIView
/**是否自动轮播(默认开启)*/
@property (nonatomic, assign) BOOL carouselAutoScroll;

/**滚动间隔时间(默认5s)*/
@property (nonatomic, assign) NSTimeInterval carouselScrollTimer;

/**初始化滚动视图*/
- (id)initWithFrame:(CGRect)frame images:(NSArray *)images;

/**开始滚动*/
- (void)startScrolling;

/**停止滚动*/
- (void)stopScrolling;

/**刷新视图*/
- (void)reloadCarouselView:(NSArray *)images;
@end
