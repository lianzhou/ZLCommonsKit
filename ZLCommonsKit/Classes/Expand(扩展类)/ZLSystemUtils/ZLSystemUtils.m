//
//  ZLSystemUtils.m
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/5/27.
//

#import "ZLSystemUtils.h"
#include <ifaddrs.h>                 /*ip*/
#include <arpa/inet.h>               /*ip*/
#import <sys/utsname.h>              /*设备型号*/
#include <sys/sysctl.h>
#import "ZLStringMacrocDefine.h"
#import "ZLSystemMacrocDefine.h"
#import <YYKit.h>
#import <CoreTelephony/CTCellularData.h>
#import <Contacts/Contacts.h>
#import <AddressBook/AddressBook.h>
#import<sys/sysctl.h>
#import<mach/mach.h>
#import <Photos/Photos.h>

@implementation ZLSystemUtils
//"@xx "后面的‘ ’,是特殊字符跟空格不一样
NSString *const ZL_IM_REMIND = @" ";

+ (NSString *)getMyDeviceAllInfo
{
    NSMutableString *deviceAllInfo=[NSMutableString string];
    
    [deviceAllInfo appendString:@"iOS,"];
    [deviceAllInfo appendString:[[UIDevice currentDevice] systemVersion]];
    [deviceAllInfo appendString:@","];
    [deviceAllInfo appendString:[ZLSystemUtils deviceString]];
    [deviceAllInfo appendString:@","];
    [deviceAllInfo appendString:[ZLSystemUtils getAppVersion]];
    NSLog(@"设备信息%@",deviceAllInfo);
    
    return deviceAllInfo;
}
+ (NSString *) getDeviceVersionInfo
{
    size_t size;
    // get the length of machine name
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    // get machine name
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithFormat:@"%s", machine];
    free(machine);
    
    return platform;
}

+ (NSString *)obtainVersionNumber {
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    if (![[infoDic allKeys] containsObject:@"CFBundleShortVersionString"]) {
        return nil;
    }
    NSString *app_Version = [infoDic objectForKey:@"CFBundleShortVersionString"];
    return app_Version;
}

+(NSString*)deviceString
{    
    NSString *deviceString = [[UIDevice currentDevice] machineModelName];
    return  [ZLStringUitil stringIsNull:deviceString]?@"未知":deviceString;
    
}
//获取ip地址
+(NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}
/*! @brief *
 *  是否允许推送
 */
+ (BOOL)isAllowedNotification{
    if (ZL_IOS8) {
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone != setting.types) {
            return YES;
        }
    }else {//iOS7
        _Pragma("clang diagnostic push")
        _Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\"")
        
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if(UIRemoteNotificationTypeNone != type){
            return YES;
        }
        __PRAGMA_POP_NO_EXTRA_ARG_WARNINGS

    }
    return NO;
    
}

/*! @brief *
 *  是否应用在后台
 */
+ (BOOL)runningInBackground {
    
    UIApplicationState state = [UIApplication sharedApplication].applicationState;
    BOOL result = (state == UIApplicationStateBackground);
    
    return result;
}

/*! @brief *
 *  是否应用在前台
 */
+(BOOL)runningInForeground {
    
    UIApplicationState state = [UIApplication sharedApplication].applicationState;
    BOOL result = (state == UIApplicationStateActive);
    
    return result;
}

/*! @brief *
 *  获取系统当前语言
 */
+ (NSString *)systemCurrentLanguage {
    
    NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *languageName = [appLanguages objectAtIndex:0];
    return languageName;
}

/*! @brief *
 *  获取系统useragent
 */
+ (NSString *)getUserAgent {
    
    NSString *userAgent = @"";
    userAgent = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale]];
    
    return userAgent;
}

/*! @brief *
 *  是否越狱
 */
+ (BOOL)isJailBreak {
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"User/Applications/"]) {
        
        NSLog(@" 设备已越狱!");
        NSArray *appList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"User/Applications/" error:nil];
        NSLog(@"appList = %@", appList);
        return YES;
    }
    NSLog(@"设备没有越狱!");
    return NO;
}

