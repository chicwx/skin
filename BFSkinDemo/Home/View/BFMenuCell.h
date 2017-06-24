//
//  BFMenuCell.h
//  Pods
//
//  Created by LXY on 2017/4/27.
//
//

#import <UIKit/UIKit.h>
@class BFMenuCell;

@protocol HomeMenuDelegate <NSObject>
@optional

- (void)menuSelect:(BFMenuCell *)MenuView selectIndex:(NSInteger)selectIndex;

@end


@interface BFMenuCell : UITableViewCell

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, weak) id<HomeMenuDelegate> delegate;

- (void)updateAmount:(NSString *)amount;

@end
