//
//  JZKeyBoardView.h
//  eStudy
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by 马金丽 on 17/6/26.
//  Copyright © 2017年 苏州橘子网络科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JZAudioModel;
@class JZKeyBoardView;
@class HPGrowingTextView;
//样式
typedef enum : NSUInteger {
    JZKeyBoardViewDefault,  //默认:语音+输入框+表情+更多
    JZKeyBoardViewEmoji_Input_More,//表情+输入框+更多
    JZKeyBoardViewInput_Emoji_More,  //输入框+表情+更多
    JZKeyBoardViewPic_Carmera_Emoji_Send,   //相册+相机+表情(没有发送)
    JZKeyBoardViewRecordVideo_Emoji_More_Send,   //语音+表情+更多+发送
    JZKeyBoardViewRecordEmoji_Send, //输入框+表情
    JZKeyBoardViewRecordEmoji, //表情
    
} JZKeyBoardViewType;


//按钮
typedef enum : NSUInteger {
    JZKeyBoardView_KeyBoard = 1001,
    JZKeyBoardView_Emoji,
    JZKeyBoardView_More,
    JZKeyBoardView_Record,
    JZKeyBoardView_Pic,
    JZKeyBoardView_Finish,
    JZKeyBoardView_Camera,
    
} JZKeyBoardViewBtnType;

@protocol JZKeyBoardViewDelegate <NSObject>

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
- (void)keyBoardView:(JZKeyBoardView *)boardView btnSelectedAction:(JZKeyBoardViewBtnType)btnType;

/**
 键盘变动的高度
 
 @param boardView 键盘
 @param keyBoardViewHeight 高度
 */
- (void)keyBoardView:(JZKeyBoardView *)boardView didChangeKeyBoardHeight:(CGFloat)keyBoardViewHeight;


/**
 录音完成
 
 @param boardView self
 @param audioModel 录音完成之后的model
 */
- (void)keyBoardView:(JZKeyBoardView *)boardView recordFinish:(JZAudioModel *)audioModel;



/**
 浏览大图
 
 @param boardView self
 @param index 索引
 @param imageView imageView
 */
- (void)keyBoardView:(JZKeyBoardView *)boardView browsePicIndex:(NSInteger)index withImageview:(UIView *)imageView;

/**
 删除图片
 
 @param boardView self
 @param index 删除图片的索引
 */
- (void)keyBoardView:(JZKeyBoardView *)boardView deletePicIndex:(NSInteger)index;


/**
 点击抹灰层
 
 @param boardView self
 @param blackView self.blackView
 */
- (void)keyBoardView:(JZKeyBoardView *)boardView clickBlackView:(UIView *)blackView;

//键盘将要降落
- (void)keyBoardViewWillDown:(JZKeyBoardView *)boardView;

- (void)keyBoardViewTextViewDidChange:(HPGrowingTextView *)textView;
- (void)keyBoardViewTextViewDidBeginEditing:(HPGrowingTextView *)textView;

- (void)keyBoardViewDidChangeHeight:(HPGrowingTextView *)textView;
@end


@interface JZKeyBoardView : UIView

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
@property(nonatomic,weak)id<JZKeyBoardViewDelegate>delegate;

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

- (instancetype)initWithFrame:(CGRect)frame withViewType:(JZKeyBoardViewType)viewType;
- (void)keyBoardViewHiden;
- (NSString *)DraftText;
- (void)setDraftText:(NSString *)draftText;

- (void)blackViewWillHiden;

- (void)removeBackView;
- (void)reloadPicView;
- (void)removeNotication;
- (void)addKeyNotication;
@end

