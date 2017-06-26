//
//  BFHeaderCell.h
//  Pods
//
//  Created by LXY on 2017/5/3.
//
//

#import <UIKit/UIKit.h>

@protocol HomeHeaderDelegate <NSObject>
@optional

- (void)messageButtonClick;

@end

@interface BFHeaderCell : UITableViewCell
@property (nonatomic, strong) UIImageView *headBackImageView;
@property (nonatomic, strong) UIImageView *messageImageView;
@property (nonatomic, strong) BFButton *hideBtn;
@property (nonatomic, strong) BFButton *middleBtn;
@property (nonatomic, strong) BFButton *bottomBtn;
@property (nonatomic, strong) BFLabel *titleLabel;
@property (nonatomic, strong) BFLabel *availableTitleLabel;
@property (nonatomic, strong) BFLabel *availableCreditLabel;
@property (nonatomic, strong) BFLabel *totalCreditLabel;
@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *creditText;
@property (nonatomic, copy) NSString *totalCreditText;
@property (nonatomic, weak) id<HomeHeaderDelegate> delegate;

- (void)messageAnimation;

@end
