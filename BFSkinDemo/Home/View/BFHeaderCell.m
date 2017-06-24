//
//  BFHeaderCell.m
//  Pods
//
//  Created by LXY on 2017/5/3.
//
//

#import "BFHeaderCell.h"

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
        self.TitleText = self.availableTitleLabel.text;
        self.CreditText = self.availableCreditLabel.text;
        self.TotalCreditText = self.TotalCreditLabel.text;
        self.availableTitleLabel.text = @"可用消费信用额度(元)";
        self.availableCreditLabel.text = @"恭喜发财";
        self.TotalCreditLabel.text = @"总消费额度******      本月账单******";
    } else {
        self.availableTitleLabel.text = self.TitleText;
        self.availableCreditLabel.text = self.CreditText;
        self.TotalCreditLabel.text = self.TotalCreditText;
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

- (void)TapClick{
    //去登录
}

#pragma  mark Layout
- (void)layoutSubview  {
    [self addSubview:self.headBackImageView];
    {
        [self.headBackImageView bf_pinEdge:BFAEdgeLeft toEdge:BFAEdgeLeft ofView:self];
        [self.headBackImageView bf_pinEdge:BFAEdgeTop toEdge:BFAEdgeTop ofView:self];
        [self.headBackImageView bf_setDimensionsToSize:CGSizeMake(SCREEN_WIDTH, ADAPT_H(240))];
    }
    [self.headBackImageView addSubview:self.TitleLabel];
    {
        [self.TitleLabel bf_alignAxisToSuperviewAxis:BFAAxisVertical];
        [self.TitleLabel bf_pinEdge:BFAEdgeTop toEdge:BFAEdgeTop ofView:self withOffset:32];
    }
    [self.headBackImageView addSubview:self.messageImageView];
    {
        [self.messageImageView bf_pinEdge:BFAEdgeRight toEdge:BFAEdgeRight ofView:self withOffset:-5];
        [self.messageImageView bf_alignAxis:BFAAxisHorizontal toSameAxisOfView:self.TitleLabel withOffset:-2];
        [self.messageImageView bf_setDimensionsToSize:CGSizeMake(28, 28)];
    }
    [self.headBackImageView addSubview:self.availableTitleLabel];
    {
        [self.availableTitleLabel bf_alignAxisToSuperviewAxis:BFAAxisVertical];
        [self.availableTitleLabel bf_pinEdge:BFAEdgeTop toEdge:BFAEdgeTop ofView:self withOffset:ADAPT_H(90)];
    }
    [self.headBackImageView addSubview:self.HideBtn];
    {
        [self.HideBtn bf_pinEdge:BFAEdgeLeft toEdge:BFAEdgeRight ofView:self.availableTitleLabel];
        [self.HideBtn bf_setDimensionsToSize:CGSizeMake(40,40)];
        [self.HideBtn bf_alignAxis:BFAAxisHorizontal toSameAxisOfView:self.availableTitleLabel];
    }
    [self.headBackImageView addSubview:self.MiddleBtn];
    {
        [self.MiddleBtn bf_pinEdge:BFAEdgeTop toEdge:BFAEdgeBottom ofView:self.availableTitleLabel withOffset:ADAPT_H(18)];
        [self.MiddleBtn bf_alignAxisToSuperviewAxis:BFAAxisVertical];
        [self.MiddleBtn bf_setDimensionsToSize:CGSizeMake(114, ADAPT_H(30))];
    }
    [self.headBackImageView addSubview:self.availableCreditLabel];
    {
        [self.availableCreditLabel bf_pinEdge:BFAEdgeTop toEdge:BFAEdgeBottom ofView:self.availableTitleLabel withOffset:ADAPT_H(16)];
        [self.availableCreditLabel bf_alignAxisToSuperviewAxis:BFAAxisVertical];
    }
    [self.headBackImageView addSubview:self.TotalCreditLabel];
    {
        [self.TotalCreditLabel bf_pinEdge:BFAEdgeTop toEdge:BFAEdgeBottom ofView:self.availableTitleLabel withOffset:ADAPT_H(72)];
        [self.TotalCreditLabel bf_alignAxisToSuperviewAxis:BFAAxisVertical];
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
        _headBackImageView.bf_skinStyle = @"skin_index_head_image";
    }
    return _headBackImageView;
}

- (BFLabel *)TitleLabel {
    if(!_TitleLabel){
        _TitleLabel = [[BFLabel alloc]init];
        _TitleLabel.text = @"小黑鱼";
        _TitleLabel.textColor = UIColorWhite;
        _TitleLabel.font = FONT(17);
        [_TitleLabel sizeToFit];
    }
    return _TitleLabel;
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

- (BFButton *)HideBtn {
    if(!_HideBtn){
        _HideBtn = [[BFButton alloc]init];
        [_HideBtn setImage:[UIImage imageNamed:@"icon_eye_o"] forState:UIControlStateNormal];
        [_HideBtn setImage:[UIImage imageNamed:@"icon_eye_c"] forState:UIControlStateSelected];
        [_HideBtn addTarget:self action:@selector(hidenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _HideBtn;
}

- (BFButton *)MiddleBtn {
    if(!_MiddleBtn){
        _MiddleBtn = [[BFButton alloc]init];
        [_MiddleBtn setTitleColor:UIColorWhite forState:UIControlStateNormal];
        [_MiddleBtn setTitle:@"立即开卡" forState:UIControlStateNormal];
        _MiddleBtn.layer.cornerRadius = ADAPT_H(15);
        _MiddleBtn.layer.borderColor = UIColorWhite.CGColor;
        _MiddleBtn.layer.borderWidth = 1;
        [_MiddleBtn setBackgroundColor:CLEARCOLOR];
        [_MiddleBtn addTarget:self action:@selector(MiddleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _MiddleBtn;
}

- (BFLabel *)availableTitleLabel {
    if(!_availableTitleLabel){
        _availableTitleLabel = [[BFLabel alloc]init];
        _availableTitleLabel.font = FONT(ADAPT_H(12));
        _availableTitleLabel.textColor = RGBACOLOR(255, 255, 255, 0.6);
        [_availableTitleLabel sizeToFit];
    }
    return _availableTitleLabel;
}

- (BFLabel *)availableCreditLabel {
    if(!_availableCreditLabel){
        _availableCreditLabel = [[BFLabel alloc]init];
        _availableCreditLabel.textColor = UIColorWhite;
        [_availableCreditLabel sizeToFit];
    }
    return _availableCreditLabel;
}

- (BFLabel *)TotalCreditLabel {
    if(!_TotalCreditLabel){
        _TotalCreditLabel = [[BFLabel alloc]init];
        _TotalCreditLabel.font = FONT(ADAPT_H(14));
        _TotalCreditLabel.textColor = RGBACOLOR(255, 255, 255, 0.6);
        [_TotalCreditLabel sizeToFit];
    }
    return _TotalCreditLabel;
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
        [_bottomBtn addTarget:self action:@selector(TapClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
