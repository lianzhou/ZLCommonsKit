//
//  ZLKeyBoardToolsPanelView.h
//
//
//  Created by 马金丽 on 17/5/18.
//  Copyright © 2017年 juziwl. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ZL_MoreToolKeyBoardHeight 256   //工具面板键盘高度

@class ZLKeyBoardToolsPanelView;
@protocol ZLKeyBoardToolsPanelDelegate <NSObject>

@optional

- (void)zlKeyBoardToolsPanel:(ZLKeyBoardToolsPanelView *)keyBoardToolView didSelectedWithItem:(NSDictionary *)itemDict withTitle:(NSString *)itemTitle;


@end

@interface ZLKeyBoardToolsPanelView : UIView

@property(nonatomic,assign)id<ZLKeyBoardToolsPanelDelegate>toolDelegate;


- (instancetype)initWithFrame:(CGRect)frame with_itemsArray:(NSArray *)itemsArray;

@end
