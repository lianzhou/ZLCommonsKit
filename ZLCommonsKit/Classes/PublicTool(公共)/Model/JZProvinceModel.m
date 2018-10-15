//
//  JZProvinceModel.m
//  eStudy
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by wangjingfei on 2017/8/16.
//  Copyright © 2017年 苏州橘子网络科技股份有限公司. All rights reserved.
//


#import "JZProvinceModel.h"

@interface JZProvinceModel ()

@end

@implementation JZProvinceModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
  return @{@"ID":@"id"};
}
+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"city":@"JZCityModel"};
}

@end

@implementation JZCityModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"ID":@"id"};
}
+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"area":@"JZAreaModel"};
}

@end

@implementation JZAreaModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"ID":@"id"};
}

@end
