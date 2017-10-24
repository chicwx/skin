//
//  BFMenuView.m
//  Pods
//
//  Created by LXY on 2017/4/28.
//
//

#import "BFMenuView.h"

@implementation BFMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutSubView];
    }
    return  self;
}

- (void)layoutSubView {
    [self addSubview:self.titleImage];
    {
        [self.titleImage bf_alignAxisToSuperviewAxis:BFAAxisHorizontal];
        [self.titleImage bf_pinEdge:BFAEdgeLeft toEdge:BFAEdgeLeft ofView:self withOffset:ADAPT_W(26.8)];
        [self.titleImage bf_setDimensionsToSize:CGSizeMake(ADAPT_W(23.5), ADAPT_H(22.5))];
        
    }
    [self addSubview:self.titleLabel];
    {
        [self.titleLabel bf_pinEdgeToSuperviewEdge:BFAEdgeRight];
        [self.titleLabel bf_pinEdge:BFAEdgeLeft toEdge:BFAEdgeRight ofView:self.titleImage withOffset:ADAPT_W(15)];
        [self.titleLabel bf_pinEdge:BFAEdgeTop toEdge:BFAEdgeTop ofView:self withOffset:ADAPT_H(19)];
    }
    [self addSubview:self.detalLabel];
    {
        [self.detalLabel bf_pinEdgeToSuperviewEdge:BFAEdgeRight];
        [self.detalLabel bf_pinEdge:BFAEdgeLeft toEdge:BFAEdgeLeft ofView:self.titleLabel];
        [self.detalLabel bf_pinEdge:BFAEdgeBottom toEdge:BFAEdgeBottom ofView:self withOffset:-ADAPT_H(20)];
    }
}

- (UIImageView *)titleImage {
    if(!_titleImage){
        _titleImage = [[UIImageView alloc]init];
    }
    return _titleImage;
}

- (BFLabel *)titleLabel {
    if(!_titleLabel){
        _titleLabel = [[BFLabel alloc]init];
        _titleLabel.font = FONT(ADAPT_H(14));
        _titleLabel.textColor = RGBCOLOR(34, 34, 34);
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (BFLabel *)detalLabel {
    if(!_detalLabel){
        _detalLabel = [[BFLabel alloc]init];
        _detalLabel.font = FONT(ADAPT_H(12));
        _detalLabel.textColor = RGBCOLOR(165, 165, 165);
        [_detalLabel sizeToFit];
    }
    return _detalLabel;
}
@end
