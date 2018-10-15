//
//  JZKeyBoardView.m
//  eStudy
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by 马金丽 on 17/6/26.
//  Copyright © 2017年 苏州橘子网络科技股份有限公司. All rights reserved.
//

#import "JZKeyBoardView.h"
#import "JZEmojView.h"
#import "JZEmojiInfo.h"
#import "JZEmojiHelper.h"
#import "MBProgressHUD.h"
#import "JZKeyBoardToolsPanelView.h"
#import "JZAudionRecordManager.h"
#import "JZSystemMacrocDefine.h"
//#import "UITextView+JZPlaceholder.h"
#import <Masonry/Masonry.h>
#import "JZStringMacrocDefine.h"
#import "JZAudioModel.h"
#import <YYKit.h>
#import "JZShowContentView.h"
#import "JZUtilsTools.h"
#import "HPGrowingTextView.h"
#import "JZFlurBackView.h"
#import "UIView+JZUIViewExtension.h"
#import "NSString+Extension.h"
#import "JZAlertHUD.h"
#import "JZSystemUtils.h"

#define JZEMJOSENDER_HEIGHT 40.5
#define JZHEADERHEIGHT 50
#define JZ_BTN_HEIGHT 40
#define JZ_INPUT_HEIGHT 36
#define ShowViewHeight 60
#define ShowViewContentHeight 40
#define KWindow [UIApplication sharedApplication].keyWindow
#define KHeight [UIScreen mainScreen].bounds.size.height
#define KWidth [UIScreen mainScreen].bounds.size.width

#define KimageWidth (KWidth - 15*3-10*2-120)/3
#define KpicViewHeight KimageWidth + 20 +7
//不同键盘的高度

@interface JZKeyBoardView ()<UITextViewDelegate,JZEmojViewDelegate,JZAudionRecordManagerDelegate,JZKeyBoardToolsPanelDelegate,HPGrowingTextViewDelegate,JZShowContentViewDelegate>
{
    CGFloat _previousTextViewContentHeight;//上一次inputTextView的contentSize.height
    CGFloat _keyBoardHeight;
    
}
@property(nonatomic,strong)UIView *headerView;
@property(nonatomic,strong)UIButton *videoBtn;  //语音按钮
@property(nonatomic,strong)UIButton *emjioBtn;//表情按钮
@property(nonatomic,strong)UIButton *moreBtn;   //更多按钮
@property(nonatomic,strong)UIButton *picBtn;    //照片btn
@property(nonatomic,strong)UIButton *cameraBtn;    //相机btn

@property(nonatomic,strong)UIView *bottomView;  //底部View
@property(nonatomic,strong)JZEmojView *emojiView;   //表情View
@property(nonatomic,strong)UILabel *inputNumberLabel;   //输入的字数
@property(nonatomic,strong)UIButton *audionPressBtn;    //按住说话按钮
@property(nonatomic,strong)JZAudionRecordManager *audioManager; /* 录音组件 */
@property(nonatomic,strong)MBProgressHUD *hudTipView;   //提示View
@property(nonatomic,strong)JZKeyBoardToolsPanelView *moreView;  //工具面板
@property(nonatomic,strong)UIButton *completeBtn;   //完成按钮
@property(nonatomic,assign)JZKeyBoardViewType boardType;
@property(nonatomic,strong)JZShowContentView *showContentView;  //输入内容view
@property(nonatomic,assign)CGFloat showTextHeight;  //输入内容文字高度
@property(nonatomic,assign)CGFloat showPicHeight;   //输入内容图片高度
@property(nonatomic,assign)CGFloat showContentHeight;
@property(nonatomic,strong)UILabel *countLimitLabel;//倒计数
@property(nonatomic,assign)BOOL isBrowse;   //是否在浏览大图
@property(nonatomic,assign)CGFloat changeTextHeight;
@end

@implementation JZKeyBoardView



- (instancetype)initWithFrame:(CGRect)frame withViewType:(JZKeyBoardViewType)viewType
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        self.boardType = viewType;
        self.headerHeight = frame.size.height;
        [self makeConstraints_withViewType:viewType];
    }
    
    return self;
}

- (void)initData
{
    self.backgroundColor = JZ_KMainColor;
    self.placHolder = @"说点什么吧";
    self.isShowSendBtn = YES;
    self.isShowGrayLayer = YES;
    self.isShowHeaderContentView = YES;
    self.isBrowse = NO;
    self.maxLimitNumber = 100;
    _keyBoardHeight = 0;
    _showTextHeight = 0;
    _showPicHeight = 0;
    _showContentHeight = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    [self initAudioRecord];
    
}
#pragma mark - 录音管理
- (void)initAudioRecord
{
    
    _audioManager = [JZAudionRecordManager shareInstance];
    _audioManager.delegate = self;
    _audioManager.limitMaxRecordDuration = 60.0f;
    
}
/**
 * 背景色
 */

