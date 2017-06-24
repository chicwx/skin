//
//  BFHomeService.m
//  Pods
//
//  Created by LXY on 2017/5/2.
//
//

#import "BFHomeService.h"
#import "BFCarouselModel.h"
NSString *const kBFHomeLayoutPath = @"/tnp/app/homepage/layout";//首页布局接口

@implementation BFHomeService

//+ (void)fetchHomePageLayoutWithCompleteBlock:(BFSeverRespondBlock)block {
//    NSMutableDictionary *bizParam = [[NSMutableDictionary alloc] init];
//    [bizParam setObject:@(22) forKey:@"layoutId"];
//    NSString *urlParam = [BFBaseParamsManager constructBase64ReqParamStingWithBizParam:bizParam];
//    NSString *str = [NSString stringWithFormat:@"%@?%@", kBFHomeLayoutPath,urlParam];
//    BFHTTPQuery *query = [BFHTTPQuery queryWithMethod:BFHTTPGET path:str parameters:nil];
//    query.url = [BFServerConfig Host];
//    [[BFHTTPServiceManager sharedInstance] objectBaseRequestWithQuery:query modelClass:[BFHomeLayout class] completeBlock:block];
//}

@end
