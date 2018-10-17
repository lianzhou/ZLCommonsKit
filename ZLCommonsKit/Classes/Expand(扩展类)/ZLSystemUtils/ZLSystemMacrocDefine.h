//
//  ZLSystemMacrocDefine.h
//  ZLCommonsKit
//
//  Created by zhoulian on 17/6/9.
//

#ifndef ZLSystemMacrocDefine_h
#define ZLSystemMacrocDefine_h

#import "ZLSystemUtils.h"               /* 系统相关 */
#import "ZLFilePath.h"                  /* 文件操作相关 */

#define WEAKSELF  __weak typeof(self) weakSelf = self;

// 十六进制颜色代码
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed : ((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green : ((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue : ((float)(rgbValue & 0xFF)) / 255.0 alpha : 1.0]

#define UIColorRGB(r, g, b) [ZLSystemUtils colorFromRed:(r) green:(g) blue:(b)] //RGB颜色
#define UIColorRGBA(r, g, b, a) [ZLSystemUtils colorFromRed:(r) green:(g) blue:(b) withAlpha:(a)]   //RGB颜色+透明
#define UIColorFromHex(rgbValue) [ZLSystemUtils colorFromHexString:((__bridge NSString *)CFSTR(#rgbValue))]
#define UIColorRandomColor [ZLSystemUtils randomColor]

#define SCREEN_SCALE   [ZLSystemUtils deviceScreenScale]
#define SCREEN_SIZE    [ZLSystemUtils deviceScreenSize]
#define SCREEN_WIDTH   [ZLSystemUtils deviceScreenSize].width
#define SCREEN_HEIGHT  [ZLSystemUtils deviceScreenSize].height

#define ZLCheckObjectNull(object) [ZLSystemUtils isNullObject:object]    //检查对象是否为空
#define ZLCheckKeyValueHasNull(keyObj,valueObj) [ZLSystemUtils checkValue:valueObj key:keyObj]  //检查一个valueObj,keyObj对象是否有一个是空的

#define ZLCheckArrayNull(object)    [ZLSystemUtils arrayIsNull:object]  //检查数组是否是空的

#define ZLSystemiPhone6Plus [ZLSystemUtils iPhone6PlusDevice]

#define ZLSystemiPhone6 [ZLSystemUtils iPhone6Device]

#define ZLSystemiPhone5 [ZLSystemUtils iPhone5Device]

#define ZLSystemiPhone4 [ZLSystemUtils iPhone4Device]

#define ZL_IOS7  ([ZLSystemUtils iPhoneDeviceVersion:7.0])
#define ZL_IOS8  ([ZLSystemUtils iPhoneDeviceVersion:8.0])
#define ZL_IOS9  ([ZLSystemUtils iPhoneDeviceVersion:9.0])
#define ZL_IOS10 ([ZLSystemUtils iPhoneDeviceVersion:10.0])
#define ZL_IOS11 ([ZLSystemUtils iPhoneDeviceVersion:11.0])

//设备
#define ZL_IPHONE_4 [UIScreen mainScreen].bounds.size.height == 480
#define ZL_IPHONE_5 [UIScreen mainScreen].bounds.size.height == 568
#define ZL_IPHONE_6 [UIScreen mainScreen].bounds.size.height == 667
#define ZL_IPHONE_6p [UIScreen mainScreen].bounds.size.height == 736
#define ZL_IPHONE_X [UIScreen mainScreen].bounds.size.height == 812

#define ZL_KMainColor [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:249.0/255.0 alpha:1]   //主颜色

//单例对象申明.h
#define ZL_SHARED_INSTANCE_DECLARE(className)  +(className *)shareInstance;

//单例对象申明.m
#define ZL_SHARED_INSTANCE_DEFINE(className) \
+ (className *)shareInstance { \
static className *_ ## className = nil; \
if (!_ ## className) { \
_ ## className = [[className alloc] init]; \
} \
return _ ## className; \
}

//-------------------打印日志-------------------------

//DEBUG  模式下打印日志,当前行
#ifdef DEBUG
#define LRString [NSString stringWithFormat:@"%s", __FILE__].lastPathComponent
#define ZLLog(...) printf("%f %s 第%d行: %s\n\n", [[NSDate date]timeIntervalSince1970],[LRString UTF8String] ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);
#else
#define ZLLog(...)//发布状态关闭Log功能
#endif 

#pragma mark - 消除黄色警告⚠️

//找不到函数的黄色警告
#define ZLPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

//方法可能弃用的警告
#define ZLDeprecatedSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


#endif /* ZLSystemMacrocDefine_h */