#pragma mark - 约束
- (void)makeConstraints_withViewType:(JZKeyBoardViewType)viewType{
    [self addSubview:self.showContentView];
    //    self.currentTextView = _showContentView.contentTextView;
    _showContentView.contentHeight = 0;
    self.changeTextHeight = 0;
    [_showContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.top.mas_equalTo(self.mas_top);
        make.height.mas_offset(0);
    }];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.top.mas_equalTo(_showContentView.mas_bottom);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_offset(self.headerHeight);
    }];
    UILabel *topLine = [[UILabel alloc]init];
    topLine.backgroundColor = UIColorFromHex(0xe6e6e6);
    UILabel *bottomLine = [[UILabel alloc]init];
    bottomLine.backgroundColor = UIColorFromHex(0xe6e6e6);
    [self.headerView addSubview:bottomLine];
    [self.headerView addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headerView.mas_left);
        make.right.mas_equalTo(_headerView.mas_right);
        make.top.mas_equalTo(_headerView.mas_top);
        make.height.mas_offset(0.5);
    }];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headerView.mas_left);
        make.right.mas_equalTo(self.headerView.mas_right);
        make.bottom.mas_equalTo(self.headerView.mas_bottom);
        make.height.mas_offset(0.5);
    }];
    
    
    [self.emojiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.top.mas_equalTo(self.headerView.mas_bottom);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    [self.moreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.top.mas_equalTo(self.headerView.mas_bottom);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    
    switch (viewType) {
        case JZKeyBoardViewDefault:
        {
            
            [self.videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.headerView.mas_left).mas_offset(10);
                make.top.mas_equalTo(self.headerView).mas_offset((self.headerHeight - JZ_BTN_HEIGHT)/2);
                make.width.mas_offset(JZ_BTN_HEIGHT);
                make.height.mas_offset(JZ_BTN_HEIGHT);
            }];
            [self.inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.videoBtn.mas_right).mas_offset(10);
                make.top.mas_equalTo(self.headerView.mas_top).mas_offset((self.headerHeight- JZ_INPUT_HEIGHT)/2);
                make.height.mas_offset(JZ_INPUT_HEIGHT);
                make.width.mas_offset(SCREEN_WIDTH - (10+JZ_INPUT_HEIGHT)*3- 10*2);
            }];
            [self.emjioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.inputTextView.mas_right).mas_offset(10);
                make.top.mas_equalTo(self.videoBtn.mas_top);
                make.width.mas_offset(JZ_BTN_HEIGHT);
                make.height.mas_offset(JZ_BTN_HEIGHT);
            }];
            [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.emjioBtn.mas_right).mas_offset(10);
                make.top.mas_equalTo(self.emjioBtn.mas_top);
                make.width.mas_offset(JZ_BTN_HEIGHT);
                make.height.mas_offset(JZ_BTN_HEIGHT);
            }];
            [self.audionPressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.inputTextView.mas_left);
                make.right.mas_equalTo(self.inputTextView.mas_right);
                make.top.mas_equalTo(self.inputTextView.mas_top);
                make.height.mas_offset(JZ_INPUT_HEIGHT);
            }];
            break;
        }
        case JZKeyBoardViewEmoji_Input_More:
        {
            [self.emjioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.headerView.mas_left).mas_offset(15);
                make.top.mas_equalTo(self.headerView.mas_top).mas_offset((self.headerHeight - JZ_BTN_HEIGHT)/2);
                make.width.mas_offset(JZ_BTN_HEIGHT);
                make.height.mas_offset(JZ_BTN_HEIGHT);
            }];
            [self.inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.emjioBtn.mas_right).mas_offset(15);
                make.top.mas_equalTo(self.headerView.mas_top).mas_offset((self.headerHeight- JZ_INPUT_HEIGHT)/2);
                make.height.mas_offset(JZ_INPUT_HEIGHT);
                make.width.mas_offset(SCREEN_WIDTH - (15+JZ_INPUT_HEIGHT)*2- 15*2);
            }];
            [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.inputTextView.mas_right).mas_offset(15);
                make.top.mas_equalTo(self.emjioBtn.mas_top);
                make.width.mas_offset(JZ_BTN_HEIGHT);
                make.height.mas_offset(JZ_BTN_HEIGHT);
            }];
            break;
        }
        case JZKeyBoardViewInput_Emoji_More://输入框+表情+更多
        {
            
            [self.showContentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(_showContentHeight);
            }];
            self.showContentView.isHidenLabel = YES;
            
            [self.blackView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(KWindow.mas_left);
                make.right.mas_equalTo(KWindow.mas_right);
                make.top.mas_equalTo(KWindow.mas_top);
                make.height.mas_offset(0);
            }];
            [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.headerView.mas_right);
                make.top.mas_equalTo(self.headerView.mas_top).mas_offset((self.headerHeight - JZ_BTN_HEIGHT)/2);
                make.width.mas_equalTo(JZ_BTN_HEIGHT);
                make.height.mas_equalTo(JZ_BTN_HEIGHT);
            }];
            
            [self.emjioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.moreBtn.mas_left);
                make.top.mas_equalTo(self.headerView.mas_top).mas_offset((self.headerHeight - JZ_BTN_HEIGHT)/2);
                make.width.mas_equalTo(JZ_BTN_HEIGHT);
                make.height.mas_equalTo(JZ_BTN_HEIGHT);
            }];
            [self.inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.headerView.mas_left).mas_offset(10);
                make.top.mas_equalTo(self.headerView.mas_top).mas_offset((self.headerHeight- JZ_INPUT_HEIGHT)/2);
                make.height.mas_offset(JZ_INPUT_HEIGHT);
                make.right.mas_equalTo(self.emjioBtn.mas_left).mas_offset(-15);
            }];
            break;
        }
        case JZKeyBoardViewPic_Carmera_Emoji_Send://图片+相机+表情
        {
            _showContentView.isHidenLabel = YES;
            [self.showContentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(_showContentHeight);
            }];
            
            
            [self.blackView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(KWindow.mas_left);
                make.right.mas_equalTo(KWindow.mas_right);
                make.top.mas_equalTo(KWindow.mas_top);
                make.height.mas_offset(0);
            }];
            [self.picBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.mas_left);
                make.top.mas_equalTo(self.headerView.mas_top).mas_offset((self.headerHeight - JZ_BTN_HEIGHT)/2);
                make.width.mas_offset(JZ_BTN_HEIGHT);
                make.height.mas_offset(JZ_BTN_HEIGHT);
            }];
            [self.cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.picBtn.mas_right);
                make.top.mas_equalTo(self.picBtn.mas_top);
                make.width.mas_offset(JZ_BTN_HEIGHT);
                make.height.mas_offset(JZ_BTN_HEIGHT);
            }];
            [self.emjioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.headerView.mas_right);
                make.top.mas_equalTo(self.cameraBtn.mas_top);
                make.width.mas_offset(JZ_BTN_HEIGHT);
                make.height.mas_offset(JZ_BTN_HEIGHT);
            }];
            break;
        }
        case JZKeyBoardViewRecordEmoji_Send://输入框+表情
        {
            
            [self.showContentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(_showContentHeight);
            }];
            self.showContentView.isHidenLabel = YES;
            
            [self.blackView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(KWindow.mas_left);
                make.right.mas_equalTo(KWindow.mas_right);
                make.top.mas_equalTo(KWindow.mas_top);
                make.height.mas_offset(0);
            }];
            [self.emjioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.headerView.mas_right);
                make.top.mas_equalTo(self.headerView.mas_top).mas_offset((self.headerHeight - JZ_BTN_HEIGHT)/2);
                make.width.mas_equalTo(JZ_BTN_HEIGHT);
                make.height.mas_equalTo(JZ_BTN_HEIGHT);
            }];
            [self.inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.headerView.mas_left).mas_offset(10);
                make.right.mas_equalTo(self.emjioBtn.mas_left).mas_offset(-15);
                make.top.mas_equalTo(self.headerView.mas_top).mas_offset((self.headerHeight- JZ_INPUT_HEIGHT)/2);
                make.height.mas_equalTo(JZ_INPUT_HEIGHT);
            }];
            break;
        }
        case JZKeyBoardViewRecordEmoji://表情
        {
            [self.showContentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(self->_showContentHeight);
            }];
            self.showContentView.isHidenLabel = YES;
            
            [self.blackView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(KWindow.mas_left);
                make.right.mas_equalTo(KWindow.mas_right);
                make.top.mas_equalTo(KWindow.mas_top);
                make.height.mas_offset(0);
            }];
            [self.emjioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.headerView.mas_right);
                make.top.mas_equalTo(self.headerView.mas_top).mas_offset((self.headerHeight - JZ_BTN_HEIGHT)/2);
                make.width.mas_equalTo(JZ_BTN_HEIGHT);
                make.height.mas_equalTo(JZ_BTN_HEIGHT);
            }];
            
            self.inputTextView.hidden = YES;
            break;
        }
        default:
            break;
    }
}

#pragma mark - 点击抹灰层
- (void)tapClick:(UITapGestureRecognizer *)sender
{
    //    [_showPicArray removeAllObjects];
    //    _showContentView.picHeight = 0;
    //    _showPicHeight = 0;
    //    _showTextHeight = 40;
    //    _showContentHeight = _showTextHeight + 20+_showPicHeight;
    //    _showContentView.contentTextView.text = nil;
    //    _showContentView.picsArray = nil;
    //    _inputTextView.placeholder = self.placHolder;
    
    [self keyBoardViewHiden];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyBoardView:clickBlackView:)]) {
        [self.delegate keyBoardView:self clickBlackView:self.blackView];
    }
    
}

