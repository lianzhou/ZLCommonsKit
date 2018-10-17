//
//  ZLProvinceModel.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 2017/8/16.
//

#import <Foundation/Foundation.h>
@class ZLCityModel,ZLAreaModel;

@interface ZLProvinceModel : NSObject

@property (nonatomic, copy) NSString                         *name;

@property (nonatomic, copy) NSString                         *ID;

@property (nonatomic, strong) NSMutableArray <ZLCityModel *> *city;

@end


@interface ZLCityModel :NSObject

@property (nonatomic, copy) NSString                          *name;

@property (nonatomic, copy) NSString                          *ID;

@property (nonatomic, strong) NSMutableArray <ZLAreaModel *>  *area;

@end

@interface ZLAreaModel :NSObject

@property (nonatomic, copy) NSString                          *name;

@property (nonatomic, copy) NSString                          *ID;

@end
