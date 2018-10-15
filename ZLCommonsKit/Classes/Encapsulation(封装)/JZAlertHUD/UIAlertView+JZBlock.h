//
//  UIAlertView+JZBlock.h
//  eStudy
//
//  Created by zhoulian on 17/6/23.
//

#import <UIKit/UIKit.h>

typedef void(^UIAlertViewCallBackBlock)(NSInteger buttonIndex);

@interface UIAlertView (JZBlock)

@property (nonatomic, copy) UIAlertViewCallBackBlock alertViewCallBackBlock;

@end
