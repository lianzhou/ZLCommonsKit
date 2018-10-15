//
//  JZShowContentView.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HPGrowingTextView;
@class JZShowContentView;
@protocol JZShowContentViewDelegate <NSObject>

@optional

- (void)showContentView:(JZShowContentView *)showContentView browsePicWithIndex:(NSInteger)index withImageView:(UIView*)imageView;

- (void)showContentView:(JZShowContentView *)showContentView deletePicWithIndex:(NSInteger)index;


@end
@interface JZShowContentView : UIView
@property(nonatomic, assign)id<JZShowContentViewDelegate>delegate;

@property(nonatomic,strong)NSArray *picsArray;

@property(nonatomic,strong)HPGrowingTextView *contentTextView;

@property(nonatomic,assign)CGFloat contentHeight;

@property(nonatomic,assign)CGFloat picHeight;

@property(nonatomic,copy)NSString *palaceStr;

@property(nonatomic,assign)NSInteger maxInputStrNumber;   //允许输入的最大字数限制

@property(nonatomic,assign)BOOL isHidenLabel;

@end