#pragma mark -按钮点击事件
- (void)btnAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    switch (sender.tag) {
        case JZKeyBoardView_Emoji:
        {
            _moreView.hidden = YES;;
            _inputTextView.hidden = NO;
            _audionPressBtn.hidden = YES;
            if (sender.selected) {
                _emojiView.hidden = NO;
                _keyBoardHeight = JZ_EmojiKeyBoardHeight;
                [sender setImage:[UIImage imageNamed:@"chat_toolbar_keyboard_nor"] forState:UIControlStateNormal];
                _moreBtn.selected = NO;
                if (_videoBtn.selected) {//如果此时处于录音状态,切换成文字输入状态
                    _videoBtn.selected = NO;
                    [_videoBtn setImage:[UIImage imageNamed:@"chat_toolbar_voice_nor"] forState:UIControlStateNormal];
                    
                }else{//如果是文字输入状态,使输入框失去焦点
                    [self.inputTextView resignFirstResponder];
                    
                }
                if (![self.inputTextView resignFirstResponder]) {
                    
                    [UIView animateWithDuration:0.25 animations:^{
                        _showContentHeight = _showPicHeight;
                        [self mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.height.mas_offset(JZ_EmojiKeyBoardHeight+self.headerHeight+_showContentHeight+self.changeTextHeight);
                            make.bottom.mas_offset(0);
                        }];
                        [_showContentView mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.height.mas_offset(_showContentHeight);
                        }];
                        [_blackView mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.height.mas_offset(KHeight - (JZ_EmojiKeyBoardHeight+self.headerHeight+_showContentHeight+self.changeTextHeight));
                        }];
                    }];
                    if (self.delegate && [self.delegate respondsToSelector:@selector(keyBoardView:didChangeKeyBoardHeight:)]) {
                        [self.delegate keyBoardView:self didChangeKeyBoardHeight:JZ_EmojiKeyBoardHeight+self.headerHeight];
                    }
                }
            }else{
                _emojiView.hidden = YES;
                [sender setImage:[UIImage imageNamed:@"mjl_keyboardEmoji"] forState:UIControlStateHighlighted];
                [sender setImage:[UIImage imageNamed:@"mjl_keyboardEmoji"] forState:UIControlStateNormal];
                [self.inputTextView becomeFirstResponder];
            }
            break;
        }
        case JZKeyBoardView_Record:
        {
            _emojiView.hidden = YES;
            if (sender.selected) {
                if (_emjioBtn.selected) {
                    _emjioBtn.selected = NO;
                    [_emjioBtn setImage:[UIImage imageNamed:@"mjl_keyboardEmoji"] forState:UIControlStateNormal];
                }
                if (_moreBtn.selected) {
                    _moreBtn.selected = NO;
                }
                [sender setImage:[UIImage imageNamed:@"chat_toolbar_keyboard_nor"] forState:UIControlStateNormal];
                self.inputTextView.hidden = YES;
                [self.inputTextView resignFirstResponder];
                _audionPressBtn.hidden = NO;
                if (![self.inputTextView resignFirstResponder]) {
                    
                    [UIView animateWithDuration:0.25 animations:^{
                        [self mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.height.mas_offset(JZHEADERHEIGHT);
                            make.bottom.mas_offset(0);
                        }];
                        [_showContentView mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.height.mas_offset(_showContentHeight);
                        }];
                        [self.blackView mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.height.mas_offset(0);
                        }];
                    }];
                    if (self.delegate && [self.delegate respondsToSelector:@selector(keyBoardView:didChangeKeyBoardHeight:)]) {
                        [self.delegate keyBoardView:self didChangeKeyBoardHeight:JZHEADERHEIGHT];
                    }
                }
            }else{
                [sender setImage:[UIImage imageNamed:@"chat_toolbar_voice_nor"] forState:UIControlStateNormal];
                [sender setImage:[UIImage imageNamed:@"chat_toolbar_voice_press"] forState:UIControlStateHighlighted];
                self.inputTextView.hidden = NO;
                _audionPressBtn.hidden = YES;
                [self.inputTextView becomeFirstResponder];
                
            }
            
            break;
        }
        case JZKeyBoardView_More:
        {
            _emojiView.hidden = YES;
            if (sender.selected) {
                if (_emjioBtn.selected) {
                    _emjioBtn.selected = NO;
                }
                if (_videoBtn.selected) {
                    _videoBtn.selected = NO;
                }
                [self.inputTextView resignFirstResponder];
                if (![self.inputTextView resignFirstResponder]) {
                    
                    [UIView animateWithDuration:0.25 animations:^{
                        _showContentHeight = _showPicHeight;
                        [self mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.height.mas_offset(JZ_MoreToolKeyBoardHeight+self.headerHeight+_showContentHeight+self.changeTextHeight);
                            make.bottom.mas_offset(0);
                        }];
                        [_showContentView mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.height.mas_offset(_showContentHeight);
                        }];
                        [_blackView mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.height.mas_offset(KHeight - (JZ_MoreToolKeyBoardHeight+self.headerHeight+_showContentHeight+self.changeTextHeight));
                        }];
                    }];
                    if (self.delegate && [self.delegate respondsToSelector:@selector(keyBoardView:didChangeKeyBoardHeight:)]) {
                        [self.delegate keyBoardView:self didChangeKeyBoardHeight:JZ_MoreToolKeyBoardHeight+self.headerHeight];
                    }
                }
                _moreView.hidden = NO;
            }else{
                _inputTextView.hidden = NO;
                [self.inputTextView becomeFirstResponder];
                _moreView.hidden = YES;
                _audionPressBtn.hidden = YES;
            }
            break;
        }
        case JZKeyBoardView_Pic:
        {
            [JZSystemUtils assetsAuthorizationStatusAuthorized:^{
                if (self.delegate && [self.delegate respondsToSelector:@selector(keyBoardView:btnSelectedAction:)]) {
                    [self.delegate keyBoardView:self btnSelectedAction:JZKeyBoardView_Pic];
                }
                
                
                [self keyBoardViewHiden];
                [_blackView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_offset(0);
                }];
                [self.inputTextView resignFirstResponder];
            } restricted:^{
                NSString * message = [NSString stringWithFormat:@"请在iPhone的\"设置-隐私-照片\"选项中，\r允许\"%@\"访问你的手机相册",[JZSystemUtils getTheAppName]];
                [JZAlertHUD alertShowTitle:@"没有权限访问" message:message otherButtonTitle:@"确定" continueBlock:^{
                    [JZSystemUtils openSystemSetting];
                    
                }];
            }];
            
            break;
        }
        case JZKeyBoardView_Finish:
        {
            [self.inputTextView resignFirstResponder];
            if (self.delegate && [self.delegate respondsToSelector:@selector(keyBoardViewSendBtnActionWithTitle:)]) {
                [self.delegate keyBoardViewSendBtnActionWithTitle:self.currentTextView.text];
                [self cleanInputTextStr];
            }
            
            if (![self.inputTextView resignFirstResponder]) {
                [self.showPicArray removeAllObjects];
                _showContentHeight = 0;
                [self mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_offset(0);
                    make.height.mas_offset(self.headerHeight+_showContentHeight+self.changeTextHeight);
                }];
                _showContentView.picHeight = 0;
                _showContentView.picsArray = nil;
                _showPicHeight = 0;
                [_showContentView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_offset(_showContentHeight);
                }];
                [_blackView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_offset(0);
                }];
            }
            _emojiView.hidden = YES;
            _moreView.hidden = YES;
            break;
        }
        case JZKeyBoardView_Camera:
        {
            [JZSystemUtils videoAuthorizationStatusAuthorized:^{
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(keyBoardView:btnSelectedAction:)]) {
                    [self.delegate keyBoardView:self btnSelectedAction:JZKeyBoardView_Camera];
                }
                [self keyBoardViewHiden];
                [self.inputTextView resignFirstResponder];
                
            } restricted:^{
                NSString * message = [NSString stringWithFormat:@"请在iPhone的\"设置-隐私-相机\"选项中，\r允许\"%@\"访问你的相机",[JZSystemUtils getTheAppName]];
                [JZAlertHUD alertShowTitle:@"没有权限访问" message:message otherButtonTitle:@"确定" continueBlock:^{
                    [JZSystemUtils openSystemSetting];
                }];
            }];
            break;
        }
        default:
            break;
    }
}

