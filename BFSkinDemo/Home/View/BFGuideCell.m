//
//  BFGuideCell.m
//  Pods
//
//  Created by LXY on 2017/5/12.
//
//

#import "BFGuideCell.h"
@interface BFGuideCell()

@property(nonatomic,strong) UIImageView *backImageView;
@property(nonatomic,strong) BFLabel *TipLabel;
@property(nonatomic,strong) BFLabel *detailLabel;
@property(nonatomic,strong) UIView *lineView;
@property(nonatomic,strong) BFButton *OpenBtn;

@end

@implementation BFGuideCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layoutSubview];
    }
    return self;
}

#pragma  mark Layout
- (void)layoutSubview {
    
}

#pragma  mark Lazy
- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_middle"]];
        _backImageView.userInteractionEnabled = YES;
    }
    return _backImageView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
