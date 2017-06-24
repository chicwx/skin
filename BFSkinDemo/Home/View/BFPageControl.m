//
//  BFPageControl.m
//  Pods
//
//  Created by LXY on 2017/5/2.
//
//

#import "BFPageControl.h"


#define UnSelectColor RGBCOLOR(234, 235, 236)
#define SelectColor RGBCOLOR(83, 124, 251)
#define BeginTag 100
@implementation BFPageControl
{
    NSInteger _CurrentIndex;
}

#pragma mark setter方法
-(void)setCurrentPage:(NSInteger)currentPage {
    if (currentPage != _CurrentIndex) {
        UIView *view = [self viewWithTag:_CurrentIndex + BeginTag];
        view.backgroundColor = UnSelectColor;
        UIView *SeletView = [self viewWithTag:currentPage + BeginTag];
        SeletView.backgroundColor = SelectColor;
        _CurrentIndex = currentPage;
    }
}

- (void)setNumberOfPages:(NSInteger)numberOfPages {
    [self qmui_removeAllSubviews];
    CGFloat orgX =  (SCREEN_WIDTH - ADAPT_W(13) * numberOfPages - ADAPT_W(1)) / 2;
    _CurrentIndex = 0;
    for (int i = 0; i < numberOfPages; i ++) {
        UIView * pageControll = [[UIView alloc]initWithFrame:CGRectMake(orgX + i * ADAPT_H(13), 0, ADAPT_W(12), 2)];
        pageControll.backgroundColor = (i == 0)?SelectColor:UnSelectColor;
        pageControll.tag = i + BeginTag;
        pageControll.layer.cornerRadius = 1;
        pageControll.clipsToBounds = YES;
        [self addSubview:pageControll];
    }
}

@end
