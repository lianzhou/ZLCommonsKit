//
//  ZLBaseDataModel.h
//  Pods
//
//  Created by zhoulian on 17/8/21.
//
//

#import "ZLBaseObject.h"

@interface ZLBaseDataModel : ZLBaseObject

//状态
@property (nonatomic, assign) NSInteger status;
//信息
@property (nonatomic, copy) NSString *errorMsg;
//服务器时间戳
@property (nonatomic, assign) long long timeStamp;

@end


@interface ZLPaginationModel : ZLBaseObject

//页码
@property (nonatomic, assign) NSInteger page;

//条数
@property (nonatomic, assign) NSInteger rows;

//总个数
@property (nonatomic, assign) NSInteger total;


@property (nonatomic, copy) NSString * sortName;
//排序顺序？？
@property (nonatomic, copy) NSString *sortOrder;



- (NSMutableDictionary *)fetchObjectParams;

- (void)addPageWithSuccess;

- (void)initializeObjectPage;
@end
