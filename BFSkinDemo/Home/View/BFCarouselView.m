//
//  BFCarouselView.m
//  Pods
//
//  Created by LXY on 2017/5/2.
//
//

#import "BFCarouselView.h"
#import "BFPageControl.h"
#import "BFCarouselModel.h"

#define BoardCarouselBeginTag        100
@interface BFCarouselView ()
{
    /**要显示的数组*/
    NSMutableArray *imageArray;
    /**定时器*/
    NSTimer *scrollTimmer;
    /**当前显示*/
    NSInteger selectedIndex;
    /**支持最大轮播个数(默认8个)*/
    NSInteger carouselMaxItemCount;
    
    UIScrollView *CarouselScrollView;
    
    BFPageControl *CarouselPageControl;
}

@end

@implementation BFCarouselView

#pragma mark - Init
- (id)initWithFrame:(CGRect)frame images:(NSArray *)images {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        
        //设置默认值
        self.carouselAutoScroll = YES;
        self.carouselScrollTimer = 5.f;
        carouselMaxItemCount = 8;
        selectedIndex = 0;//默认显示第一张
        
        //根据最大显示个数调整数组
        [self adjustImagesArrayAccordingMaxAccount:images];
        
        //scrollView
        CarouselScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        CarouselScrollView.backgroundColor = [UIColor whiteColor];
        CarouselScrollView.showsHorizontalScrollIndicator = NO;
        CarouselScrollView.showsVerticalScrollIndicator = NO;
        CarouselScrollView.pagingEnabled = YES;
        CarouselScrollView.scrollEnabled = NO;
        CarouselScrollView.scrollsToTop = NO;
        CarouselScrollView.delegate = self;
        CarouselScrollView.contentSize = CGSizeMake(CarouselScrollView.frame.size.width * 3, CarouselScrollView.frame.size.height);
        [self addSubview:CarouselScrollView];
        
        //pageControl
        CarouselPageControl = [[BFPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - ADAPT_H(9), self.frame.size.width, 2)];
        CarouselPageControl.numberOfPages = [imageArray count];
        CarouselPageControl.currentPage = selectedIndex;
        [self addSubview:CarouselPageControl];
        
        for (NSInteger i = 0; i < 3; i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView setClipsToBounds:YES];
            [imageView setContentMode:UIViewContentModeScaleAspectFill];
            imageView.userInteractionEnabled = YES;
            imageView.tag = BoardCarouselBeginTag + i;
            //点击事件
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCarouselTap:)];
            [imageView addGestureRecognizer:singleTap];
            //frame
            imageView.frame = CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height);
            [CarouselScrollView addSubview:imageView];
        }
    }
    return self;
}

#pragma mark - LifeCycle

- (void)dealloc {
    [scrollTimmer invalidate];
    scrollTimmer = nil;
}

#pragma mark - CustomMethods

//入口（此处作各种前提判断）
- (void)startScrolling {
    //数组不为空
    if (imageArray && [imageArray count] != 0) {
        //加载内容
        [self refreshScrollView];
        
        //仅当开启自动轮播且数组个数大于1
        if (self.carouselAutoScroll && [imageArray count] > 1) {
            [self startTimmer];
        }
        
        //分页符是否显示
        if ([imageArray count] > 1) {
            CarouselPageControl.hidden = NO;
            CarouselScrollView.scrollEnabled = YES;
        } else {
            CarouselPageControl.hidden = YES;
            CarouselScrollView.scrollEnabled = NO;
        }
    } else {
        CarouselScrollView.scrollEnabled = NO;
    }
}

- (void)stopScrolling {
    [self stopTimmer];
}

- (void)reloadCarouselView:(NSArray *)images {
    [self stopScrolling];
    selectedIndex = 0;
    //根据最大显示个数裁剪数组
    [self adjustImagesArrayAccordingMaxAccount:images];
    CarouselPageControl.numberOfPages = imageArray.count;
    CarouselPageControl.currentPage = selectedIndex;
    [self startScrolling];
}

