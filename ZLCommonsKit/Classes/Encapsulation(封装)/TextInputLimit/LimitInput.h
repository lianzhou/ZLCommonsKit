//
//  LimitInput.h
//  singleview
//
//  Created by aqua on 14-8-30.
//  Copyright (c) 2014年 aqua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "UITextView+ZLDeleteBackward.h"
#import "UITextField+ZLDeleteBackward.h"


@interface UITextField (ZLTextField)

@property(nonatomic,strong) NSNumber * textField_isMore;
@property(nonatomic,strong) NSString * textField_tempText;


@end

@interface UITextView (ZLTextView)

@property(nonatomic,strong) NSNumber * textView_isMore;
@property(nonatomic,strong) NSString * textView_tempText;

@end

#define PROPERTY_NAME @"PROPERTY_NAME"

#define DECLARE_PROPERTY(className) \
@interface className (Limit) @end

DECLARE_PROPERTY(UITextField)
DECLARE_PROPERTY(UITextView)

@interface LimitInput : NSObject

@property(nonatomic, assign) BOOL enableLimitCount;

+(LimitInput *) sharedInstance;


@end
