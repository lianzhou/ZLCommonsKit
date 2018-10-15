//
//  JZEmojView.h
//  JZChatToolBarView
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by 马金丽 on 17/6/23.
//  Copyright © 2017年 majinli. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JZEmojiBoardView.h"

#define JZ_EmojiKeyBoardHeight 216  //表情键盘高度
@class JZEmojView;
@class JZEmojiInfo;
@protocol JZEmojViewDelegate <NSObject>

@optional
- (void)emojiView:(JZEmojView *)emojiView withEmojiSelect:(JZEmojiInfo *)info;
- (void)emojiViewDeleteClick:(JZEmojView *)emojiView;
- (void)emojiViewSendTextAction:(JZEmojView *)emojiView;


@end
@interface JZEmojView : UIView

@property(nonatomic,weak)id<JZEmojViewDelegate>delegate;

@property(nonatomic,assign)BOOL isShowBottomView;

@end
