//
//  ENProgressView.h
//  ZLImagePickerController
//
//  Created by li_chang_en on 2017/11/11.
//  Copyright © 2017年 李长恩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>

@interface ENProgressView : UIView

/// 0 ~ 100
@property (nonatomic,assign) CGFloat progress;

- (void)updateWidthConstraints:(CGFloat)width completion:(void (^)(BOOL finished))completion;


@end
