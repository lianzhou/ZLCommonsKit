//
//  JZSystemMacrocDefine.h
//  eStudy
//
//  Created by zhoulian on 17/6/9.
//

#ifndef JZSystemMacrocDefine_h
#define JZSystemMacrocDefine_h

#import "JZSystemUtils.h"               /* 系统相关 */
#import "JZFilePath.h"                  /* 文件操作相关 */

#define WEAKSELF  __weak typeof(self) weakSelf = self;

// 十六进制颜色代码
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed : ((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green : ((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue : ((float)(rgbValue & 0xFF)) / 255.0 alpha : 1.0]

#define UIColorRGB(r, g, b) [JZSystemUtils colorFromRed:(r) green:(g) blue:(b)] //RGB颜色
#define UIColorRGBA(r, g, b, a) [JZSystemUtils colorFromRed:(r) green:(g) blue:(b) withAlpha:(a)]   //RGB颜色+透明
#define UIColorFromHex(rgbValue) [JZSystemUtils colorFromHexString:((__bridge NSString *)CFSTR(#rgbValue))]
#define UIColorRandomColor [JZSystemUtils randomColor]

#define SCREEN_SCALE   [JZSystemUtils deviceScreenScale]
#define SCREEN_SIZE    [JZSystemUtils deviceScreenSize]
#define SCREEN_WIDTH   [JZSystemUtils deviceScreenSize].width
#define SCREEN_HEIGHT  [JZSystemUtils deviceScreenSize].height

#define JZCheckObjectNull(object) [JZSystemUtils isNullObject:object]    //检查对象是否为空
#define JZCheckKeyValueHasNull(keyObj,valueObj) [JZSystemUtils checkValue:valueObj key:keyObj]  //检查一个valueObj,keyObj对象是否有一个是空的

#define JZCheckArrayNull(object)    [JZSystemUtils arrayIsNull:object]  //检查数组是否是空的

#define JZSystemiPhone6Plus [JZSystemUtils iPhone6PlusDevice]

#define JZSystemiPhone6 [JZSystemUtils iPhone6Device]

#define JZSystemiPhone5 [JZSystemUtils iPhone5Device]

#define JZSystemiPhone4 [JZSystemUtils iPhone4Device]

#define JZ_IOS7  ([JZSystemUtils iPhoneDeviceVersion:7.0])
#define JZ_IOS8  ([JZSystemUtils iPhoneDeviceVersion:8.0])
#define JZ_IOS9  ([JZSystemUtils iPhoneDeviceVersion:9.0])
#define JZ_IOS10 ([JZSystemUtils iPhoneDeviceVersion:10.0])
#define JZ_IOS11 ([JZSystemUtils iPhoneDeviceVersion:11.0])

//设备
#define JZ_IPHONE_4 [UIScreen mainScreen].bounds.size.height == 480
#define JZ_IPHONE_5 [UIScreen mainScreen].bounds.size.height == 568
#define JZ_IPHONE_6 [UIScreen mainScreen].bounds.size.height == 667
#define JZ_IPHONE_6p [UIScreen mainScreen].bounds.size.height == 736
#define JZ_IPHONE_X [UIScreen mainScreen].bounds.size.height == 812

#define JZ_KMainColor [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:249.0/255.0 alpha:1]   //主颜色

//单例对象申明.h
#define JZ_SHARED_INSTANCE_DECLARE(className)  +(className *)shareInstance;

//单例对象申明.m
#define JZ_SHARED_INSTANCE_DEFINE(className) \
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
#define JZLog(...) printf("%f %s 第%d行: %s\n\n", [[NSDate date]timeIntervalSince1970],[LRString UTF8String] ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);
#else
#define JZLog(...)//发布状态关闭Log功能
#endif 

#pragma mark - 消除黄色警告⚠️

//找不到函数的黄色警告
#define JZPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

//方法可能弃用的警告
#define JZDeprecatedSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


#endif /* JZSystemMacrocDefine_h */
