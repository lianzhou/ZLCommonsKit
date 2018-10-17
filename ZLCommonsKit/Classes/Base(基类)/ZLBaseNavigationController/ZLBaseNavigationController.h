//
//  ZLBaseNavigationController.h
//  Pods
//
//  Created by zhoulian on 17/8/23.
//
//

#import <UIKit/UIKit.h>

@interface ZLBaseNavigationController : UINavigationController

@property (nonatomic, copy) id zl_tempNavDelegate;

@property (nonatomic, assign) NSNumber *zl_isNoUseGesture;

@end
