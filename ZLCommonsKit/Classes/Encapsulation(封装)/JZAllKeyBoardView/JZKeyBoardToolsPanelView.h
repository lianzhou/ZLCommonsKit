//
//  JZKeyBoardToolsPanelView.h
//  e学云
//
//  Created by 马金丽 on 17/5/18.
//  Copyright © 2017年 juziwl. All rights reserved.
//

#import <UIKit/UIKit.h>

#define JZ_MoreToolKeyBoardHeight 256   //工具面板键盘高度

@class JZKeyBoardToolsPanelView;
@protocol JZKeyBoardToolsPanelDelegate <NSObject>

@optional

- (void)jzKeyBoardToolsPanel:(JZKeyBoardToolsPanelView *)keyBoardToolView didSelectedWithItem:(NSDictionary *)itemDict withTitle:(NSString *)itemTitle;


@end

@interface JZKeyBoardToolsPanelView : UIView

@property(nonatomic,assign)id<JZKeyBoardToolsPanelDelegate>toolDelegate;


- (instancetype)initWithFrame:(CGRect)frame with_itemsArray:(NSArray *)itemsArray;

@end
