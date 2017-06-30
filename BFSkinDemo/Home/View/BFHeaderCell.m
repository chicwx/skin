//
//  BFHeaderCell.m
//  Pods
//
//  Created by LXY on 2017/5/3.
//
//

#import "BFHeaderCell.h"
#import "BFSkinManager.h"

@implementation BFHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layoutSubview];
    }
    return self;
}

#pragma  mark private Method
- (void)hidenBtnClick:(BFButton *)button {
    [[BFAnalysisManager sharedManager] logEvent:@"Availablelimit" eventLabel:@"可用额度"];
    
    if (button.selected == NO) {
        self.titleText = self.availableTitleLabel.text;
        self.creditText = self.availableCreditLabel.text;
        self.totalCreditText = self.totalCreditLabel.text;
        self.availableTitleLabel.text = @"可用消费信用额度(元)";
        self.availableCreditLabel.text = @"恭喜发财";
        self.totalCreditLabel.text = @"总消费额度******      本月账单******";
    } else {
        self.availableTitleLabel.text = self.titleText;
        self.availableCreditLabel.text = self.creditText;
        self.totalCreditLabel.text = self.totalCreditText;
    }
    button.selected = !button.selected;
}

- (void)messageAnimation {
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    //动画
    for (int i = 0; i < 41; i++) {
        [imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"icon_bell%d", i]]];
    }
    self.messageImageView.animationImages = imageArray;
    self.messageImageView.animationDuration = 1;
    self.messageImageView.animationRepeatCount = 0;
    [self.messageImageView startAnimating];
}

- (void)messageImageViewClick {
    //停止动画
    [self.messageImageView stopAnimating];
    //跳H5消息中心
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageButtonClick)]) {
        [self.delegate messageButtonClick];
    }
}

- (void)MiddleBtnClick {
    //跳认证中心
}

- (void)tapClick{
    //去登录
    if ([[[BFSkinManager sharedInstance] readCacheConfig] isEqualToString:@"Default"]) {
        [[BFSkinManager sharedInstance] changeToSkinWithStyleId:@"Dark"];
    } else {
        [[BFSkinManager sharedInstance] changeToSkinWithStyleId:@"Default"];
    }
}

#pragma  mark Layout
- (void)layoutSubview  {
    [self addSubview:self.headBackImageView];
    {
        [self.headBackImageView bf_pinEdge:BFAEdgeLeft toEdge:BFAEdgeLeft ofView:self];
        [self.headBackImageView bf_pinEdge:BFAEdgeTop toEdge:BFAEdgeTop ofView:self];
        [self.headBackImageView bf_setDimensionsToSize:CGSizeMake(SCREEN_WIDTH, ADAPT_H(240))];
    }
    [self.headBackImageView addSubview:self.titleLabel];
    {
        [self.titleLabel bf_alignAxisToSuperviewAxis:BFAAxisVertical];
        [self.titleLabel bf_pinEdge:BFAEdgeTop toEdge:BFAEdgeTop ofView:self withOffset:32];
    }
    [self.headBackImageView addSubview:self.messageImageView];
    {
        [self.messageImageView bf_pinEdge:BFAEdgeRight toEdge:BFAEdgeRight ofView:self withOffset:-5];
        [self.messageImageView bf_alignAxis:BFAAxisHorizontal toSameAxisOfView:self.titleLabel withOffset:-2];
        [self.messageImageView bf_setDimensionsToSize:CGSizeMake(28, 28)];
    }
    [self.headBackImageView addSubview:self.availableTitleLabel];
    {
        [self.availableTitleLabel bf_alignAxisToSuperviewAxis:BFAAxisVertical];
        [self.availableTitleLabel bf_pinEdge:BFAEdgeTop toEdge:BFAEdgeTop ofView:self withOffset:ADAPT_H(90)];
    }
    [self.headBackImageView addSubview:self.hideBtn];
    {
        [self.hideBtn bf_pinEdge:BFAEdgeLeft toEdge:BFAEdgeRight ofView:self.availableTitleLabel];
        [self.hideBtn bf_setDimensionsToSize:CGSizeMake(40,40)];
        [self.hideBtn bf_alignAxis:BFAAxisHorizontal toSameAxisOfView:self.availableTitleLabel];
    }
    [self.headBackImageView addSubview:self.middleBtn];
    {
        [self.middleBtn bf_pinEdge:BFAEdgeTop toEdge:BFAEdgeBottom ofView:self.availableTitleLabel withOffset:ADAPT_H(18)];
        [self.middleBtn bf_alignAxisToSuperviewAxis:BFAAxisVertical];
        [self.middleBtn bf_setDimensionsToSize:CGSizeMake(114, ADAPT_H(30))];
    }
    [self.headBackImageView addSubview:self.availableCreditLabel];
    {
        [self.availableCreditLabel bf_pinEdge:BFAEdgeTop toEdge:BFAEdgeBottom ofView:self.availableTitleLabel withOffset:ADAPT_H(16)];
        [self.availableCreditLabel bf_alignAxisToSuperviewAxis:BFAAxisVertical];
    }
    [self.headBackImageView addSubview:self.totalCreditLabel];
    {
        [self.totalCreditLabel bf_pinEdge:BFAEdgeTop toEdge:BFAEdgeBottom ofView:self.availableTitleLabel withOffset:ADAPT_H(72)];
        [self.totalCreditLabel bf_alignAxisToSuperviewAxis:BFAAxisVertical];
    }
    [self.headBackImageView addSubview:self.bottomBtn];
    {
        [self.bottomBtn bf_pinEdge:BFAEdgeTop toEdge:BFAEdgeBottom ofView:self.availableCreditLabel withOffset:ADAPT_H(17)];
        [self.bottomBtn bf_alignAxisToSuperviewAxis:BFAAxisVertical];
        [self.bottomBtn bf_setDimensionsToSize:CGSizeMake(114, ADAPT_H(30))];
    }
}
#pragma mark Lazy
- (UIImageView *)headBackImageView {
    if(!_headBackImageView){
        _headBackImageView = [[UIImageView alloc]init];
        _headBackImageView.image = [UIImage imageNamed:@"bg_header"];
        _headBackImageView.userInteractionEnabled = YES;
        _headBackImageView.bf_skinStyle = @"skin_home_head_image";
    }
    return _headBackImageView;
}