#pragma mark -通知
- (void)keyboardWillHide:(NSNotification *)notification
{
    
    CGFloat keyHeight = 0.0;
    if (_emjioBtn.selected) {
        
        [UIView animateWithDuration:0.25 animations:^{
            _showContentHeight = _showPicHeight;
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_offset(0);
                make.height.mas_offset(JZ_EmojiKeyBoardHeight+self.headerHeight+_showContentHeight+self.changeTextHeight);
            }];
            [_showContentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(_showContentHeight);
            }];
            [_blackView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(KHeight - (JZ_EmojiKeyBoardHeight+self.headerHeight+_showContentHeight+self.changeTextHeight));
            }];
        }];
        keyHeight = JZ_EmojiKeyBoardHeight+self.headerHeight;
    }else if (_videoBtn.selected){
        
        [UIView animateWithDuration:0.25 animations:^{
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_offset(0);
                make.height.mas_offset(JZHEADERHEIGHT);
            }];
            _showContentHeight = 0;
            [_showContentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(_showContentHeight);
            }];
            [_blackView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(0);
            }];
        }];
        keyHeight = JZHEADERHEIGHT;
    }else if (_moreBtn.selected){
        
        [UIView animateWithDuration:0.25 animations:^{
            _showContentHeight = _showPicHeight;
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_offset(0);
                make.height.mas_offset(JZ_MoreToolKeyBoardHeight+self.headerHeight+_showContentHeight+self.changeTextHeight);
            }];
            [_showContentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(_showContentHeight);
            }];
            [_blackView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(KHeight - (JZ_MoreToolKeyBoardHeight+self.headerHeight+_showContentHeight+self.changeTextHeight));
            }];
        }];
        keyHeight = JZ_MoreToolKeyBoardHeight+self.headerHeight;
    }else{
        _emojiView.hidden = YES;
        
        if (_showPicArray.count > 0) {
            [UIView animateWithDuration:0.25 animations:^{
                [self mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_offset(0);
                    make.height.mas_offset(self.headerHeight+_showContentHeight+self.changeTextHeight);
                }];
                
                [_showContentView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_offset(_showContentHeight);
                }];
                if (self.isBrowse) {
                    [_blackView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_offset(0);
                    }];
                }else{
                    [_blackView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_offset(KHeight - (self.headerHeight+_showContentHeight+self.changeTextHeight));
                    }];
                }
                
            }];
            
            
            keyHeight = self.headerHeight;
        }else{
            
            [UIView animateWithDuration:0.25 animations:^{
                
                [self mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_offset(0);
                    make.height.mas_offset(self.headerHeight+_showContentHeight+self.changeTextHeight);
                }];
                [_showContentView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_offset(_showContentHeight);
                }];
                [_blackView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_offset(0);
                }];
            }];
            
            
            keyHeight = self.headerHeight;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(keyBoardViewWillDown:)]) {
            [self.delegate keyBoardViewWillDown:self];
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyBoardView:didChangeKeyBoardHeight:)]) {
        [self.delegate keyBoardView:self didChangeKeyBoardHeight:keyHeight];
    }
    
    
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    _blackView.hidden = NO;
    [_emjioBtn setImage:[UIImage imageNamed:@"mjl_keyboardEmoji"] forState:UIControlStateNormal];
    _emjioBtn.selected = NO;
    NSValue *aValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    _keyBoardHeight = keyboardRect.size.height;
    [UIView animateWithDuration:0.25 animations:^{
        _showContentHeight = _showPicHeight;
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(_keyBoardHeight + self.headerHeight + _showContentHeight+self.changeTextHeight);
            make.bottom.mas_offset(0);
        }];
        [_showContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(_showContentHeight);
        }];
        [self.blackView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(KHeight - (_keyBoardHeight + self.headerHeight + _showContentHeight+self.changeTextHeight));
            
        }];
    }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyBoardView:didChangeKeyBoardHeight:)]) {
        [self.delegate keyBoardView:self didChangeKeyBoardHeight:_keyBoardHeight + self.headerHeight+_showContentHeight];
    }
}

- (void)keyBoardViewHiden
{
    _blackView.hidden = YES;
    _keyBoardHeight = 0;
    [self layoutIfNeeded];
    
    if (_showPicArray.count>0) {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(self.headerHeight+_showContentHeight+self.changeTextHeight);
            make.bottom.mas_offset(0);
        }];
        [_showContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(_showContentHeight);
        }];
        [_blackView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(KHeight - (self.headerHeight+_showContentHeight+self.changeTextHeight));
            
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_offset(0);
                make.height.mas_offset(self.headerHeight+_showContentHeight+self.changeTextHeight);
            }];
            [_showContentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(_showContentHeight);
            }];
            [_blackView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(0);
            }];
            [self layoutIfNeeded];
            
        }];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyBoardView:didChangeKeyBoardHeight:)]) {
        [self.delegate keyBoardView:self didChangeKeyBoardHeight:self.headerHeight];
    }
    [_emjioBtn setImage:[UIImage imageNamed:@"mjl_keyboardEmoji"] forState:UIControlStateNormal];
    [_videoBtn setImage:[UIImage imageNamed:@"chat_toolbar_voice_nor"] forState:UIControlStateNormal];
    
    [self.inputTextView resignFirstResponder];
    _emojiView.hidden = YES;
    _moreView.hidden = YES;
    _emjioBtn.selected = NO;
    _videoBtn.selected = NO;
    _moreBtn.selected = NO;
}



#pragma mark -TextViewDelegate

