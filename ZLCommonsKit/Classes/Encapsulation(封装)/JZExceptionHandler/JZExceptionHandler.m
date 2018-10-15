//
//  JZExceptionHandler.m
//  eStudy(comprehensive)
//
//  Created by Allen_Xu on 2018/1/8.
//  Copyright © 2018年 苏州橘子网络科技股份有限公司. All rights reserved.
//

#import "JZExceptionHandler.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#import "JZAlertHUD.h"
#import "JZCollectionUtils.h"

static NSString * const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";
static NSString * const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
NSString * const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";

static volatile int32_t UncaughtExceptionCount = 0;
static const int32_t UncaughtExceptionMaximum = 10;
const NSInteger UncaughtExceptionHandlerSkipAddressCount = 4;
const NSInteger UncaughtExceptionHandlerReportAddressCount = 5;

@interface JZExceptionHandler ()
@property (nonatomic) NSUncaughtExceptionHandler *defaultExceptionHandler;
@property (nonatomic, unsafe_unretained) struct sigaction *prev_signal_handlers;
@property (nonatomic, strong) NSHashTable *sensorsAnalyticsSDKInstances;
@end

@implementation JZExceptionHandler

# pragma mark - initialize
+ (instancetype)sharedHandler {
    static JZExceptionHandler *gSharedHandler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gSharedHandler = [[JZExceptionHandler alloc] init];
    });
    return gSharedHandler;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // Create a hash table of weak pointers to SensorsAnalytics instances
//        _sensorsAnalyticsSDKInstances = [NSHashTable weakObjectsHashTable];
        
        _prev_signal_handlers = calloc(NSIG, sizeof(struct sigaction));
        
        // Install our handler
        [self setupHandlers];
    }
    return self;
}

- (void)dealloc {
    free(_prev_signal_handlers);
}

- (void)setupHandlers {
    _defaultExceptionHandler = NSGetUncaughtExceptionHandler();
    NSSetUncaughtExceptionHandler(&JZHandleException);
    
    struct sigaction action;
    sigemptyset(&action.sa_mask);
    action.sa_flags = SA_SIGINFO;
    action.sa_sigaction = &JZSignalHandler;
    int signals[] = {SIGABRT, SIGILL, SIGSEGV, SIGFPE, SIGBUS, SIGPIPE};
    for (int i = 0; i < sizeof(signals) / sizeof(int); i++) {
        struct sigaction prev_action;
        int err = sigaction(signals[i], &action, &prev_action);
        if (err == 0) {
            memcpy(_prev_signal_handlers + signals[i], &prev_action, sizeof(prev_action));
        } else {
            NSLog(@"Errored while trying to set up sigaction for signal %d", signals[i]);
        }
    }
}
 
void JZSignalHandler(int signal, struct __siginfo *info, void *context) {
    JZExceptionHandler *handler = [JZExceptionHandler sharedHandler];
    
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount <= UncaughtExceptionMaximum) {
        NSDictionary *userInfo = @{UncaughtExceptionHandlerSignalKey: @(signal)};
        NSException *exception = [NSException exceptionWithName:UncaughtExceptionHandlerSignalExceptionName
                                                         reason:[NSString stringWithFormat:@"Signal %d was raised.", signal]
                                                       userInfo:userInfo];
        
        [handler jz_handleUncaughtException:exception];
    }
    
    struct sigaction prev_action = handler.prev_signal_handlers[signal];
    if (prev_action.sa_flags & SA_SIGINFO) {
        if (prev_action.sa_sigaction) {
            prev_action.sa_sigaction(signal, info, context);
        }
    } else if (prev_action.sa_handler) {
        prev_action.sa_handler(signal);
    }
}

void JZHandleException(NSException *exception) {
    JZExceptionHandler *handler = [JZExceptionHandler sharedHandler];
    
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount <= UncaughtExceptionMaximum) {
        [handler jz_handleUncaughtException:exception];
    }
    
    if (handler.defaultExceptionHandler) {
        handler.defaultExceptionHandler(exception);
    }
}

- (void) jz_handleUncaughtException:(NSException *)exception {
    // Archive the values for each SensorsAnalytics instance
//    for (SensorsAnalyticsSDK *instance in self.sensorsAnalyticsSDKInstances) {
//        NSMutableDictionary *properties = [[NSMutableDictionary alloc] init];
//        [properties setValue:[exception reason] forKey:@"app_crashed_reason"];
//        [instance track:@"AppCrashed" withProperties:properties];
//        [instance track:@"$AppEnd"];
//        dispatch_sync(instance.serialQueue, ^{
//
//        });
//    }

    NSLog(@"程序报错,快看看!!!!!!!!!!\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n %@ \n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n!!!!!!!!!!!!!!!!!!!!!!!!!!",exception);
/*
 
 需求更改,出现异常之后不再弹框,而是直接干掉异常
 
 **/
    
    
    //设置弹出框来了提醒用户, 当然也可以是自己设计其他内容,
//    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"如果点击继续，程序有可能会出现其他的问题，建议您点击退出按钮并重新打开",nil)];

//    [JZAlertHUD alertShowTitle:@"程序出现了问题" message:message cancelButtonTitle:NSLocalizedString(@"退出",nil) otherButtonTitle:NSLocalizedString(@"继续",nil) continueBlock:^{
//
//
//    } cancelBlock:^{
//        dismissed = YES;
//    }];
    
    // 利用RunLoop , 来完成拦截的操作
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
    while (!dismissed) {
        for (NSString *mode in (__bridge NSArray *)allModes) {
            CFRunLoopRunInMode((CFStringRef)mode,0.001, false);
        }
    }
    
    CFRelease(allModes);
    NSSetUncaughtExceptionHandler(NULL);
    signal(SIGABRT,SIG_DFL);
    signal(SIGILL,SIG_DFL);
    signal(SIGSEGV,SIG_DFL);
    signal(SIGFPE,SIG_DFL);
    signal(SIGBUS,SIG_DFL);
    signal(SIGPIPE,SIG_DFL);
    
    if ([[exception name] isEqual:UncaughtExceptionHandlerSignalExceptionName]) {
        kill(getpid(), [[[exception userInfo] objectForKey:UncaughtExceptionHandlerSignalKey]intValue]);
    }else{
        [exception raise];
    }
 
}

@end