//更新内容
- (void)refreshScrollView {
    //explain:为何在startScrolling中已经做了判断这里还要判断，因为在手动触发scrollViewDidScroll时，传入空数组会导致下面的数组越界
    if (imageArray && [imageArray count] != 0) {
        NSArray *displayArray = [self getDisplayArrayWithCurrentPageIndex:selectedIndex];
        for (NSInteger i = 0; i < 3; i ++) {
            UIImageView *imageView = (UIImageView *)[CarouselScrollView viewWithTag:BoardCarouselBeginTag + i];
            
            BFCarouselModel *model = displayArray[i];
            NSString *url = model.bannerIcon;
            if (imageView && [imageView isKindOfClass:[UIImageView class]]) {
                url = [url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                [imageView bf_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
            }
        }
        CarouselScrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
    }
}

//根据最大显示个数处理入参
- (NSArray *)adjustImagesArrayAccordingMaxAccount:(NSArray *)images {
    if (carouselMaxItemCount == 0) {
        //不允许出现0个
        carouselMaxItemCount = 1;
    }
    imageArray = [NSMutableArray arrayWithCapacity:0];
    if (images && [images count] > 0) {
        if ([images count] > carouselMaxItemCount) {
            [imageArray addObjectsFromArray:[images subarrayWithRange:NSMakeRange(0, carouselMaxItemCount)]];
        } else {
            [imageArray addObjectsFromArray:images];
        }
    }
    return imageArray;
}

- (NSArray *)getDisplayArrayWithCurrentPageIndex:(NSInteger)page {
    NSMutableArray *scrollDataArray = [NSMutableArray arrayWithCapacity:0];
    [scrollDataArray addObject:[imageArray objectAtIndex:[self getPrePage]]];
    [scrollDataArray addObject:[imageArray objectAtIndex:selectedIndex]];
    [scrollDataArray addObject:[imageArray objectAtIndex:[self getNextPage]]];
    return scrollDataArray;
}

- (NSInteger)getPrePage {
    NSInteger result = 0;
    if (selectedIndex == 0) {
        result = [imageArray count] - 1;
    } else {
        result = selectedIndex - 1;
    }
    return result;
}

- (NSInteger)getNextPage {
    NSInteger result = 0;
    if ((selectedIndex + 1) >= [imageArray count]) {
        result = 0;
    } else {
        result = selectedIndex + 1;
    }
    return result;
}

- (void)changeImages {
    selectedIndex ++;
    selectedIndex = selectedIndex % [imageArray count];
    
    //动画切换
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.35f];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
    [CarouselScrollView.layer addAnimation:animation forKey:nil];
    
    [self refreshScrollView];
    [CarouselPageControl setCurrentPage:selectedIndex];
}

#pragma mark - UIResponder Event

- (void)handleCarouselTap:(UITapGestureRecognizer *)tap {
    [[BFAnalysisManager sharedManager] logEvent:@"Banner" eventLabel:@"banner"];
    
    BFCarouselModel *model = imageArray[selectedIndex];
    NSString *urlString = model.bannerUrl;
    if (IS_STR_EMPTY(urlString)) {
        urlString = @"";
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger xOffset = scrollView.contentOffset.x;
    if ((xOffset % (NSInteger)self.frame.size.width == 0)) {
        [CarouselPageControl setCurrentPage:selectedIndex];
    }
    //往下翻一张
    if(xOffset >= (2*self.frame.size.width)) {
        //右
        selectedIndex++;
        selectedIndex = selectedIndex % [imageArray count];
        [self refreshScrollView];
    }
    if(xOffset <= 0) {
        //左
        if (selectedIndex == 0) {
            selectedIndex = (NSInteger)[imageArray count] - 1;
        } else {
            selectedIndex--;
        }
        [self refreshScrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimmer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView {
    [CarouselScrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.carouselAutoScroll && [imageArray count] > 1) {
        [self startTimmer];
    }
}

#pragma mark - Timer

- (void)startTimmer {
    scrollTimmer = [NSTimer scheduledTimerWithTimeInterval:self.carouselScrollTimer
                                                    target:self
                                                  selector:@selector(changeImages)
                                                  userInfo:nil
                                                   repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:scrollTimmer forMode:NSRunLoopCommonModes];
}

- (void)stopTimmer {
    [scrollTimmer invalidate];
    scrollTimmer = nil;
}

@end