- (void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView
{
    _emojiView.hidden = YES;
    [growingTextView becomeFirstResponder];
    [_emjioBtn setImage:[UIImage imageNamed:@"mjl_keyboardEmoji"] forState:UIControlStateNormal];
    _emjioBtn.selected = NO;
    _moreBtn.selected = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyBoardViewTextViewDidBeginEditing:)]) {
        [self.delegate keyBoardViewTextViewDidBeginEditing:growingTextView];
    }
}


- (void)growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView
{
    [growingTextView resignFirstResponder];
}

- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyBoardViewSendBtnActionWithTitle:)]) {
        [self.delegate keyBoardViewSendBtnActionWithTitle:growingTextView.text];
        [self cleanInputTextStr];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyBoardViewSendText:)]) {
        
        [self.delegate keyBoardViewSendText:self.inputTextView.text];
        [self cleanInputTextStr];
        
    }
    
    self.changeTextHeight = 0;
    [self keyBoardViewHiden];
    [self.inputTextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(JZ_INPUT_HEIGHT);
    }];
    [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.headerHeight);
    }];
    
    [self.showContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(JZHEADERHEIGHT);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    [self.inputTextView resignFirstResponder];
    return YES;
    
    
}



- (void)growingTextView:(HPGrowingTextView *)growingTextView didChangeHeight:(float)height
{
    //    _showContentHeight =_showPicHeight;
    //    self.changeTextHeight = height - JZ_INPUT_HEIGHT;
    //    [self.inputTextView mas_updateConstraints:^(MASConstraintMaker *make) {
    //        make.height.mas_equalTo(height);
    //    }];
    //    [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
    //        make.height.mas_equalTo(self.headerHeight+self.changeTextHeight);
    //    }];
    
    //    [_showContentView mas_updateConstraints:^(MASConstraintMaker *make) {
    //        make.height.mas_equalTo(_showContentHeight);
    //    }];
    //
    //    [self mas_updateConstraints:^(MASConstraintMaker *make) {
    //        make.height.mas_equalTo(_keyBoardHeight+self.headerHeight+_showContentHeight+self.changeTextHeight);
    //        make.bottom.mas_equalTo(self.mas_bottom);
    //    }];
    //
    //    if (_keyBoardHeight != 0) {
    if (height>JZ_INPUT_HEIGHT) {
        _showContentHeight =_showPicHeight;
        self.changeTextHeight = height - JZ_INPUT_HEIGHT;
        [self.inputTextView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
        [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.headerHeight+self.changeTextHeight);
        }];
        
        [_showContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(_showContentHeight);
        }];
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(_keyBoardHeight+self.headerHeight+_showContentHeight+self.changeTextHeight);
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
        
        [_blackView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(KHeight - (_keyBoardHeight+self.headerHeight+_showContentHeight+self.changeTextHeight));
            
        }];
    }else{
        //        [self.blackView mas_updateConstraints:^(MASConstraintMaker *make) {
        //            make.height.mas_equalTo(0);
        
        [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.headerHeight);
            
        }];
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(_keyBoardHeight+self.headerHeight);
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
        
    }
    if (height == JZ_INPUT_HEIGHT) {
        if (self.boardType == JZKeyBoardViewRecordEmoji_Send && self.isTopViewController) {
            _showContentHeight =_showPicHeight;
            self.changeTextHeight = height - JZ_INPUT_HEIGHT;
            [self.inputTextView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(height);
            }];
            [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(self.headerHeight+self.changeTextHeight);
            }];
            
            [_showContentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(_showContentHeight);
            }];
            
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(_keyBoardHeight+self.headerHeight+_showContentHeight+self.changeTextHeight);
                make.bottom.mas_equalTo(self.mas_bottom);
            }];
            [_blackView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(KHeight - (_keyBoardHeight+self.headerHeight+_showContentHeight+self.changeTextHeight));
            }];
        }
    }
    if (height >= 100) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(keyBoardViewDidChangeHeight:)]) {
            [self.delegate keyBoardViewDidChangeHeight:growingTextView];
        }
    }
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height {
    [self.inputTextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.headerHeight+self.changeTextHeight);
    }];
    
    [_showContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_showContentHeight);
    }];
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_keyBoardHeight+self.headerHeight+_showContentHeight+self.changeTextHeight);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
}

- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView
{
    
    if (growingTextView.text.length==0) {
        _inputTextView.placeholder = self.placHolder;
        [self.completeBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    }else{
        
        [self.completeBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    }
    if (!_currentTextView ) {
        //        [self willShowInputTextViewToHeight:[self getTextViewContentH:growingTextView]];
        if (self.delegate && [self.delegate respondsToSelector:@selector(keyBoardViewTextViewDidChange:)]) {
            [self.delegate keyBoardViewTextViewDidChange:_currentTextView];
        }
    }
    if (self.boardType == JZKeyBoardViewPic_Carmera_Emoji_Send ||self.boardType == JZKeyBoardViewRecordEmoji_Send) {
        if (self.maxLimitNumber - growingTextView.text.length <= 10 && self.maxLimitNumber - growingTextView.text.length > 0) {
            [self.countLimitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.blackView.mas_right).mas_offset(-5);
                make.bottom.mas_equalTo(self.blackView.mas_bottom).mas_offset(-5);
                make.width.mas_equalTo(35);
                make.height.mas_equalTo(20);
            }];
            self.countLimitLabel.text = [NSString stringWithFormat:@"%ld",self.maxLimitNumber - growingTextView.text.length];
            self.countLimitLabel.hidden = NO;
        }else{
            self.countLimitLabel.hidden = YES;
        }
    }
    
    
}



#pragma mark - JZEmojViewDelegate

- (void)emojiViewDeleteClick:(JZEmojView *)emojiView {
    
    
    if(JZStringIsNull(self.inputTextView.text))
    {
        return;
    }else{
        [self.inputTextView.internalTextView deleteBackward];
        
    }
    
}

- (void)emojiView:(JZEmojView *)emojiView withEmojiSelect:(JZEmojiInfo *)info {
    [self.inputTextView setMaxNumber:(int)self.maxLimitNumber];
    NSString *chatText = self.inputTextView.text;
    NSString *resultText = [NSString stringWithFormat:@"%@%@",chatText, info.emjStr];
    if (resultText.length > self.maxLimitNumber ) {
        return;
    }
    self.inputTextView.text = resultText;
}

- (void)emojiViewSendTextAction:(JZEmojView *)emojiView {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyBoardViewSendText:)]) {
        [self.delegate keyBoardViewSendText:self.inputTextView.text];
        [self cleanInputTextStr];
        
    }
}

#pragma mark -JZAudionRecordManagerDelegate

- (void)audioManager:(JZAudionRecordManager *)manager didFailedTooShortDuration:(CGFloat)minRecordDuration
{
    _hudTipView.detailsLabel.text = @"说话时间太短";
    _hudTipView.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"worning"]];
    [_hudTipView hideAnimated:YES afterDelay:0.5f];
    NSLog(@"最小录音时间失败");
}


- (void)audioManager:(JZAudionRecordManager *)manager recordFailure_withError:(NSError *)error
{
    NSLog(@"录音失败");
    _hudTipView.detailsLabel.text = @"录音失败";
    
    [_hudTipView hideAnimated:YES afterDelay:0.3f];
}


