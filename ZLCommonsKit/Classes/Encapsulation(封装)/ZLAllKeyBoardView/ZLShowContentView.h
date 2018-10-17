//
//  ZLShowContentView.h
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
@class ZLShowContentView;
@protocol ZLShowContentViewDelegate <NSObject>

@optional

- (void)showContentView:(ZLShowContentView *)showContentView browsePicWithIndex:(NSInteger)index withImageView:(UIView*)imageView;

- (void)showContentView:(ZLShowContentView *)showContentView deletePicWithIndex:(NSInteger)index;


@end
@interface ZLShowContentView : UIView
@property(nonatomic, assign)id<ZLShowContentViewDelegate>delegate;

@property(nonatomic,strong)NSArray *picsArray;

@property(nonatomic,strong)HPGrowingTextView *contentTextView;

@property(nonatomic,assign)CGFloat contentHeight;

@property(nonatomic,assign)CGFloat picHeight;

@property(nonatomic,copy)NSString *palaceStr;

@property(nonatomic,assign)NSInteger maxInputStrNumber;   //允许输入的最大字数限制

@property(nonatomic,assign)BOOL isHidenLabel;

@end

