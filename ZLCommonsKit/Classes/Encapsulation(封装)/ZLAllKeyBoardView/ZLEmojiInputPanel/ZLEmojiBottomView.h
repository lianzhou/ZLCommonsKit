//
//  ZLEmojiBottomView.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZLEmojiBottomView;
@protocol ZLEmojiBottomViewdelagate <NSObject>

- (void)zlEmojiBottomView:(ZLEmojiBottomView *)bottomView didSelectedIndex:(NSInteger)selectedIndex;
- (void)zlBottomViewdidSendAction;
@end

@interface ZLEmojiBottomView : UIView
@property(nonatomic,weak)id<ZLEmojiBottomViewdelagate>delegate;


@end
