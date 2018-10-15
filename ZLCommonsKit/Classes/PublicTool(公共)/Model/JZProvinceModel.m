//
//  JZProvinceModel.m
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 2017/8/16.
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