- (void)audioManager:(JZAudionRecordManager *)manager didFinishRecord_WithRecordPath:(NSString *)recordPath withDuration:(CGFloat)duration
{
    NSLog(@"录音成功:%@,录音时间:%f",recordPath,duration);
    JZAudioModel *model = [[JZAudioModel alloc]init];
    model.localStorePath = recordPath;
    model.duration = duration;
    if (self.delegate&&[self.delegate respondsToSelector:@selector(keyBoardView:recordFinish:)]) {
        [self.delegate keyBoardView:self recordFinish:model];
    }
    [_hudTipView hideAnimated:YES afterDelay:0.3f];
}


- (void)audioManager:(JZAudionRecordManager *)manager limitDurationProgress:(CGFloat)recordProgress
{
    NSLog(@"录音进度:%f",recordProgress);
}



- (void)audioManager:(JZAudionRecordManager *)manager soundMouter:(CGFloat)soundMouter
{
    if ([_hudTipView.detailsLabel.text isEqualToString:@"松开手指,取消发送"]) {
        return;
    }
    NSString *tip = [NSString stringWithFormat:@"microphone%.0f",soundMouter*10 > 5 ? 5 : soundMouter*10];
    NSLog(@"音量:%@",tip);
    
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"microphone%.0f",soundMouter*10 > 5 ? 5 : soundMouter*10]];
    if ([tip isEqualToString:@"microphone0"]) {
        image = [UIImage imageNamed:@"microphone1"];
    }
    _hudTipView.customView = [[UIImageView alloc] initWithImage:image];
}

- (void)audioManagerDidCancle:(JZAudionRecordManager *)manager
{
    NSLog(@"取消录音");
    [_hudTipView hideAnimated:YES afterDelay:0.3f];
}
#pragma mark -录音按钮点击事件
- (void)voiceButtonTouchDown
{
    if (![_audioManager checkRecordPermission]) {
        return;
    }
    [_audioManager startRecord];
    _hudTipView = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    _hudTipView.mode = MBProgressHUDModeCustomView;
    UIImage *image = [UIImage imageNamed:@"microphone1"];
    _hudTipView.customView = [[UIImageView alloc]initWithImage:image];
    _hudTipView.square = YES;
    _hudTipView.contentColor = [UIColor whiteColor];
    _hudTipView.bezelView.color = [UIColor colorWithRed:116/255 green:116/255 blue:116/255 alpha:0.66];
    _hudTipView.bezelView.layer.cornerRadius = 8;
    
    _hudTipView.detailsLabel.text = @"手指上滑,取消发送";
}
- (void)voiceButtonTouchUpOutside
{
    [_hudTipView hideAnimated:YES];
    if ([_hudTipView.detailsLabel.text isEqualToString:@"松开手指,取消发送"]) {
        
        [_audioManager cancelRecord];
    }else if ([_hudTipView.detailsLabel.text isEqualToString:@"手指上滑,取消发送"]){
        [_audioManager finishRecord];
    }
    
}
- (void)voiceButtonTouchUpInside
{
    if ([_hudTipView.detailsLabel.text isEqualToString:@"松开手指,取消发送"]) {
        
        [_audioManager cancelRecord];
    }else if ([_hudTipView.detailsLabel.text isEqualToString:@"手指上滑,取消发送"]){
        [_audioManager finishRecord];
    }
    
}
- (void)voiceDragOutside
{
    _hudTipView.detailsLabel.backgroundColor = UIColorRGB(158, 56, 54);
    _hudTipView.detailsLabel.layer.cornerRadius = 4;
    _hudTipView.detailsLabel.layer.masksToBounds = YES;
    _hudTipView.detailsLabel.text = @"松开手指,取消发送";
    _hudTipView.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cancel"]];
    
}
- (void)voiceDragInside
{
    _hudTipView.detailsLabel.backgroundColor = [UIColor clearColor];
    _hudTipView.detailsLabel.text = @"手指上滑,取消发送";
    _hudTipView.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"microphone1"]];
    
}

#pragma mark -获取当前输入框中的文字
- (NSString *)DraftText
{
    return self.inputTextView.text;
}

- (void)setDraftText:(NSString *)draftText
{
    self.inputTextView.text = draftText;
}

#pragma mark -清空输入框中内容
- (void)cleanInputTextStr
{
    self.inputTextView.text = @"";
    self.showPicArray = nil;
    [_emjioBtn setImage:[UIImage imageNamed:@"mjl_keyboardEmoji"] forState:UIControlStateNormal];
    _emjioBtn.selected = NO;
    
}

- (void)blackViewWillHiden {
    
    [self.blackView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];
}

- (void)removeBackView {
    
    [self.blackView removeFromSuperview];
}

- (void)reloadPicView {
    if (self.showPicArray.count > 0) {
        [self.blackView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(KHeight - (self.headerHeight+_showContentHeight+self.changeTextHeight));
            
        }];
    }else{
        [self.blackView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(0);
        }];
    }
    
}

#pragma mark -JZKeyBoardToolsPanelViewDelegate
- (void)jzKeyBoardToolsPanel:(JZKeyBoardToolsPanelView *)keyBoardToolView didSelectedWithItem:(NSDictionary *)itemDict withTitle:(NSString *)itemTitle
{
    if ([itemTitle isEqualToString:@"相册"]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(keyBoardView:btnSelectedAction:)]) {
            [JZSystemUtils assetsAuthorizationStatusAuthorized:^{
                [self.delegate keyBoardView:self btnSelectedAction:JZKeyBoardView_Pic];
            } restricted:^{
                NSString * message = [NSString stringWithFormat:@"请在iPhone的\"设置-隐私-照片\"选项中，\r允许\"%@\"访问你的手机相册",[JZSystemUtils getTheAppName]];
                [JZAlertHUD alertShowTitle:@"没有权限访问" message:message otherButtonTitle:@"确定" continueBlock:^{
                    [JZSystemUtils openSystemSetting];
                }];
            }];
            
        }
    }else if ([itemTitle isEqualToString:@"相机"]){
        if (self.delegate && [self.delegate respondsToSelector:@selector(keyBoardView:btnSelectedAction:)]) {
            
            [JZSystemUtils videoAuthorizationStatusAuthorized:^{
                [self.delegate keyBoardView:self btnSelectedAction:JZKeyBoardView_Camera];
            } restricted:^{
                NSString * message = [NSString stringWithFormat:@"请在iPhone的\"设置-隐私-相机\"选项中，\r允许\"%@\"访问你的相机",[JZSystemUtils getTheAppName]];
                [JZAlertHUD alertShowTitle:@"没有权限访问" message:message otherButtonTitle:@"确定" continueBlock:^{
                    [JZSystemUtils openSystemSetting];
                }];
            }];
        }
    }
}

#pragma mark - JZShowContentViewDelegate

- (void)showContentView:(JZShowContentView *)showContentView browsePicWithIndex:(NSInteger)index withImageView:(UIView *)imageView {
    
    self.isBrowse = YES;
    [self blackViewWillHiden];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyBoardView:browsePicIndex:withImageview:)]) {
        [self.delegate keyBoardView:self browsePicIndex:index withImageview:imageView];
        self.isBrowse = NO;
    }
    
    
}

