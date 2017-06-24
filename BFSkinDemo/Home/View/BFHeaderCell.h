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
@property (nonatomic, strong) BFButton *HideBtn;
@property (nonatomic, strong) BFButton *MiddleBtn;
@property (nonatomic, strong) BFButton *bottomBtn;
@property (nonatomic, strong) BFLabel *TitleLabel;
@property (nonatomic, strong) BFLabel *availableTitleLabel;
@property (nonatomic, strong) BFLabel *availableCreditLabel;
@property (nonatomic, strong) BFLabel *TotalCreditLabel;
@property (nonatomic, copy) NSString *TitleText;
@property (nonatomic, copy) NSString *CreditText;
@property (nonatomic, copy) NSString *TotalCreditText;
@property (nonatomic, weak) id<HomeHeaderDelegate> delegate;

- (void)messageAnimation;

@end
