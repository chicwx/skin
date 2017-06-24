//
//  BFHomeViewController.m
//  Pods
//
//  Created by LXY on 2017/4/27.
//
//

#import "BFHomeViewController.h"
#import "BFToolCell.h"
#import "BFHeaderCell.h"
#import "BFCarouselCell.h"
#import "BFMenuCell.h"
#import "BFCarouselModel.h"
#import "BFHomeService.h"
#import "BFHomeViewController.h"

@interface BFHomeViewController () <HomeToolDelegate, HomeMenuDelegate, HomeHeaderDelegate>
@property (nonatomic, strong) NSMutableArray <BFCarouselModel*> *carouselList;//轮播图数组
@property (nonatomic, strong) BFAccountInfo *creditInfo;//额度信息
@property (nonatomic, assign) NSInteger hasUnReadMsg;//是否有未读消息
@property (nonatomic, strong) NSMutableArray <BFHomeTabIcon *> *tabIconArray; //首页tabIcon
@property (nonatomic, assign) BOOL isFetchData;
@property (nonatomic, strong) UIImageView *headerBgImgView;

@end

@implementation BFHomeViewController

#pragma mark - Const 【静态数据初始化】
static NSString *kHomeHeaderCell = @"kHomeHeaderCell";
static NSString *kBFToolCell = @"kBFToolCell";
static NSString *kBFCarouselCell = @"kBFCarouselCell";
static NSString *kBFMenuCell = @"kBFMenuCell";
static NSString *kDefaultIdentifer = @"kDefaultIdentifer";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBCOLOR(242,243,248);
    
    [self prepareView];

}

#pragma mark - Private Method
- (void)viewWillAppear:(BOOL)animated{
    //设置导航栏透明
    QMUICMI.statusbarStyleLightInitially = YES;
    //状态栏设置
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];

    [self.bf_TableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    //设置导航栏透明
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    QMUICMI.statusbarStyleLightInitially = NO;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark - Custom Method


#pragma mark - Delegate And DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        return ADAPT_H(240);
    } else if (indexPath.section == 1) {
        return ADAPT_H(100);
    } else if (indexPath.section == 2) {
        return 0;
    } else if (indexPath.section == 3) {
        return ADAPT_H(80);
    } else {
        return ADAPT_H(155);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  (section == 0)?0:ADAPT_H(10);
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ADAPT_H(10))];
    headView.backgroundColor = RGBCOLOR(239, 239, 244);
    return headView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0){
        BFHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:kHomeHeaderCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = (id<HomeHeaderDelegate>)self;
        cell.HideBtn.hidden = YES;
        cell.MiddleBtn.hidden = YES;
        cell.TotalCreditLabel.hidden = YES;
        cell.bottomBtn.hidden = NO;
        cell.availableCreditLabel.hidden = NO;
        cell.availableTitleLabel.text = @"可用消费额度(元)";
        cell.availableCreditLabel.text = [NSString stringWithFormat:@"最高可获得%@元", [NSString isNilOrEmpty:self.creditInfo.totalCreditLimit] ? @"10万":self.creditInfo.totalCreditLimit];
        cell.availableCreditLabel.font = FONT(ADAPT_H(26));
        
        return cell;
    } else if (indexPath.section == 1) {
        BFToolCell *cell = [tableView dequeueReusableCellWithIdentifier:kBFToolCell];
        [cell bindModelWithArray:self.tabIconArray];
        cell.delegate = (id<HomeToolDelegate>)self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDefaultIdentifer];
        cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_middle"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 3) {
        BFCarouselCell *cell = [tableView dequeueReusableCellWithIdentifier:kBFCarouselCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell initCellWithDtoArray:self.carouselList];
        return cell;
        
    } else if (indexPath.section == 4) {
        BFMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:kBFMenuCell];
        cell.delegate = (id<HomeMenuDelegate>)self;
        //更新账单
        [cell updateAmount:self.creditInfo.totalAmount];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    // 默认
    UITableViewCell *defaultCell = [tableView dequeueReusableCellWithIdentifier:kDefaultIdentifer];
    return defaultCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}

#pragma mark - HomeHeaderDelegate
- (void)messageButtonClick {
    self.hasUnReadMsg = 0;
    [[BFAnalysisManager sharedManager] logEvent:@"Message" eventLabel:@"消息"];
}

#pragma mark - HomeToolDelegate
- (void)ToolSelect:(BFToolCell *)ToolView selectIndex:(NSInteger)selectIndex {
    NSArray *eventArray = @[@"扫一扫", @"银行卡", @"优惠券", @"消费记录"];
    NSArray *idArray = @[@"Scanning", @"BankCard", @"Coupon", @"RecordsConsumption"];
    [[BFAnalysisManager sharedManager] logEvent:[idArray safeObjectAtIndex:selectIndex] eventLabel:[eventArray safeObjectAtIndex:selectIndex]];
}

#pragma mark - HomeMenuDelegate
- (void)MenuSelect:(BFMenuCell *)MenuView selectIndex:(NSInteger)selectIndex {
    NSArray *eventArray = @[@"全部账单", @"分期记录", @"意见反馈", @"帮助中心"];
    NSArray *idArray = @[@"AllBills", @"StagingRecord", @"Feedback", @"FAQ"];
    [[BFAnalysisManager sharedManager] logEvent:[idArray safeObjectAtIndex:selectIndex] eventLabel:[eventArray safeObjectAtIndex:selectIndex]];
    
}

#pragma mark Layout
- (void)prepareView{
    [self.view addSubview:self.bf_TableView];
    {
        [self.bf_TableView bf_pinEdge:BFAEdgeTop toEdge:BFAEdgeTop ofView:self.view];
        [self.bf_TableView bf_alignAxisToSuperviewAxis:BFAAxisVertical];
        [self.bf_TableView bf_setDimensionsToSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 50)];
    }

    self.bf_TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.bf_TableView.backgroundColor = UIColorClear;
    
    [self.bf_TableView registerClass:[BFHeaderCell class] forCellReuseIdentifier:kHomeHeaderCell];
    [self.bf_TableView registerClass:[BFToolCell class] forCellReuseIdentifier:kBFToolCell];
    [self.bf_TableView registerClass:[BFCarouselCell class] forCellReuseIdentifier:kBFCarouselCell];
    [self.bf_TableView registerClass:[BFMenuCell class] forCellReuseIdentifier:kBFMenuCell];
    [self.bf_TableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kDefaultIdentifer];
    // 去线
    self.bf_TableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ADAPT_H(10))];
    
    [self.bf_TableView insertSubview:self.headerBgImgView atIndex:0];
    [self.headerBgImgView bf_alignAxisToSuperviewAxis:BFAAxisVertical];
    [self.headerBgImgView bf_pinEdgeToSuperviewEdge:BFAEdgeTop withInset:-SCREEN_HEIGHT];
    [self.headerBgImgView bf_setDimensionsToSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIImageView *)headerBgImgView {
    if (!_headerBgImgView) {
        _headerBgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_header_back"]];
    }
    return _headerBgImgView;
}

#pragma mark - Public
- (NSString *)currentPageName {
    return @"首页";
}

@end
