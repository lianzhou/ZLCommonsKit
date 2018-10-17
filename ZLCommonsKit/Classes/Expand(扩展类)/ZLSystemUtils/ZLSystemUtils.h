//
//  ZLSystemUtils.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/5/27.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ZLSystemUtils : NSObject
//"@xx "后面的‘ ’,是特殊字符跟空格不一样
UIKIT_EXTERN NSString *const ZL_IM_REMIND;

/*! @brief *
 *  手机型号  “iPhone 5”,“iPhone 4S”,"iPhone 4"
 */
+(NSString*)deviceString;
/*! @brief *
 *  获取ip地址 
 */
+(NSString *)getIPAddress;

/*! @brief *
 *  获取版本号
 */
+ (NSString *)obtainVersionNumber;

/*! @brief *
 *  是否有摄像头使用权限
 *
 *  @param authorized 有权限回调
 *  @param restricted 无权限回调
 */
+(void)videoAuthorizationStatusAuthorized:(void(^)(void))authorized restricted:(void(^)(void))restricted;
/*! @brief *
 *  是否有麦克风使用权限
 *
 *  @param authorized 有权限回调
 *  @param restricted 无权限回调
 */
+(void)soundAuthorizationStatusAuthorized:(void(^)(void))authorized restricted:(void(^)(void))restricted;

/*! @brief *
 *  是否有相册访问权限
 *
 *  @param authorized 有权限回调
 *  @param restricted 无权限回调
 */
+ (void)assetsAuthorizationStatusAuthorized:(void(^)(void))authorized restricted:(void(^)(void))restricted;

/*! @brief *
 *  是否有相机访问权限
 *
 *  @param authorized 有权限回调
 *  @param restricted 无权限回调
 */
+ (void)avMediaAuthorizationStatusAuthorized:(void(^)(void))authorized restricted:(void(^)(void))restricted;

/*! @brief *
 *  是否有定位访问权限
 *
 *  @param authorized 有权限回调
 *  @param restricted 无权限回调
 */
+ (void)locationAuthorizationStatusAuthorized:(void(^)(void))authorized restricted:(void(^)(void))restricted;

/*! @brief *
 *  是否有通讯录访问权限
 *
 *  @param authorized 有权限回调
 *  @param restricted 无权限回调
 */
+ (void)addressBookAuthorizationStatusAuthorized:(void(^)(void))authorized restricted:(void(^)(void))restricted;

/*! @brief *
 *  是否有网络访问权限
 *
 *  @param authorized 有权限回调
 *  @param restricted 无权限回调
 *  @param unknownNet 未知网络回调
 */
+ (void)netWorkAuthorizationStatusAuthorized:(void(^)(void))authorized restricted:(void(^)(void))restricted unknownNet:(void(^)(void))unknownNet;

/*! @brief *
 *  是否允许推送
 */
+ (BOOL)isAllowedNotification;

/*! @brief *
 *  是否应用在后台
 */
+ (BOOL)runningInBackground;

/*! @brief *
 *  是否应用在前台
 */
+(BOOL)runningInForeground;

/*! @brief *
 *  获取系统当前语言
 */
+ (NSString *)systemCurrentLanguage;


/*! @brief *
 *  获取系统useragent
 */
+ (NSString *)getUserAgent;


/*! @brief *
 *  是否越狱
 */
+ (BOOL)isJailBreak;

/*! @brief *
 *  打电话
 */
+ (BOOL)wakePhoneCallWithNumber:(NSString *)number;

/*! @brief *
 *  发短信
 */
+ (BOOL)wakeSendMessage:(NSString *)phone;

/*! @brief *
 *  打开第三方链接
 */
+ (BOOL)openThirdLibraryWithUrlString:(NSString *)urlString;

/*! @brief *
 *  打开全局系统设置
 */
+ (BOOL)openSystemSetting;

+ (NSString *)getMyDeviceAllInfo;
+ (NSString *)getDeviceVersionInfo;
+ (NSString *)getAppVersion;
/*! @brief *
 *  获取当前的显示的ViewController
 *  
 *  @return 当前的显示的ViewController
 */
+ (UIViewController *)getCurrentViewController;
+ (BOOL)iPhone4Device;
+ (BOOL)iPhone5Device;
+ (BOOL)iPhone6Device;
+ (BOOL)iPhone6PlusDevice;
+ (BOOL)iPhoneXDevice;
+ (BOOL)iPhoneDeviceVersion:(CGFloat)version;

/*! @brief *
 *  获取状态栏高度
 */
+ (CGFloat)obtainStatusHeight;
/*! @brief *
 *  获取安全高度
 */
+ (CGFloat)obtainSafeHeight;
/**
 判断系统是否为64位

 @return YES or NO
 */
+ (BOOL)is64bit;

/*! @brief *
 *  照相机是否可用
 */
+ (BOOL)cameraAvailable;
/*! @brief *
 *  App是否有权限访问照片库
 */
+ (BOOL)isAppPhotoLibraryAccessAuthorized;

+ (NSString*)currentTimeStampString;

+ (UIColor *)colorFromRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;
+ (UIColor *)colorFromRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue withAlpha:(CGFloat)alpha;
+ (UIColor *)colorFromHexString:(NSString *)hexString;
+ (UIColor *)randomColor;
+ (NSMutableArray *)changeUIColorToRGB:(UIColor *)color;



+ (CGFloat)deviceScreenScale;
+ (CGSize)deviceScreenSize;

/*! @brief *
 检查一个对象是否为空
 */
+ (BOOL)isNullObject:(id)anObject;
/*! @brief *
 *  检查一个valueObj,keyObj对象是否有一个是空的
 */
+ (BOOL)checkValue:(id)value key:(id)key;
/*! @brief *
 *  检查一个数组是否有一个是空的
 */
+ (BOOL)arrayIsNull:(NSArray *)array;

/**
 获取启动图片

 @return 启动图
 */
+ (UIImage *)getTheLaunchImage;

/**
 获取App icon

 @return icon
 */
+ (UIImage *)getTheAppIcon;


/**
 获取App name

 @return name
 */
+ (NSString *)getTheAppName;

/**
  获取当前设备可用内存(单位：MB）
 
 @return 内存
 */
+ (double)availableMemory;

/**
  获取当前任务所占用的内存（单位：MB）
 
 @return 内存
 */
+ (double)usedMemory;

@end
