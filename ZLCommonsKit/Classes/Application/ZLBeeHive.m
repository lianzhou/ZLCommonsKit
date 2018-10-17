//
//  ZLBeeHive.m
//  Pods
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/8/22.
//
//


#import "ZLBeeHive.h"

@interface ZLBeeHive ()

@end

@implementation ZLBeeHive


- (void)setConfig:(ZLAppConfig *)config{
    _config = config;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self loadStaticServices];
    });

}

-(void)loadStaticServices
{
    
}

@end