/*! @brief *
 *  打电话
 */
+ (BOOL)wakePhoneCallWithNumber:(NSString *)number {
    
    if (ZLStringIsMobilePhone(number) || ZLStringIsPhone(number)) {
        
      return [ZLSystemUtils openSystemSettingWithUrlString:[NSString stringWithFormat:@"tel://%@",number]];
    }
    
    NSLog(@"号码不合法");
    return NO;
}

/*! @brief *
 *  发短信
 */
+ (BOOL)wakeSendMessage:(NSString *)phone {
    
    if (ZLStringIsMobilePhone(phone) || ZLStringIsPhone(phone)) {
        
       return [ZLSystemUtils openSystemSettingWithUrlString:[NSString stringWithFormat:@"sms://%@",phone]];
    }
    
    NSLog(@"号码不合法");
    return NO;
}

/*! @brief *
 *  打开第三方链接
 */
+ (BOOL)openThirdLibraryWithUrlString:(NSString *)urlString {
    
    if (ZLStringIsNull(urlString)) {
        
        NSLog(@"链接为空");
        return NO;
    }
    
    return [ZLSystemUtils openSystemSettingWithUrlString:urlString];
}

/*! @brief *
 *  打开系统设置界面
 */
+ (BOOL)openSystemSettingWithUrlString:(NSString *)urlString {

    // 统一打开设置管理界面
    NSURL *url = [NSURL URLWithString:urlString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        
        if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_9_x_Max) {
            
            //10.0 以下调用
            [[UIApplication sharedApplication] openURL:url];
        }else {
            
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                
                NSLog(@"打开完成");
            }];
        }
        return YES;
    }else {
        
        //统一打开不
        NSLog(@"因为设置问题打不开设置");
        return NO;
    }
}

/*! @brief *
 *  打开全局系统设置
 */
+ (BOOL)openSystemSetting {
    
    if (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_8_0) {
        
        NSLog(@"系统低于8.0,打不开系统设置");
        return NO;
    }
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        return YES;
    }else {
        
        NSLog(@"就是打不开");
        return NO;
    }
}

/*! @brief *
 *  是否有摄像头使用权限
 *
 *  @param authorized 有权限回调
 *  @param restricted 无权限回调
 */
+(void)videoAuthorizationStatusAuthorized:(void(^)(void))authorized restricted:(void(^)(void))restricted
{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted ||
       authStatus == AVAuthorizationStatusDenied){
        if(restricted)
        {
            restricted();
        }
    }
    else
    {
        authorized();
    }
}
/*! @brief *
 *  是否有麦克风使用权限
 *
 *  @param authorized 有权限回调
 *  @param restricted 无权限回调
 */
+(void)soundAuthorizationStatusAuthorized:(void(^)(void))authorized restricted:(void(^)(void))restricted
{
    
    if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            if (granted) {
                NSLog(@"允许使用麦克风！");
                authorized();
            }else {
                NSLog(@"不允许使用麦克风！");
                if(restricted)
                {
                    restricted();
                }
            }
        }];
    }
}

/*! @brief *
 *  是否有相册访问权限
 *
 *  @param authorized 有权限回调
 *  @param restricted 无权限回调
 */
+ (void)assetsAuthorizationStatusAuthorized:(void(^)(void))authorized restricted:(void(^)(void))restricted {

    NSInteger status = [self authorizationStatus];
    if (status == 3) {
        if (authorized) {
            authorized();
        }
    }else if (status == 0){
        [self requestAuthorizationWithCompletion:authorized restricted:restricted];
    }else{
        if (restricted) {
            restricted();
        }
    }
}
+ (NSInteger)authorizationStatus {
    if (ZL_IOS8) {
        return [PHPhotoLibrary authorizationStatus];
    } else {
        return [ALAssetsLibrary authorizationStatus];
    }
    return NO;
}
//第一次请求时的回调
+ (void)requestAuthorizationWithCompletion:(void(^)(void))authorized restricted:(void(^)(void))restricted {
   
    void (^main_queue_authorized)(void) = ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (authorized) {
                authorized();
            }
        });
    };
    void (^main_queue_restricted)(void) = ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (restricted) {
                restricted();
            }
        });
    };
    
    if (ZL_IOS8) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    if (main_queue_authorized) {
                        main_queue_authorized();
                    }
                }else{
                    if (main_queue_restricted) {
                        main_queue_restricted();
                    }
                }
            }];
        });
    } else {
        ALAssetsLibrary *assetLibrary =  [[ALAssetsLibrary alloc] init];
        [assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (main_queue_authorized) {
                main_queue_authorized();
            }
        } failureBlock:^(NSError *error) {
            if (main_queue_restricted) {
                main_queue_restricted();
            }
        }];
    }
}
/*! @brief *
 *  是否有相机访问权限
 *
 *  @param authorized 有权限回调
 *  @param restricted 无权限回调
 */
