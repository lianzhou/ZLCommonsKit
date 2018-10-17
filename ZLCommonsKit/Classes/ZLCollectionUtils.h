//
//  ZLCollectionUtils.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYKit.h>

UIKIT_EXTERN NSString *const ZL_API_IMG_IP;  // 图片

UIKIT_EXTERN NSString *const UploadFile_BaseURL;//上传文件接口

UIKIT_EXTERN NSString *const ZL_XKP_CARD_BASE_URL; //新开普


/* API 接口 */
typedef NS_ENUM(NSUInteger, ZLNetEnvironmentType) {
    ZLNetEnvironmentTypeFormal          = 0,   //正式环境
    ZLNetEnvironmentTypeTest            = 1,   //测试环境
    ZLNetEnvironmentTypeLocal           = 2,   //本地环境
    ZLNetEnvironmentTypePress           = 3,   //压测环境
    ZLNetEnvironmentTypeIntegrationTest = 4,//集成测试环境
    ZLNetEnvironmentTypeEND,   //结束
};


@interface ZLCollectionUtils : NSObject



@end

/*!
 *  @brief 内联函数
 */
#pragma mark - 屏幕适配

static inline CGFloat ZLLayoutWidth(CGFloat width)
{
    return (width*kScreenWidth/375.0f);
}

static inline CGFloat ZLLayoutHeight(CGFloat height)
{
    return (height*kScreenHeight/667.0f);
}

static inline CGFloat ZLLayoutAspectRatio(CGFloat layout,CGFloat aspectRatio)
{
    return (layout*aspectRatio);
}

