//
//  JZPickerView.h
//  PickerViewDemo
//
//  Created by wangjingfei on 2017/10/18.
//  Copyright © 2017年 wangjingfei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JZPickerView;

@interface JZIndexPath : NSObject

//列数   ----
@property (nonatomic,assign) NSInteger column;
//行数
@property (nonatomic,assign) NSInteger row;
//前一列选中的行数
@property (nonatomic,assign) NSInteger currenSelectIndex;

- (instancetype)initWithColumn:(NSInteger)column withRow:(NSInteger)row;

+ (instancetype)indexPathWithColumn:(NSInteger)column withRow:(NSInteger)row;

+ (instancetype)indexPathWithColumn:(NSInteger)col withRow:(NSInteger)row withItem:(NSInteger)item;

@end

@protocol JZPickerViewDelegate<NSObject>

//点击代理  点击了第column列 或者 第row 行
- (void)pickerView:(JZPickerView *)menuView disSelectRowAtIndexPaths:(NSArray<JZIndexPath *>*)indexPathArray;

//点击取消按钮
- (void)pickerView:(JZPickerView *)menuView ClickCancel:(UIButton *)cancel;

@optional
//返回 menu 第column列 第row行 的单元格的高度
- (CGFloat)pickerView:(JZPickerView *)menuView heightForRowAtIndexPath:(JZIndexPath *)indexPath;

@end

@protocol JZPickerViewDataSource<NSObject>

//返回 第column列有多少行
- (NSInteger)pickerView:(JZPickerView *)menuView numberOfRowInColumn:(JZIndexPath *)indexPath;

//返回 第row行的数据
- (NSString *)pickerView:(JZPickerView *)menuView dataForRowAtIndexPath:(JZIndexPath *)indexPath;

@optional

//返回多少列  默认是1列
- (NSInteger)numberOfColumnInMenu:(JZPickerView *)menuView;

@end

@interface JZPickerView : UIView

@property (nonatomic,weak) id<JZPickerViewDataSource> dataSource;

@property (nonatomic,weak) id<JZPickerViewDelegate> delegate;

//抹灰层是否可点击  默认是不可以的
@property (nonatomic, assign) BOOL isTouch;

//显示
- (void)showPickView:(id)currentSelf;

//隐藏
- (void)hidePickeView;


//取消按钮
@property (nonatomic,strong) UIButton *cancleBtn;

//确认按钮
@property (nonatomic,strong) UIButton *sureBtn;

//第一个Column选中位置
@property (nonatomic,assign) NSInteger firstColumnSelectIndex;

@end