+ (void)avMediaAuthorizationStatusAuthorized:(void(^)(void))authorized restricted:(void(^)(void))restricted {
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied) {
        
        //无权限
        NSLog(@"不允许使用相机！");
        if (restricted) {
            
            restricted();
        }
    }else {
        
        //有访问权限
        NSLog(@"允许使用相机！");
        authorized();
    }
}

/*! @brief *
 *  是否有定位访问权限
 *
 *  @param authorized 有权限回调
 *  @param restricted 无权限回调
 */
+ (void)locationAuthorizationStatusAuthorized:(void(^)(void))authorized restricted:(void(^)(void))restricted {
    
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)) {
        
        //有访问权限
        NSLog(@"允许使用定位！");
        authorized();
        
    }else {
        
        //无权限
        NSLog(@"不允许使用定位！");
        if (restricted) {
            
            restricted();
        }
    }
}

/*! @brief *
 *  是否有通讯录访问权限
 *
 *  @param authorized 有权限回调
 *  @param restricted 无权限回调
 */
+ (void)addressBookAuthorizationStatusAuthorized:(void(^)(void))authorized restricted:(void(^)(void))restricted {
    
    if (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_9_0) {
        
        //9.0之前
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            if (granted) {
                NSLog(@"允许访问通讯录");
                authorized();
            }else{
                NSLog(@"不允许访问通讯录");
                if (restricted) {
                    
                    restricted();
                }
            }
        });
        
    }else {
        
        //9.0之后
        CNContactStore *contactStore = [[CNContactStore alloc] init];
        [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                
                NSLog(@"允许访问通讯录");
                authorized();
                
            }else{
                
                NSLog(@"不允许访问通讯录");
                if (restricted) {
                    
                    restricted();
                }
            }
        }];
        
    }
}

/*! @brief *
 *  是否有网络访问权限
 *
 *  @param authorized 有权限回调
 *  @param restricted 无权限回调
 *  @param unknownNet 未知网络回调
 */
+ (void)netWorkAuthorizationStatusAuthorized:(void(^)(void))authorized restricted:(void(^)(void))restricted unknownNet:(void (^)(void))unknownNet {
    
    CTCellularData *cellularData = [[CTCellularData alloc]init];
    cellularData.cellularDataRestrictionDidUpdateNotifier =  ^(CTCellularDataRestrictedState state){
        //获取联网状态
        switch (state) {
            case kCTCellularDataRestricted: {
             
                NSLog(@"网络访问受限");
                //无权限
                if (restricted) {
                    
                    restricted();
                }
                
            }break;
            case kCTCellularDataNotRestricted: {
                
                NSLog(@"网络访问不受限");
                authorized();
                
            }break;
            case kCTCellularDataRestrictedStateUnknown: {
                
                NSLog(@"网络未知");
                if (unknownNet) {
                    
                    unknownNet();
                }
            }break;
            default:
                break;
        };
    };
}

/*! @brief *
 *  获取当前的显示的ViewController
 */
