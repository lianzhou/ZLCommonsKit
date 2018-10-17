//
//  ZLPicModel.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZLPicModel : NSObject

@property(nonatomic,copy)NSString *picType; //0:照片 1:视频
@property(nonatomic,strong)UIImage *image;
@property(nonatomic,copy)NSString *imageUrl;
@property(nonatomic,assign)BOOL isShowPicNum;
@property(nonatomic,assign)NSInteger picNum;
@property(nonatomic,assign)CGFloat itemWidth;
@end
