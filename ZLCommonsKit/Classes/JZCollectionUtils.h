//
//  JZCollectionUtils.h
//  eStudy
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/5/25.
//

#import <Foundation/Foundation.h>
#import <YYKit.h>

UIKIT_EXTERN NSString *const JZ_API_IMG_IP;  // 图片

UIKIT_EXTERN NSString *const UploadFile_BaseURL;//上传文件接口

UIKIT_EXTERN NSString *const JZ_XKP_CARD_BASE_URL; //新开普


/* API 接口 */
typedef NS_ENUM(NSUInteger, JZNetEnvironmentType) {
    JZNetEnvironmentTypeFormal          = 0,   //正式环境
    JZNetEnvironmentTypeTest            = 1,   //测试环境
    JZNetEnvironmentTypeLocal           = 2,   //本地环境
    JZNetEnvironmentTypePress           = 3,   //压测环境
    JZNetEnvironmentTypeIntegrationTest = 4,//集成测试环境
    JZNetEnvironmentTypeEND,   //结束
};


@interface JZCollectionUtils : NSObject



@end

/*!
 *  @brief 内联函数
 */
#pragma mark - 屏幕适配

static inline CGFloat JZLayoutWidth(CGFloat width)
{
    return (width*kScreenWidth/375.0f);
}

static inline CGFloat JZLayoutHeight(CGFloat height)
{
    return (height*kScreenHeight/667.0f);
}

static inline CGFloat JZLayoutAspectRatio(CGFloat layout,CGFloat aspectRatio)
{
    return (layout*aspectRatio);
}