+ (UIViewController *)getCurrentViewController{
    
    UIViewController *result = nil;  
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];  
    if (window.windowLevel != UIWindowLevelNormal)  
    {  
        NSArray *windows = [[UIApplication sharedApplication] windows];  
        for(UIWindow * tmpWin in windows)  
        {  
            if (tmpWin.windowLevel == UIWindowLevelNormal)  
            {  
                window = tmpWin;  
                break;  
            }  
        }  
    }  
    
    UIView *frontView = [[window subviews] objectAtIndex:0];  
    id nextResponder = [frontView nextResponder];  
    
    if ([nextResponder isKindOfClass:[UIViewController class]])  
        result = nextResponder;  
    else  
        result = window.rootViewController;  
    
    return result;  
} 
+ (NSString *)getAppVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    if (![[infoDictionary allKeys] containsObject:@"CFBundleShortVersionString"]) {
        return nil;
    }
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_Version;
}

+ (BOOL)iPhone4Device
{
    return CGSizeEqualToSize((CGSize){320,480}, [ZLSystemUtils deviceScreenSize]);
}

+ (BOOL)iPhone5Device
{
    return CGSizeEqualToSize((CGSize){320,568}, [ZLSystemUtils deviceScreenSize]);
    
}

+ (BOOL)iPhone6Device
{
    return CGSizeEqualToSize((CGSize){375,667}, [ZLSystemUtils deviceScreenSize]);
}

+ (BOOL)iPhone6PlusDevice
{
    return CGSizeEqualToSize((CGSize){414,736}, [ZLSystemUtils deviceScreenSize]);
}

+ (BOOL)iPhoneXDevice {
    
    return CGSizeEqualToSize((CGSize){375,812}, [ZLSystemUtils deviceScreenSize]);
}

+ (BOOL)iPhoneDeviceVersion:(CGFloat)version{
    return [[[UIDevice currentDevice] systemVersion] floatValue]>=version;
}

/*! @brief *
 *  获取状态栏高度
 */
+ (CGFloat)obtainStatusHeight {
    
    return [[UIApplication sharedApplication] statusBarFrame].size.height;
}

+ (CGFloat)obtainSafeHeight {
    
    if ([ZLSystemUtils iPhoneXDevice]) {
        return 34.0f;
    }
    return 0.0;
}

+ (BOOL)is64bit {
    
#if defined(__LP64__) && __LP64__
    return YES;
#else
    return NO;
#endif
}

+ (BOOL)cameraAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}
+ (BOOL)isAppPhotoLibraryAccessAuthorized
{
    ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
    
    if (authStatus != ALAuthorizationStatusAuthorized) {
        
        return authStatus == ALAuthorizationStatusNotDetermined;
        
    }else{
        
        return YES;
    }
}

+ (NSString*)currentTimeStampString
{
    NSDate *now = [NSDate date];
    NSTimeInterval timeInterval = [now timeIntervalSinceReferenceDate];
    
    NSString *timeString = [NSString stringWithFormat:@"%lf",timeInterval];
    timeString = [timeString stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    return timeString;
    
}
+ (UIColor *)colorFromRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
    return [ZLSystemUtils colorFromRed:red green:green blue:blue withAlpha:1.0];
}

+ (UIColor *)colorFromRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue withAlpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}

+ (UIColor *)colorFromHexString:(NSString *)hexString
{
    if (ZLStringIsNull(hexString)) {
        return nil;
    }
    
    unsigned hexNum;
    if ( ![[NSScanner scannerWithString:hexString] scanHexInt:&hexNum] ) {
        return nil;
    }
    
    return [UIColor colorWithRed:((float)((hexNum & 0xFF0000) >> 16))/255.0 green:((float)((hexNum & 0xFF00) >> 8))/255.0 blue:((float)(hexNum & 0xFF))/255.0 alpha:1.0];
}
+ (UIColor *)randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}
/*! @brief *
 *  获取rgb值
 */
