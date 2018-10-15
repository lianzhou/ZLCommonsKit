//
//  JZEmojiBottomView.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JZEmojiBottomView;
@protocol JZEmojiBottomViewdelagate <NSObject>

- (void)jzEmojiBottomView:(JZEmojiBottomView *)bottomView didSelectedIndex:(NSInteger)selectedIndex;
- (void)jzBottomViewdidSendAction;
@end

@interface JZEmojiBottomView : UIView
@property(nonatomic,weak)id<JZEmojiBottomViewdelagate>delegate;


@end
