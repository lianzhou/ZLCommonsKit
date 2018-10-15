//
//  JZEmojiBottomView.h
//  eStudy
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by 马金丽 on 17/6/29.
//  Copyright © 2017年 苏州橘子网络科技股份有限公司. All rights reserved.
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