+ (NSMutableArray *)changeUIColorToRGB:(UIColor *)color
{
    NSMutableArray *RGBStrValueArr = [[NSMutableArray alloc] init];
    NSString *RGBStr = nil;
    
    //获得RGB值描述
    NSString *RGBValue = [NSString stringWithFormat:@"%@", color];
    
    //将RGB值描述分隔成字符串
    NSArray *RGBArr = [RGBValue componentsSeparatedByString:@" "];
    
    float r = [RGBArr[1] floatValue]*255;
    RGBStr = [NSString stringWithFormat:@"%.0lf", r];
    [RGBStrValueArr addObject:RGBStr];
    
    float g = [RGBArr[2] floatValue]*255;
    RGBStr = [NSString stringWithFormat:@"%.0lf", g];
    [RGBStrValueArr addObject:RGBStr];
    
    float b = [RGBArr[3] floatValue]*255;
    RGBStr = [NSString stringWithFormat:@"%.0lf", b];
    [RGBStrValueArr addObject:RGBStr];
    
    float a = [RGBArr[4] floatValue];
    RGBStr = [NSString stringWithFormat:@"%.2lf", a];
    [RGBStrValueArr addObject:RGBStr];
    
    return RGBStrValueArr;
}


+ (CGFloat)deviceScreenScale{
    static CGFloat scale;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scale = [UIScreen mainScreen].scale;
    });
    return scale;
}
+ (CGSize)deviceScreenSize{
    static CGSize size;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        size = [UIScreen mainScreen].bounds.size;
        if (size.height < size.width) {
            CGFloat tmp = size.height;
            size.height = size.width;
            size.width = tmp;
        }
    });
    return size;
}
+ (BOOL)isNullObject:(id)anObject
{
    if (!anObject || [anObject isKindOfClass:[NSNull class]]) {
        return YES;
    }else{
        return NO;
    }
}

/**
 判断数组是否为空
 */
+ (BOOL)arrayIsNull:(NSArray *)array{
    
    if (![array isKindOfClass:[NSArray class]]) {
        return YES;
    }
//    if (![array isKindOfClass:[NSMutableArray class]]) {
//        return YES;
//    }
    if (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0){
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)checkValue:(id)value key:(id)key
{
    if(ZLCheckObjectNull(value)||ZLCheckObjectNull(key)){
        return YES;
    }else{
        return NO;
    }
}

+ (UIImage *)getTheLaunchImage
{
    static UIImage *image;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        CGSize viewSize = [UIScreen mainScreen].bounds.size;
        NSString *viewOrientation = nil;
        if (([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown) || ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait)) {
            viewOrientation = @"Portrait";
        } else {
            viewOrientation = @"Landscape";
        }
        
        
        NSString *launchImage = nil;
        
        NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
        for (NSDictionary* dict in imagesDict)
        {
            CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
            
            if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
            {
                launchImage = dict[@"UILaunchImageName"];
            }
        }
        
        image = [UIImage imageNamed:launchImage];
        
    });
    
    return image;
    
}

/**
 获取App icon
 
 @return icon
 */
+ (UIImage *)getTheAppIcon {
    
   static UIImage *image;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
        NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
        image = [UIImage imageNamed:icon];
    });
    
    return image;
}

/**
 获取App name
 
 @return name
 */
+ (NSString *)getTheAppName {
    
    NSDictionary *infoDict = [NSBundle mainBundle].localizedInfoDictionary;
    if (!infoDict) {
        infoDict = [NSBundle mainBundle].infoDictionary;
    }
    
    if (![[infoDict allKeys] containsObject:@"CFBundleDisplayName"] && ![[infoDict allKeys] containsObject:@"CFBundleName"]) {
        
        return nil;
    }
    
    NSString *appName = [infoDict valueForKey:@"CFBundleDisplayName"];
    if (!appName) appName = [infoDict valueForKey:@"CFBundleName"];
    return appName;
}

/**
  获取当前设备可用内存(单位：MB）
 
 @return 内存
 */
+ (double)availableMemory {
    
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats, 
                                               &infoCount);
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    return ((vm_page_size *vmStats.free_count) / 1024.0) / 1024.0;
}

/**
 获取当前任务所占用的内存（单位：MB）
 
 @return 内存
 */
+ (double)usedMemory {
    
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    if (kernReturn != KERN_SUCCESS ) {
        return NSNotFound;
    }
    return taskInfo.resident_size / 1024.0 / 1024.0;
}

@end
