//
//  ZLEmojiBoardView.h
//  ZLChatToolBarView
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by 马金丽 on 17/6/26.
//  Copyright © 2017年 majinli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZLEmojiInfo;
@class ZLEmojiBoardView;

@protocol ZLEmojiBoardDelegate <NSObject>

@optional
- (void)emojiSelect:(ZLEmojiInfo *)info;
- (void)emojiDelete;
- (void)sendTextAction;
- (void)emojoCollectionViewDidEndDecelerating:(ZLEmojiBoardView *)emojiBoardView withCurrentPage:(NSInteger)page;

@end

@interface ZLEmojiBoardView : UIView

@property (nonatomic, strong)UICollectionView *allEmojiCollectionView;

@property(nonatomic,assign)id<ZLEmojiBoardDelegate>delegate;


@property(nonatomic,assign)BOOL isShowBottomView;



@end



/**
 表情cell
 */
@interface ZLEmojiCell : UICollectionViewCell





- (void)emojiCellDataWithImageName:(NSString *)imageName;

@end



typedef void(^DeleteEmojiClickBlock)(NSInteger index);
typedef void(^ChooseEmojiClickBlock)(NSDictionary *emojiDict);

/**
 pageCell
 */
@interface ZLEmojiPageCell : UICollectionViewCell

@property(nonatomic, copy)DeleteEmojiClickBlock deleteEmojiBlock;
@property(nonatomic, copy)ChooseEmojiClickBlock chooseEmojiBlock;

@property(nonatomic, assign)BOOL isBottomView;  

@property (nonatomic, strong) NSArray <NSDictionary *> *currentPageEmojiList;

@end
