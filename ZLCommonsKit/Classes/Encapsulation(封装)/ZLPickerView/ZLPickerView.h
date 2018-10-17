//
//  ZLPickerView.h
//  PickerViewDemo
//
//  Created by wangjingfei on 2017/10/18.
//  Copyright © 2017年 wangjingfei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZLPickerView;

@interface ZLIndexPath : NSObject

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

@protocol ZLPickerViewDelegate<NSObject>

//点击代理  点击了第column列 或者 第row 行
- (void)pickerView:(ZLPickerView *)menuView disSelectRowAtIndexPaths:(NSArray<ZLIndexPath *>*)indexPathArray;

//点击取消按钮
- (void)pickerView:(ZLPickerView *)menuView ClickCancel:(UIButton *)cancel;

@optional
//返回 menu 第column列 第row行 的单元格的高度
- (CGFloat)pickerView:(ZLPickerView *)menuView heightForRowAtIndexPath:(ZLIndexPath *)indexPath;

@end

@protocol ZLPickerViewDataSource<NSObject>

//返回 第column列有多少行
- (NSInteger)pickerView:(ZLPickerView *)menuView numberOfRowInColumn:(ZLIndexPath *)indexPath;

//返回 第row行的数据
- (NSString *)pickerView:(ZLPickerView *)menuView dataForRowAtIndexPath:(ZLIndexPath *)indexPath;

@optional

//返回多少列  默认是1列
- (NSInteger)numberOfColumnInMenu:(ZLPickerView *)menuView;

@end

@interface ZLPickerView : UIView

@property (nonatomic,weak) id<ZLPickerViewDataSource> dataSource;

@property (nonatomic,weak) id<ZLPickerViewDelegate> delegate;

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
