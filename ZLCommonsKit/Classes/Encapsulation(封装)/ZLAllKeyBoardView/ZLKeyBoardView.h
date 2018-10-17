//
//  ZLKeyBoardView.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZLAudioModel;
@class ZLKeyBoardView;
@class HPGrowingTextView;
//样式
typedef enum : NSUInteger {
    ZLKeyBoardViewDefault,  //默认:语音+输入框+表情+更多
    ZLKeyBoardViewEmoji_Input_More,//表情+输入框+更多
    ZLKeyBoardViewInput_Emoji_More,  //输入框+表情+更多
    ZLKeyBoardViewPic_Carmera_Emoji_Send,   //相册+相机+表情(没有发送)
    ZLKeyBoardViewRecordVideo_Emoji_More_Send,   //语音+表情+更多+发送
    ZLKeyBoardViewRecordEmoji_Send, //输入框+表情
    ZLKeyBoardViewRecordEmoji, //表情
    
} ZLKeyBoardViewType;


//按钮
typedef enum : NSUInteger {
    ZLKeyBoardView_KeyBoard = 1001,
    ZLKeyBoardView_Emoji,
    ZLKeyBoardView_More,
    ZLKeyBoardView_Record,
    ZLKeyBoardView_Pic,
    ZLKeyBoardView_Finish,
    ZLKeyBoardView_Camera,
    
} ZLKeyBoardViewBtnType;

@protocol ZLKeyBoardViewDelegate <NSObject>

@optional

/**
 工具面板的发送
 
 @param text 输入的文本内容
 */
- (void)keyBoardViewSendText:(NSString *)text;

/**
 点击发送按钮
 
 @param finishTitle 输入的文本
 */
- (void)keyBoardViewSendBtnActionWithTitle:(NSString *)finishTitle;    //发送按钮

/**
 工具条上的按钮点击事件
 
 @param btnType 按钮的tag
 */
- (void)keyBoardView:(ZLKeyBoardView *)boardView btnSelectedAction:(ZLKeyBoardViewBtnType)btnType;

/**
 键盘变动的高度
 
 @param boardView 键盘
 @param keyBoardViewHeight 高度
 */
- (void)keyBoardView:(ZLKeyBoardView *)boardView didChangeKeyBoardHeight:(CGFloat)keyBoardViewHeight;


/**
 录音完成
 
 @param boardView self
 @param audioModel 录音完成之后的model
 */
- (void)keyBoardView:(ZLKeyBoardView *)boardView recordFinish:(ZLAudioModel *)audioModel;



/**
 浏览大图
 
 @param boardView self
 @param index 索引
 @param imageView imageView
 */
- (void)keyBoardView:(ZLKeyBoardView *)boardView browsePicIndex:(NSInteger)index withImageview:(UIView *)imageView;

/**
 删除图片
 
 @param boardView self
 @param index 删除图片的索引
 */
- (void)keyBoardView:(ZLKeyBoardView *)boardView deletePicIndex:(NSInteger)index;


/**
 点击抹灰层
 
 @param boardView self
 @param blackView self.blackView
 */
- (void)keyBoardView:(ZLKeyBoardView *)boardView clickBlackView:(UIView *)blackView;

//键盘将要降落
- (void)keyBoardViewWillDown:(ZLKeyBoardView *)boardView;

- (void)keyBoardViewTextViewDidChange:(HPGrowingTextView *)textView;
- (void)keyBoardViewTextViewDidBeginEditing:(HPGrowingTextView *)textView;

- (void)keyBoardViewDidChangeHeight:(HPGrowingTextView *)textView;
@end


@interface ZLKeyBoardView : UIView

@property(nonatomic,strong)HPGrowingTextView *inputTextView;    //输入框

/**
 键盘颜色
 */
@property(nonatomic,strong)UIColor *headerBackGroundColor;

/**
 键盘工具条高度
 */
@property(nonatomic,assign)CGFloat headerHeight;

/**
 键盘代理
 */
@property(nonatomic,weak)id<ZLKeyBoardViewDelegate>delegate;

/**
 当前操作的textView
 */
@property(nonatomic,strong)HPGrowingTextView *currentTextView;
/**
 允许最大输入的字数
 */
@property(nonatomic,assign)NSInteger maxLimitNumber;    //最大允许输入的数

/**
 占位符
 */
@property(nonatomic,copy)NSString *placHolder;

/**
 是否显示表情底部工具栏
 */
@property(nonatomic,assign)BOOL isShowEmojiBottomToolView;

/**
 照片选择完成之后,负责给该数组,用来显示图片
 */
@property(nonatomic,strong)NSMutableArray *showPicArray;

/**
 是否显示发送按钮:默认YES,显示
 */
@property(nonatomic,assign)BOOL isShowSendBtn;

/**
 是否显示抹灰层:默认YES,显示
 */
@property(nonatomic,assign)BOOL isShowGrayLayer;

/**
 是否显示键盘头部内容View
 */
@property(nonatomic,assign)BOOL isShowHeaderContentView;

@property(nonatomic,assign)BOOL isTopViewController;

@property(nonatomic,copy)NSString *finishTitle; //完成按钮的标题
@property(nonatomic,strong)UIColor *finishTitleColor;//完成按钮的颜色
@property(nonatomic,assign)CGFloat systemHeight;
@property(nonatomic,assign)NSInteger inputNumber; //正在输入的字数
@property(nonatomic,strong)UIView *blackView;

- (instancetype)initWithFrame:(CGRect)frame withViewType:(ZLKeyBoardViewType)viewType;
- (void)keyBoardViewHiden;
- (NSString *)DraftText;
- (void)setDraftText:(NSString *)draftText;

- (void)blackViewWillHiden;

- (void)removeBackView;
- (void)reloadPicView;
- (void)removeNotication;
- (void)addKeyNotication;
@end

