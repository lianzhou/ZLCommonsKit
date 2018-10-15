//
//  JZEmojiBoardView.h
//  JZChatToolBarView
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by 马金丽 on 17/6/26.
//  Copyright © 2017年 majinli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JZEmojiInfo;
@class JZEmojiBoardView;

@protocol JZEmojiBoardDelegate <NSObject>

@optional
- (void)emojiSelect:(JZEmojiInfo *)info;
- (void)emojiDelete;
- (void)sendTextAction;
- (void)emojoCollectionViewDidEndDecelerating:(JZEmojiBoardView *)emojiBoardView withCurrentPage:(NSInteger)page;

@end

@interface JZEmojiBoardView : UIView

@property (nonatomic, strong)UICollectionView *allEmojiCollectionView;

@property(nonatomic,assign)id<JZEmojiBoardDelegate>delegate;


@property(nonatomic,assign)BOOL isShowBottomView;



@end



/**
 表情cell
 */
@interface JZEmojiCell : UICollectionViewCell





- (void)emojiCellDataWithImageName:(NSString *)imageName;

@end



typedef void(^DeleteEmojiClickBlock)(NSInteger index);
typedef void(^ChooseEmojiClickBlock)(NSDictionary *emojiDict);

/**
 pageCell
 */
@interface JZEmojiPageCell : UICollectionViewCell

@property(nonatomic, copy)DeleteEmojiClickBlock deleteEmojiBlock;
@property(nonatomic, copy)ChooseEmojiClickBlock chooseEmojiBlock;

@property(nonatomic, assign)BOOL isBottomView;  

@property (nonatomic, strong) NSArray <NSDictionary *> *currentPageEmojiList;

@end