- (void)showContentView:(JZShowContentView *)showContentView deletePicWithIndex:(NSInteger)index {
    [self.currentTextView resignFirstResponder];
    [self.inputTextView resignFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyBoardView:deletePicIndex:)]) {
        [self.delegate keyBoardView:self deletePicIndex:index];
    }
    
}


#pragma mark - 删除通知
- (void)removeNotication {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
}

#pragma mark - 添加通知

- (void)addKeyNotication {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    
}


#pragma mark - 懒加载

- (UIView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[UIView alloc]init];
        _headerView.layer.shadowColor = UIColorHex(0xcccccc).CGColor;
        //        _headerView.layer.shadowOffset = CGSizeMake(5, 0);
        //        _headerView.layer.shadowOpacity = 3;
        //        _headerView.layer.shadowRadius = 5;
        _headerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_headerView];
    }
    return _headerView;
}



- (UIButton *)emjioBtn
{
    if (_emjioBtn == nil) {
        _emjioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_emjioBtn setImage:[UIImage imageNamed:@"mjl_keyboardEmoji"] forState:UIControlStateNormal];
        [_emjioBtn setImage:[UIImage imageNamed:@"mjl_keyboardEmoji"] forState:UIControlStateHighlighted];
        [_emjioBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        _emjioBtn.tag = JZKeyBoardView_Emoji;
        _emjioBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.headerView addSubview:_emjioBtn];
    }
    return _emjioBtn;
}

- (UIButton *)videoBtn
{
    if (_videoBtn == nil) {
        _videoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_videoBtn setImage:[UIImage imageNamed:@"chat_toolbar_voice_nor"] forState:UIControlStateNormal];
        [_videoBtn setImage:[UIImage imageNamed:@"chat_toolbar_voice_press"] forState:UIControlStateHighlighted];
        [_videoBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        _videoBtn.tag = JZKeyBoardView_Record;
        //        _videoBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        [self.headerView addSubview:_videoBtn];
    }
    return _videoBtn;
}

- (HPGrowingTextView *)inputTextView
{
    if (_inputTextView == nil) {
        
        _inputTextView = [[HPGrowingTextView alloc]init];
        _inputTextView.returnKeyType = UIReturnKeySend;
        _inputTextView.enablesReturnKeyAutomatically = YES;//无文字就灰色不可点
        _inputTextView.placeholder = self.placHolder;
        _inputTextView.font = [UIFont systemFontOfSize:16];
        _inputTextView.backgroundColor = [UIColor whiteColor];
        _inputTextView.layer.cornerRadius = 5;
        _inputTextView.layer.masksToBounds = YES;
        //        _inputTextView.minHeight = 36;
        _inputTextView.maxHeight = 100;
        _inputTextView.delegate = self;
        [self.headerView addSubview:_inputTextView];
    }
    return _inputTextView;
}

- (UIButton *)moreBtn
{
    if (_moreBtn == nil) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setImage:[UIImage imageNamed:@"chat_toolbar_more_nor"] forState:UIControlStateNormal];
        [_moreBtn setImage:[UIImage imageNamed:@"chat_toolbar_more_press"] forState:UIControlStateHighlighted];
        [_moreBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        _moreBtn.tag = JZKeyBoardView_More;
        _moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        [self.headerView addSubview:_moreBtn];
    }
    return _moreBtn;
}

- (UIButton *)picBtn
{
    if (_picBtn == nil) {
        _picBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_picBtn setImage:[UIImage imageNamed:@"mjl_keyboardPic_nor"] forState:UIControlStateNormal];
        [_picBtn setImage:[UIImage imageNamed:@"mjl_keyboardPic_hig"] forState:UIControlStateHighlighted];
        [_picBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        _picBtn.tag = JZKeyBoardView_Pic;
        _picBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        [self.headerView addSubview:_picBtn];
    }
    return _picBtn;
}

- (UIButton *)cameraBtn {
    
    if (_cameraBtn == nil) {
        _cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cameraBtn setImage:[UIImage imageNamed:@"mjl_keyboardCarema_nor"] forState:UIControlStateNormal];
        [_cameraBtn setImage:[UIImage imageNamed:@"mjl_keyboardCarema_hig"] forState:UIControlStateHighlighted];
        [_cameraBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        _cameraBtn.tag = JZKeyBoardView_Camera;
        _cameraBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        [self.headerView addSubview:_cameraBtn];
    }
    return _cameraBtn;
}
- (UILabel *)inputNumberLabel
{
    if (_inputNumberLabel == nil) {
        _inputNumberLabel = [[UILabel alloc]init];
        _inputNumberLabel.text =[NSString stringWithFormat:@"0/%ld",self.maxLimitNumber];
        _inputNumberLabel.font = [UIFont systemFontOfSize:15];
        _inputNumberLabel.textColor = UIColorFromHex(0x999999);
        _inputNumberLabel.textAlignment = NSTextAlignmentCenter;
        _inputNumberLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(numberLabelTap:)];
        [_inputNumberLabel addGestureRecognizer:tap];
        [self.headerView addSubview:_inputNumberLabel];
    }
    return _inputNumberLabel;
}

- (void)numberLabelTap:(UITapGestureRecognizer *)sender
{
    [_currentTextView becomeFirstResponder];
}

- (JZEmojView *)emojiView
{
    if (_emojiView == nil) {
        _emojiView = [[JZEmojView alloc]init];
        _emojiView.backgroundColor = [UIColor whiteColor];
        _emojiView.delegate = self;
        _emojiView.hidden = YES;
        [self addSubview:_emojiView];
    }
    return _emojiView;
}

