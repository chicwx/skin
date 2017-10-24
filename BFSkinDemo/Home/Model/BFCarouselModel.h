//
//  BFCarouselModel.h
//  Pods
//
//  Created by LXY on 2017/5/2.
//
//

#import <BFBase/BFBase.h>
@interface BFCarouselModel : BFModel
@property (nonatomic, copy) NSString        *bannerIcon;        // 图片地址
@property (nonatomic, copy) NSString        *bannerUrl;         // 跳转链接
@end

@interface BFAccountInfo : BFModel
@property (nonatomic, copy) NSString        *totalCreditLimit;//最大总额度
@property (nonatomic, copy) NSString        *totalavailableCredit;// 可用额度
@property (nonatomic, copy) NSString        *totalAmount;// 本月账单 （应还总额）
@end

@interface BFHomeTabIcon : BFModel
@property (nonatomic, copy) NSString *tabName; // 名称
@property (nonatomic, copy) NSString *tabIcon; // 图片地址
@property (nonatomic, copy) NSString *tabUrl; //跳转页面
@property (nonatomic, assign) NSInteger loginFlag; //1.需要登录 2.不需登录
@property (nonatomic, assign) NSInteger authFlag; //1.需要认证 2.不需认证
@property (nonatomic, assign) NSInteger payPasswordFlag; //1.需要设置密码 2.不需设置密码
@end

@interface BFHomeLayout : BFModel

@property (nonatomic, strong) NSMutableArray<BFCarouselModel *>   *bannerList;
@property (nonatomic, strong) BFAccountInfo                       *myAccountSummaryInfo;
@property (nonatomic, assign) NSInteger                           hasUnreadMsg; //是否 有未读消息
@property (nonatomic, assign) NSInteger                           isLogin; //是否已登录 1.未登录 2.已登录
@property (nonatomic, strong) NSMutableArray<BFHomeTabIcon *>     *tabs; //首页tabIcon
@end
