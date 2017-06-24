//
//  BFToolCell.m
//  Pods
//
//  Created by LXY on 2017/4/27.
//
//

#import "BFToolCell.h"

@interface BFToolCell ()

@property (nonatomic, strong) UIButton *firstButton;
@property (nonatomic, strong) UIButton *secondButton;
@property (nonatomic, strong) UIButton *thirdButton;
@property (nonatomic, strong) UIButton *fourthButton;
@property (nonatomic, strong) UILabel *firstLabel;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) UILabel *thirdLabel;
@property (nonatomic, strong) UILabel *fourthLabel;
@property (nonatomic, strong) UIImageView *firstImageView;
@property (nonatomic, strong) UIImageView *secondImageView;
@property (nonatomic, strong) UIImageView *thirdImageView;
@property (nonatomic, strong) UIImageView *fourthImageView;
@property (nonatomic, strong) NSArray *buttonArray;
@property (nonatomic, strong) NSArray *labelArray;
@property (nonatomic, strong) NSArray *imageViewArray;

@end

@implementation BFToolCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadNativeData];
        [self layoutSubview];
    }
    return self;
}

- (void)loadNativeData {
    self.firstButton = [self createButtonWithIndex:0];
    self.secondButton = [self createButtonWithIndex:1];
    self.thirdButton = [self createButtonWithIndex:2];
    self.fourthButton = [self createButtonWithIndex:3];
    
    self.firstLabel = [self createLabel];
    self.secondLabel = [self createLabel];
    self.thirdLabel = [self createLabel];
    self.fourthLabel = [self createLabel];
    
    self.firstImageView = [[UIImageView alloc] init];
    self.secondImageView = [[UIImageView alloc] init];
    self.thirdImageView = [[UIImageView alloc] init];
    self.fourthImageView = [[UIImageView alloc] init];
    
    self.buttonArray = @[self.firstButton, self.secondButton, self.thirdButton, self.fourthButton];
    self.labelArray = @[self.firstLabel, self.secondLabel, self.thirdLabel, self.fourthLabel];
    self.imageViewArray = @[self.firstImageView, self.secondImageView, self.thirdImageView, self.fourthImageView];
}

- (void)handleTap:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(toolSelect:selectIndex:)]) {
        [_delegate toolSelect:self selectIndex:((UIButton *)sender).tag - 10001];
    }
}

- (void)layoutSubview {
    [self addSubview:self.topView];
    [self.topView bf_pinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:BFAEdgeBottom];
    [self.topView bf_setDimensionsToSize:CGSizeMake(SCREEN_WIDTH, ADAPT_H(100))];
    [self.topView qmui_removeAllSubviews];
   
    CGFloat width = SCREEN_WIDTH / 4;

    __block UIButton *tempButton = [[UIButton alloc] init];
    [self.buttonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.topView addSubview:button];
        [button bf_setDimensionsToSize:CGSizeMake(width, ADAPT_H(100))];
        [button bf_alignAxisToSuperviewAxis:BFAAxisHorizontal];
        if (idx == 0) {
            [button bf_pinEdgeToSuperviewEdge:BFAEdgeLeft];
        } else {
            [button bf_pinEdge:BFAEdgeLeft toEdge:BFAEdgeRight ofView:tempButton];
        }
        //增加imageView
        UIImageView *imageView = [self.imageViewArray safeObjectAtIndex:idx];
        [button addSubview:imageView];
        [imageView bf_setDimensionsToSize:CGSizeMake(ADAPT_W(26), ADAPT_H(24))];
        [imageView bf_alignAxisToSuperviewAxis:BFAAxisVertical];
        [imageView bf_pinEdgeToSuperviewEdge:BFAEdgeTop withInset:ADAPT_H(26)];
        //增加label
        UILabel *label = [self.labelArray safeObjectAtIndex:idx];
        [button addSubview:label];
        [label bf_alignAxisToSuperviewAxis:BFAAxisVertical];
        [label bf_pinEdge:BFAEdgeTop toEdge:BFAEdgeBottom ofView:imageView withOffset:ADAPT_H(8)];
        tempButton = button;
    }];
}


- (void)bindModelWithArray:(NSArray <BFHomeTabIcon *>*)modelArray {
    if (modelArray.count != 0) {
        BFHomeTabIcon *firstIcon = [modelArray safeObjectAtIndex:0];
        BFHomeTabIcon *secondIcon = [modelArray safeObjectAtIndex:1];
        BFHomeTabIcon *thirdIcon = [modelArray safeObjectAtIndex:2];
        BFHomeTabIcon *fourthIcon = [modelArray safeObjectAtIndex:3];
        self.firstLabel.text = firstIcon.tabName;
        self.secondLabel.text = secondIcon.tabName;
        self.thirdLabel.text = thirdIcon.tabName;
        self.fourthLabel.text = fourthIcon.tabName;
        [self.firstImageView bf_setImageWithURL:[NSURL URLWithString:firstIcon.tabIcon]];
        [self.secondImageView bf_setImageWithURL:[NSURL URLWithString:secondIcon.tabIcon]];
        [self.thirdImageView bf_setImageWithURL:[NSURL URLWithString:thirdIcon.tabIcon]];
        [self.fourthImageView bf_setImageWithURL:[NSURL URLWithString:fourthIcon.tabIcon]];
    } else {
        self.firstLabel.text = @"扫一扫";
        self.secondLabel.text = @"银行卡";
        self.thirdLabel.text = @"优惠券";
        self.fourthLabel.text = @"交易记录";
        
        self.firstLabel.bf_skinStyle = self.firstImageView.bf_skinStyle = @"skin_tool_icon_scan";
        self.secondLabel.bf_skinStyle = self.secondImageView.bf_skinStyle = @"skin_tool_icon_bankcard";
        self.thirdLabel.bf_skinStyle = self.thirdImageView.bf_skinStyle = @"skin_tool_icon_coupon";
        self.fourthLabel.bf_skinStyle = self.fourthImageView.bf_skinStyle = @"skin_tool_icon_record";

    }
}

- (UIButton *)createButtonWithIndex:(NSInteger)index {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = 10001 + index;
    button.backgroundColor = [UIColor clearColor];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [button addTarget:self action:@selector(handleTap:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UILabel *)createLabel {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = RGBCOLOR(34, 34, 34);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = FONT(14.f);
    [label sizeToFit];
    return label;
}

- (UIView *)topView {
    if(!_topView){
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = UIColorWhite;
    }
    return _topView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
