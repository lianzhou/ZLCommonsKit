//
//  JZProvinceModel.h
//  eStudy
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by wangjingfei on 2017/8/16.
//  Copyright © 2017年 苏州橘子网络科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JZCityModel,JZAreaModel;

@interface JZProvinceModel : NSObject

@property (nonatomic, copy) NSString                         *name;

@property (nonatomic, copy) NSString                         *ID;

@property (nonatomic, strong) NSMutableArray <JZCityModel *> *city;

@end


@interface JZCityModel :NSObject

@property (nonatomic, copy) NSString                          *name;

@property (nonatomic, copy) NSString                          *ID;

@property (nonatomic, strong) NSMutableArray <JZAreaModel *>  *area;

@end

@interface JZAreaModel :NSObject

@property (nonatomic, copy) NSString                          *name;

@property (nonatomic, copy) NSString                          *ID;

@end
