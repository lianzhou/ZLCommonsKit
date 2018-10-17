//
//  ENTitleView.h
//  ZLImagePickerController
//
//  Created by li_chang_en on 2017/11/4.
//  Copyright © 2017年 李长恩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>

typedef BOOL (^ENTitleViewWithTitleButtonClick)(UIButton * sender);

@interface ENTitleView : UIView


@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * attributedTitle;
@property(nonatomic,copy)NSString * attributedImageName;

@property ENTitleViewWithTitleButtonClick titleViewWithTitleButtonClick;

@end
