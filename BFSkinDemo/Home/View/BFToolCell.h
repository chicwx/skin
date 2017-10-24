//
//  BFToolCell.h
//  Pods
//
//  Created by LXY on 2017/4/27.
//
//

#import <UIKit/UIKit.h>
#import "BFCarouselModel.h"

@class BFToolCell;

@protocol HomeToolDelegate <NSObject>
@optional

- (void)toolSelect:(BFToolCell *)ToolView selectIndex:(NSInteger)selectIndex;

@end


@interface BFToolCell : UITableViewCell

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, weak) id<HomeToolDelegate> delegate;

- (void)bindModelWithArray:(NSArray <BFHomeTabIcon *>*)modelArray;

@end
