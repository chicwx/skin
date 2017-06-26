//
//  BFCarouselCell.m
//  Pods
//
//  Created by LXY on 2017/4/27.
//
//

#import "BFCarouselCell.h"
#import "BFCarouselView.h"
@interface BFCarouselCell()

@property (nonatomic, strong) BFCarouselView *boardCarouselView;


@end
@implementation BFCarouselCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)initCellWithDtoArray:(NSArray *)dtoArray {
    
    if (IS_ARRAY_EMPTY(dtoArray)) {
        return;
    }
    [self.boardCarouselView reloadCarouselView:dtoArray];
}


- (BFCarouselView *)boardCarouselView {
    if (!_boardCarouselView) {
        _boardCarouselView = [[BFCarouselView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ADAPT_H(80)) images:nil];
        _boardCarouselView.carouselAutoScroll = YES;
        [self.contentView addSubview:_boardCarouselView];
    }
    return _boardCarouselView;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
