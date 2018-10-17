//
//  ZLEmojView.h
//  ZLChatToolBarView
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by 马金丽 on 17/6/23.
//  Copyright © 2017年 majinli. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZLEmojiBoardView.h"

#define ZL_EmojiKeyBoardHeight 216  //表情键盘高度
@class ZLEmojView;
@class ZLEmojiInfo;
@protocol ZLEmojViewDelegate <NSObject>

@optional
- (void)emojiView:(ZLEmojView *)emojiView withEmojiSelect:(ZLEmojiInfo *)info;
- (void)emojiViewDeleteClick:(ZLEmojView *)emojiView;
- (void)emojiViewSendTextAction:(ZLEmojView *)emojiView;


@end
@interface ZLEmojView : UIView

@property(nonatomic,weak)id<ZLEmojViewDelegate>delegate;

@property(nonatomic,assign)BOOL isShowBottomView;

@end
