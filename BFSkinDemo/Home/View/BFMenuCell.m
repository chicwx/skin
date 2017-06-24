//
//  BFMenuCell.m
//  Pods
//
//  Created by LXY on 2017/4/27.
//
//

#import "BFMenuCell.h"
#import "BFMenuView.h"
@implementation BFMenuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layoutsubview];
    }
    return self;
}

- (void)handleMenuTap:(UITapGestureRecognizer *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(menuSelect:selectIndex:)]) {
        [_delegate menuSelect:self selectIndex:sender.view.tag - 10001];
    }
}

- (void)layoutsubview {
    [self addSubview:self.backView];
    [self.backView qmui_removeAllSubviews];
    NSArray *titleList = [NSArray arrayWithObjects:@"全部账单",@"我的分期",@"意见反馈",@"帮助提示",nil];
    NSArray *detailList = [NSArray arrayWithObjects:@"总账单：0.00",@"查看分期账单",@"发表吐槽和建议",@"热点关注问题",nil];
    NSArray *imageList = [NSArray arrayWithObjects:@"skin_menu_bill_icon",@"skin_menu_stage_icon",@"skin_menu_feedback_icon",@"skin_menu_help_icon", nil];
    
    for (int i = 0; i < 4; i++) {
        BFMenuView *menuView = [[BFMenuView alloc]initWithFrame:CGRectMake(0 + (i % 2) *SCREEN_WIDTH / 2, i / 2 *ADAPT_H(77),SCREEN_WIDTH / 2  , ADAPT_H(77))];
        menuView.titleLabel.text = titleList[i];
        menuView.titleLabel.bf_skinStyle = @"skin_menu_title";
        menuView.detalLabel.text = detailList[i];
        menuView.detalLabel.bf_skinStyle = @"skin_menu_subtitle";
        menuView.titleImage.bf_skinStyle = imageList[i];
        menuView.tag = 10001 + i;
        [menuView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleMenuTap:)]];
        [self.backView addSubview:menuView];
    }
    UIView *VerLine = [[UIView alloc]initWithFrame:CGRectMake(ADAPT_W(186), 0, ADAPT_W(1), ADAPT_H(155))];
    UIView *HorLine = [[UIView alloc]initWithFrame:CGRectMake(0, ADAPT_H(77),SCREEN_WIDTH, ADAPT_H(1))];
    VerLine.backgroundColor = RGBACOLOR(0, 0, 0, 0.06);
    HorLine.backgroundColor = RGBACOLOR(0, 0, 0, 0.06);
    [self.backView addSubview:VerLine];
    [self.backView addSubview:HorLine];
    
}

//更新总账单
- (void)updateAmount:(NSString *)amount {
    BFMenuView *view = (BFMenuView *)[self viewWithTag:10001];
    if (![NSString isNilOrEmpty:amount]) {
        view.detalLabel.text = [NSString stringWithFormat:@"总账单：%@", amount];
    }
}

- (UIView *)backView {
    if(!_backView){
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ADAPT_H(155))];
        _backView.backgroundColor = UIColorWhite;
    }
    return _backView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
