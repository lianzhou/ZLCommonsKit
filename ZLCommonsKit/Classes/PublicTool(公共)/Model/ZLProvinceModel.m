//
//  ZLProvinceModel.m
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 2017/8/16.
//


#import "ZLProvinceModel.h"

@interface ZLProvinceModel ()

@end

@implementation ZLProvinceModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
  return @{@"ID":@"id"};
}
+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"city":@"ZLCityModel"};
}

@end

@implementation ZLCityModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"ID":@"id"};
}
+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"area":@"ZLAreaModel"};
}

@end

@implementation ZLAreaModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"ID":@"id"};
}

@end