- (UIButton *)audionPressBtn
{
    if (_audionPressBtn == nil) {
        _audionPressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _audionPressBtn.layer.cornerRadius = 5;
        _audionPressBtn.layer.borderColor = [UIColor grayColor].CGColor;
        _audionPressBtn.layer.shadowColor = [UIColor blackColor].CGColor;
        _audionPressBtn.layer.shadowOffset = CGSizeMake(1, 1);
        _audionPressBtn.layer.borderWidth = 0.5;
        _audionPressBtn.layer.masksToBounds = YES;
        _audionPressBtn.backgroundColor = UIColorFromHex(0xeeeeee);
        [_audionPressBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
        [_audionPressBtn setTitle:@"松开 结束" forState:UIControlStateSelected];
        _audionPressBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_audionPressBtn setTitleColor:UIColorFromHex(0x333333) forState:UIControlStateNormal];
        
        [_audionPressBtn addTarget:self action:@selector(voiceButtonTouchDown) forControlEvents:UIControlEventTouchDown];
        [_audionPressBtn addTarget:self action:@selector(voiceButtonTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
        [_audionPressBtn addTarget:self action:@selector(voiceButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [_audionPressBtn addTarget:self action:@selector(voiceDragOutside) forControlEvents:UIControlEventTouchDragExit];
        [_audionPressBtn addTarget:self action:@selector(voiceDragInside) forControlEvents:UIControlEventTouchDragEnter];
        _audionPressBtn.hidden = YES;
        [self.headerView addSubview:_audionPressBtn];
    }
    return _audionPressBtn;
}

- (JZKeyBoardToolsPanelView *)moreView
{
    if (_moreView == nil) {
        _moreView = [[JZKeyBoardToolsPanelView alloc]initWithFrame:CGRectZero with_itemsArray:nil];
        _moreView.hidden = YES;
        _moreView.toolDelegate = self;
        _moreView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_moreView];
        
    }
    return _moreView;
}
- (UIButton *)completeBtn
{
    if (_completeBtn == nil) {
        _completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        _completeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        _completeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_completeBtn setTitleColor:UIColorHex(0x999999) forState:UIControlStateNormal];
        _completeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _completeBtn.tag = JZKeyBoardView_Finish;
        [_completeBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerView addSubview:_completeBtn];
    }
    return _completeBtn;
}

- (UIView *)blackView
{
    if (!_blackView) {
        _blackView = [[UIView alloc] init];
        _blackView.backgroundColor = [UIColor blackColor];
        _blackView.alpha = 0.5;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        [_blackView addGestureRecognizer:tap];
        [KWindow addSubview:_blackView];
    }
    return _blackView;
}

- (JZShowContentView *)showContentView
{
    if (_showContentView == nil) {
        _showContentView = [[JZShowContentView alloc]initWithFrame:CGRectZero];
        _showContentView.backgroundColor = [UIColor whiteColor];
        _showContentView.layer.shadowColor = UIColorHex(0xcccccc).CGColor;
        _showContentView.layer.shadowOffset = CGSizeMake(0, -3);
        _showContentView.layer.shadowOpacity = 0.3;
        _showContentView.layer.shadowRadius = 5;
        _showContentView.delegate = self;
    }
    return _showContentView;
}

- (UILabel *)countLimitLabel {
    if (!_countLimitLabel) {
        _countLimitLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _countLimitLabel.backgroundColor = [UIColor whiteColor];
        _countLimitLabel.layer.cornerRadius = 10;
        _countLimitLabel.layer.masksToBounds = YES;
        _countLimitLabel.textColor = UIColorFromRGB(0xff6f26);
        _countLimitLabel.font = [UIFont systemFontOfSize:13.0];
        _countLimitLabel.textAlignment = NSTextAlignmentCenter;
        _countLimitLabel.hidden = YES;
        [KWindow addSubview:_countLimitLabel];
        [KWindow bringSubviewToFront:_countLimitLabel];
    }
    return _countLimitLabel;
}
- (CGFloat)headerHeight
{
    if (!_headerHeight) {
        _headerHeight = JZHEADERHEIGHT;
    }
    return _headerHeight;
}
- (CGFloat)systemHeight
{
    if (!_systemHeight) {
        _systemHeight = 64;
    }
    return _systemHeight;
}

#pragma mark - setter

- (void)setCurrentTextView:(HPGrowingTextView *)currentTextView
{
    _currentTextView = currentTextView;
    _currentTextView.delegate = self;
    _inputTextView = currentTextView;
}

- (void)setInputNumber:(NSInteger)inputNumber
{
    _inputNumber = inputNumber;
    _inputNumberLabel.text = [NSString stringWithFormat:@"%ld/%ld",inputNumber,self.maxLimitNumber];
}


- (void)setMaxLimitNumber:(NSInteger)maxLimitNumber {
    _maxLimitNumber = maxLimitNumber;
    [self.currentTextView setMaxNumber:(int)maxLimitNumber];
    [self.inputTextView setMaxNumber:(int)maxLimitNumber];
    
}



- (void)setPlacHolder:(NSString *)placHolder
{
    _placHolder = placHolder;
    self.inputTextView.placeholder = placHolder;
}

- (void)setIsShowEmojiBottomToolView:(BOOL)isShowEmojiBottomToolView
{
    _isShowEmojiBottomToolView = isShowEmojiBottomToolView;
    if (!isShowEmojiBottomToolView) {
        _emojiView.isShowBottomView = NO;
    }else{
        _emojiView.isShowBottomView = YES;
    }
}

- (void)setFinishTitle:(NSString *)finishTitle
{
    _finishTitle = finishTitle;
    [_completeBtn setTitle:finishTitle forState:UIControlStateNormal];
}

- (void)setFinishTitleColor:(UIColor *)finishTitleColor
{
    _finishTitleColor = finishTitleColor;
    [_completeBtn setTitleColor:finishTitleColor forState:UIControlStateNormal];
}

- (void)setHeaderBackGroundColor:(UIColor *)headerBackGroundColor
{
    _headerBackGroundColor = headerBackGroundColor;
    self.headerView.backgroundColor = headerBackGroundColor;
}

- (void)setShowPicArray:(NSMutableArray *)showPicArray
{
    _showPicArray = showPicArray;
    _emojiView.hidden = YES;
    _moreView.hidden = YES;
    
    _showContentView.picsArray = [showPicArray mutableCopy];
    if (showPicArray.count > 0) {
        _showContentView.isHidenLabel = NO;
        _showPicHeight = KpicViewHeight;
        _showContentView.picHeight = KpicViewHeight;
        [UIView animateWithDuration:0.25 animations:^{
            
            self->_showContentHeight = self->_showPicHeight ;
            [self->_showContentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(self->_showContentHeight);
            }];
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_offset(0);
                make.height.mas_offset(self.headerHeight+self->_showContentHeight+self.changeTextHeight);
            }];
            [self.blackView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(KHeight - (self.headerHeight+self->_showContentHeight+self.changeTextHeight));
                
            }];
        }];
    }else{
        _showContentView.isHidenLabel = YES;
        
        _showPicHeight = 0;
        _showContentView.picHeight = 0;
        [UIView animateWithDuration:0.25 animations:^{
            
            self->_showContentHeight = self->_showPicHeight;
            [self->_showContentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(self->_showContentHeight);
            }];
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(self.headerHeight+self->_showContentHeight+self.changeTextHeight);
            }];
            [self.blackView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(0);
            }];
        }];
    }
    
}

- (void)setIsShowSendBtn:(BOOL)isShowSendBtn {
    _isShowSendBtn = isShowSendBtn;
    if (!isShowSendBtn) {
        _completeBtn.hidden = YES;
    }else{
        [_completeBtn setTitle:@"发送" forState:UIControlStateNormal];
        _completeBtn.hidden = NO;
    }
}

- (void)setIsShowGrayLayer:(BOOL)isShowGrayLayer {
    _isShowGrayLayer = isShowGrayLayer;
    if (!isShowGrayLayer) {
        [self.blackView removeFromSuperview];
    }
}

- (void)setIsShowHeaderContentView:(BOOL)isShowHeaderContentView {
    _isShowHeaderContentView = isShowHeaderContentView;
    if (!isShowHeaderContentView) {
        self.showContentView.hidden = YES;
        self.showContentHeight = 0;
        [self.showContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(0);
        }];
    }
}

- (void)dealloc{
    NSLog(@"释放");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.blackView removeFromSuperview];
}

@end

