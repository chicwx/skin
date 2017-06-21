//
//  ViewController.m
//  BFSkinDemo
//
//  Created by wangxiao on 2017/6/19.
//  Copyright © 2017年 tuniu. All rights reserved.
//

#import "ViewController.h"
#import "PureLayout.h"
#import "UIView+Skin.h"
#import "BFSkinManager.h"


@interface ViewController ()

@property (nonatomic, strong) UIButton *darkButton;
@property (nonatomic, strong) UIButton *defaultButton;
@property (nonatomic, strong) UIImageView *bottomImageView;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self prepareView];
    
    [self performanceTest];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI
- (void)prepareView {
    [self.view addSubview:self.darkButton];
    [self.view addSubview:self.defaultButton];
    [self.view addSubview:self.bottomImageView];
    
    [self.darkButton autoSetDimensionsToSize:CGSizeMake(100, 50)];
    [self.darkButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.darkButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:100.f];
    
    [self.defaultButton autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.darkButton];
    [self.defaultButton autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.darkButton];
    [self.defaultButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.defaultButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.darkButton withOffset:40.f];
    
    [self.bottomImageView autoSetDimensionsToSize:CGSizeMake(200, 50)];
    [self.bottomImageView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [self.bottomImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
}

- (void)performanceTest {
    for (int i = 0; i < 100; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i, 300+i, 100, 50)];
        [button setTitle:[NSString stringWithFormat:@"B%@",@(i)] forState:UIControlStateNormal];
        button.bf_skinStyle = @"skin_submit_button";
        [self.view addSubview:button];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 350+2*i, 100, 30)];
        imageView.bf_skinStyle = @"skin_index_bottom_image";
        [self.view addSubview:imageView];
    }
}

#pragma mark - Action
- (void)darkClick:(UIButton *)sender {
    [[BFSkinManager sharedInstance] changeToSkinWithStyleId:@"Dark"];
}

- (void)defaultClick:(UIButton *)sender {
    [[BFSkinManager sharedInstance] changeToSkinWithStyleId:@"Default"];
}

#pragma mark - Lazy init
- (UIButton *)darkButton {
    if (!_darkButton) {
        _darkButton = [UIButton new];
        [_darkButton setTitle:@"Dark" forState:UIControlStateNormal];
        [_darkButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_darkButton addTarget:self action:@selector(darkClick:) forControlEvents:UIControlEventTouchUpInside];
        _darkButton.bf_skinStyle = @"skin_tab_button";
    }
    return _darkButton;
}

- (UIButton *)defaultButton {
    if (!_defaultButton) {
        _defaultButton = [UIButton new];
        [_defaultButton setTitle:@"Default" forState:UIControlStateNormal];
        [_defaultButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        _defaultButton.bf_skinStyle = @"skin_submit_button";
        [_defaultButton addTarget:self action:@selector(defaultClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _defaultButton;
}

- (UIImageView *)bottomImageView {
    if (!_bottomImageView) {
        _bottomImageView = [UIImageView new];
        _bottomImageView.backgroundColor = [UIColor grayColor];
        _bottomImageView.bf_skinStyle = @"skin_index_bottom_image";
    }
    return _bottomImageView;
}

@end
