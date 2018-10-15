//
//  JZBaseNavigationController.h
//  Pods
//
//  Created by zhoulian on 17/8/23.
//
//

#import <UIKit/UIKit.h>

@interface JZBaseNavigationController : UINavigationController

@property (nonatomic, copy) id jz_tempNavDelegate;

@property (nonatomic, assign) NSNumber *jz_isNoUseGesture;

@end
