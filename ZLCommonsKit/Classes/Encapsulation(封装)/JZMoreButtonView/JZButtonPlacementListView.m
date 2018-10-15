//
//  JZButtonPlacementListView.m
//  JZViewDemo
//
//  Created by wangjingfei on 2017/9/4.
//  Copyright © 2017年 wangjingfei. All rights reserved.
//

#import "JZButtonPlacementListView.h"
#import "UIButton+Layout.h"
#import "Masonry.h"

#define buttonTag 999900
@interface JZButtonPlacementListView ()

//按钮的数组
@property (nonatomic,strong) NSMutableArray *dataItemArray;

@end
@implementation JZButtonPlacementListView

- (instancetype)initWithFrame:(CGRect)frame withButtonItem:(NSArray *)itemArray
{
    self = [super initWithFrame:frame];
    if (self) {
        _dataItemArray = [NSMutableArray arrayWithArray:itemArray];
        _btnSpace = 10.0f;
        [self createButtonSubViews];
    }
    return self;
}
//创建按钮
- (void)createButtonSubViews
{
    //创建按钮
    for (int i = 0; i < _dataItemArray.count; i++) {
        JZButtonItemModel *itemModel = [_dataItemArray objectAtIndex:i];
        JZThumbUpButton *thumbBtn = [JZThumbUpButton buttonWithType:UIButtonTypeCustom];
        thumbBtn.tag = buttonTag + i;
        NSString *imageName = [self returnsTheImageOfTheButtonAccordingToTheEnumerationValue:itemModel.btnDisplayType];
        [thumbBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        //图片的位置
        thumbBtn.imageRect = CGRectMake(0, itemModel.btnSize.height - 20, 20, 20);
        //汉字的位置
        thumbBtn.titleRect = CGRectMake(15, itemModel.btnSize.height - 20 - 12, itemModel.btnSize.width - 15, 12.0f);
        //汉字的颜色
        [thumbBtn setTitleColor:(UIColor *)itemModel.btnTitleColor forState:UIControlStateNormal];
        
        thumbBtn.backgroundColor = [UIColor whiteColor];
        //字体大小
        thumbBtn.titleLabel.font = [UIFont systemFontOfSize:itemModel.btnTitleSize];
        //点击事件
        [thumbBtn addTarget:self action:@selector(thumbUpButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:thumbBtn];
        
        //大小
        [thumbBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).mas_offset(-15 - (itemModel.btnSize.width + _btnSpace) * (_dataItemArray.count - (i + 1)));
            make.centerY.mas_equalTo(self.mas_centerY).mas_offset(0);
            make.size.mas_equalTo(itemModel.btnSize);
        }];

    }
}
//根据枚举值返回按钮的图片
- (NSString *)returnsTheImageOfTheButtonAccordingToTheEnumerationValue:(JZButtonDisplayType)btnDisplayType
{
    switch (btnDisplayType) {
        case JZButtonDisplayTypeExceptional:
            return @"wjf_dynamic_07";
            break;
        case JZButtonDisplayTypeSendGifts:
            return @"wjf_dynamic_09";
            break;
        case JZButtonDisplayTypeComment:
            return @"wjf_dynamic_11";
            break;
        case JZButtonDisplayTypeThumbUp:
            return @"wjf_dynamic_13";
            break;
            
        default:
            break;
    }
}
- (void)setLeftView:(UIView *)leftView
{
    _leftView = leftView;
    if (_leftView) {
        [self addSubview:_leftView];
    }
}
- (void)setBtnSpace:(CGFloat)btnSpace
{
    _btnSpace = btnSpace;
    [_dataItemArray enumerateObjectsUsingBlock:^(JZButtonItemModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JZThumbUpButton *selectBtn = [self viewWithTag:buttonTag + idx];
        [selectBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).mas_offset(-15 - (obj.btnSize.width + _btnSpace) * (_dataItemArray.count - (idx + 1)));
        }];
    }];
}
#pragma mark -按钮的点击事件
- (void)thumbUpButtonClick:(JZThumbUpButton *)thumbBtn
{
    JZButtonItemModel *itemModel = [_dataItemArray objectAtIndex:(thumbBtn.tag - buttonTag)];
    if (_delegate && [_delegate respondsToSelector:@selector(clickButton:withClickButtonType:)]) {
        [_delegate clickButton:thumbBtn withClickButtonType:itemModel.btnDisplayType];
    }
}

//修改按钮上的字 图片
- (void)modifyTheWordImageOnTheButton:(NSString *)titleName withButtonImage:(NSString *)imageName withButtonTitleColor:(UIColor *)titleColor withCurrentButtonType:(JZButtonDisplayType)btnDisplayType
{
    [_dataItemArray enumerateObjectsUsingBlock:^(JZButtonItemModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.btnDisplayType == btnDisplayType) {
            JZThumbUpButton *selectBtn = [self viewWithTag:buttonTag + idx];
            [selectBtn selectCurrentBtnImgChange:imageName withBtnTitltColor:titleColor withCurrentBtnTitleChange:titleName];
            *stop = YES;
        }
    }];
}
@end