- (BFLabel *)titleLabel {
    if(!_titleLabel){
        _titleLabel = [[BFLabel alloc]init];
        _titleLabel.text = @"小黑鱼";
        _titleLabel.textColor = UIColorWhite;
        _titleLabel.font = FONT(17);
        _titleLabel.bf_skinStyle = @"skin_home_navigation_title";
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (UIImageView *)messageImageView {
    if(!_messageImageView){
        _messageImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_bell0"]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(messageImageViewClick)];
        _messageImageView.userInteractionEnabled = YES;
        [_messageImageView addGestureRecognizer:tap];
    }
    return _messageImageView;
}

- (BFButton *)hideBtn {
    if(!_hideBtn){
        _hideBtn = [[BFButton alloc]init];
        [_hideBtn setImage:[UIImage imageNamed:@"icon_eye_o"] forState:UIControlStateNormal];
        [_hideBtn setImage:[UIImage imageNamed:@"icon_eye_c"] forState:UIControlStateSelected];
        [_hideBtn addTarget:self action:@selector(hidenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hideBtn;
}

- (BFButton *)middleBtn {
    if(!_middleBtn){
        _middleBtn = [[BFButton alloc]init];
        [_middleBtn setTitleColor:UIColorWhite forState:UIControlStateNormal];
        [_middleBtn setTitle:@"立即开卡" forState:UIControlStateNormal];
        _middleBtn.layer.cornerRadius = ADAPT_H(15);
        _middleBtn.layer.borderColor = UIColorWhite.CGColor;
        _middleBtn.layer.borderWidth = 1;
        [_middleBtn setBackgroundColor:CLEARCOLOR];
        [_middleBtn addTarget:self action:@selector(MiddleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _middleBtn;
}

- (BFLabel *)availableTitleLabel {
    if(!_availableTitleLabel){
        _availableTitleLabel = [[BFLabel alloc]init];
        _availableTitleLabel.font = FONT(ADAPT_H(12));
        _availableTitleLabel.textColor = RGBACOLOR(255, 255, 255, 0.6);
        [_availableTitleLabel sizeToFit];
        _availableTitleLabel.bf_skinStyle = @"skin_home_available_title";
    }
    return _availableTitleLabel;
}

- (BFLabel *)availableCreditLabel {
    if(!_availableCreditLabel){
        _availableCreditLabel = [[BFLabel alloc]init];
        _availableCreditLabel.textColor = UIColorWhite;
        [_availableCreditLabel sizeToFit];
        _availableCreditLabel.bf_skinStyle = @"skin_home_available_credit_title";
    }
    return _availableCreditLabel;
}

- (BFLabel *)totalCreditLabel {
    if(!_totalCreditLabel){
        _totalCreditLabel = [[BFLabel alloc]init];
        _totalCreditLabel.font = FONT(ADAPT_H(14));
        _totalCreditLabel.textColor = RGBACOLOR(255, 255, 255, 0.6);
        [_totalCreditLabel sizeToFit];
    }
    return _totalCreditLabel;
}

- (BFButton *)bottomBtn {
    if(!_bottomBtn){
        _bottomBtn = [[BFButton alloc]init];
        [_bottomBtn setTitleColor:UIColorWhite forState:UIControlStateNormal];
        [_bottomBtn setTitle:@"立即登录" forState:UIControlStateNormal];
        _bottomBtn.layer.cornerRadius = ADAPT_H(15);
        _bottomBtn.layer.borderColor = UIColorWhite.CGColor;
        _bottomBtn.layer.borderWidth = 1;
        [_bottomBtn setBackgroundColor:CLEARCOLOR];
        [_bottomBtn addTarget:self action:@selector(tapClick) forControlEvents:UIControlEventTouchUpInside];
        _bottomBtn.bf_skinStyle = @"skin_home_login_button";
    }
    return _bottomBtn;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
