//
//  JZPickerView.m
//  PickerViewDemo
//
//  Created by wangjingfei on 2017/10/18.
//  Copyright © 2017年 wangjingfei. All rights reserved.
//

#import "JZPickerView.h"
#import <YYKit.h>
#import "Masonry.h"



@interface JZPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>

//头部
@property (nonatomic,strong) UIView *topView;


//选择框
@property (nonatomic,strong) UIPickerView *pickerView;

//列数
@property (nonatomic,assign) NSInteger numOfMenu;

//选中的数据
@property (nonatomic,strong) JZIndexPath *selectIndexPath;

@property (nonatomic,strong) NSMutableArray *selectDataArray;

@end

@implementation JZIndexPath

- (instancetype)initWithColumn:(NSInteger)column withRow:(NSInteger)row
{
    self = [super init];
    if (self) {
        _column = column;
        _row = row;
    }
    return self;
}
+ (instancetype)indexPathWithColumn:(NSInteger)column withRow:(NSInteger)row
{
    JZIndexPath *indexPath = [[self alloc] initWithColumn:column withRow:row];
    return indexPath;
}
- (instancetype)initWithColumn:(NSInteger)column withRow:(NSInteger)row item:(NSInteger)item {
    self = [self initWithColumn:column withRow:row];
    if (self) {
        _currenSelectIndex = item;
    }
    return self;
}
+ (instancetype)indexPathWithColumn:(NSInteger)column withRow:(NSInteger)row withItem:(NSInteger)item
{
    return [[self alloc] initWithColumn:column withRow:row item:item];
}
@end

@implementation JZPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        _selectDataArray = [NSMutableArray array];
        [self createPickerViewUI];
    }
    return self;
}
- (void)createPickerViewUI
{
    //头部
    _topView = [[UIView alloc] init];
    _topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_topView];
    
    //取消按钮
    _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    _cancleBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [_cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_cancleBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_cancleBtn];
    //确认按钮
    _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    _sureBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [_sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_sureBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_sureBtn];
    //选择框
    _pickerView = [[UIPickerView alloc] init];
    _pickerView.backgroundColor =  [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:249.0/255.0 alpha:1];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [self addSubview:_pickerView];
    
    [self makekUImakeConstraint];
}
- (void)makekUImakeConstraint
{
    //头部
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_offset(0);
        make.top.mas_equalTo(kScreenHeight);
        make.right.mas_equalTo(self.mas_right).mas_offset(0);
        make.height.mas_equalTo(40);
    }];
    //取消按钮
    [_cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_topView.mas_left).mas_offset(15);
        make.top.mas_equalTo(_topView.mas_top).mas_offset(0);
        make.bottom.mas_equalTo(_topView.mas_bottom).mas_offset(0);
        make.width.mas_equalTo(40);
    }];
    //确认按钮
    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_topView.mas_right).mas_offset(-15);
        make.top.mas_equalTo(_topView.mas_top).mas_offset(0);
        make.bottom.mas_equalTo(_topView.mas_bottom).mas_offset(0);
        make.width.mas_equalTo(40);
    }];
    //选择框
    [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_offset(0);
        make.top.mas_equalTo(_topView.mas_bottom).mas_offset(0);
        make.right.mas_equalTo(self.mas_right).mas_offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(0);
    }];
}
- (void)setDataSource:(id<JZPickerViewDataSource>)dataSource
{
    _dataSource = dataSource;
    _selectDataArray = [NSMutableArray array];
    _selectIndexPath = nil;
    if (_dataSource && [_dataSource respondsToSelector:@selector(numberOfColumnInMenu:)]) {
        _numOfMenu = [_dataSource numberOfColumnInMenu:self];
    }else{
        _numOfMenu = 1;
    }
    [_pickerView reloadAllComponents];
    [_pickerView selectRow:0 inComponent:0 animated:NO];
}
#pragma mark -UIPickerViewDelegate,UIPickerViewDataSource
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (_dataSource && [_dataSource respondsToSelector:@selector(pickerView:numberOfRowInColumn:)]) {
        if (component != 0) {
            return [_dataSource pickerView:self numberOfRowInColumn:[JZIndexPath indexPathWithColumn:component withRow:0 withItem:_selectIndexPath.row]];
        }else{
            return [_dataSource pickerView:self numberOfRowInColumn:[JZIndexPath indexPathWithColumn:component withRow:0 withItem:0]];
        }
    }
    return 0;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return _numOfMenu;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (_dataSource && [_dataSource respondsToSelector:@selector(pickerView:dataForRowAtIndexPath:)]) {
        return [_dataSource pickerView:self dataForRowAtIndexPath:[JZIndexPath indexPathWithColumn:component withRow:row withItem:0]];
    }
    return nil;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return kScreenWidth / _numOfMenu;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    if (_delegate && [_delegate respondsToSelector:@selector(pickerView:heightForRowAtIndexPath:)]) {
        return [_delegate pickerView:self heightForRowAtIndexPath:[JZIndexPath indexPathWithColumn:component withRow:0]];
    }
    return 35.0f;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    if(component < _numOfMenu - 1){
        if (_dataSource && [_dataSource respondsToSelector:@selector(pickerView:numberOfRowInColumn:)]) {
            NSInteger allRow = [_dataSource pickerView:self numberOfRowInColumn:[JZIndexPath indexPathWithColumn:component withRow:0]];
            if (row >= allRow) {
                row = allRow - 1;
            }
        }
        _selectIndexPath = [JZIndexPath indexPathWithColumn:component withRow:row];
    }
    
    for (NSInteger i = component ; i < _numOfMenu - 1; i++) {
        [_pickerView reloadComponent:(i + 1)];
        [_pickerView selectRow:0 inComponent:(i + 1) animated:NO];
    }
}
//显示
- (void)showPickView:(id)currentSelf {
    
    if (currentSelf) {
        self.dataSource = currentSelf;
    }
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [_topView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0) {
            make.top.mas_equalTo(kScreenHeight - 40 - 240);
        }else{
            make.top.mas_equalTo(kScreenHeight - 40 - 216);
        }
    }];
    [UIView animateWithDuration:0.35 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self layoutIfNeeded];
        if (_firstColumnSelectIndex!=0) {
            [self.pickerView selectRow:_firstColumnSelectIndex inComponent:0 animated:NO];
            _firstColumnSelectIndex=0;
        }
    }];
}

//隐藏
- (void)hidePickeView {
    
    [_topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kScreenHeight);
    }];
    [UIView animateWithDuration:0.35 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
    }];
}
- (void)buttonClick:(UIButton *)btn
{
    if (btn == _sureBtn) {
        //确定
        if (_delegate && [_delegate respondsToSelector:@selector(pickerView:disSelectRowAtIndexPaths:)]) {
            for (int i = 0; i < _numOfMenu; i++) {
                
                NSInteger row = 0;
                
                NSInteger allRow = [_pickerView numberOfRowsInComponent:i];
                
                NSLog(@"allRow --------- %ld",allRow);
                row = [_pickerView selectedRowInComponent:i];
                if (row >= allRow) {
                    row = allRow - 1;
                    [_pickerView selectRow:row inComponent:i animated:NO];
                }
                JZIndexPath *indexPath ;
                if (i > 0) {
                    JZIndexPath *lastIndexPath = [_selectDataArray objectAtIndex:(i - 1)];
                    indexPath = [JZIndexPath indexPathWithColumn:i withRow:row withItem:lastIndexPath.row];
                    if (_dataSource && [_dataSource respondsToSelector:@selector(pickerView:numberOfRowInColumn:)]) {
                        [_dataSource pickerView:self numberOfRowInColumn:indexPath];
                    }
                }else{
                    indexPath = [JZIndexPath indexPathWithColumn:i withRow:row];
                }
                [_selectDataArray addObject:indexPath];
            }
            [_delegate pickerView:self disSelectRowAtIndexPaths:_selectDataArray];
        }
    }
    if (btn == _cancleBtn) {
        if (_delegate && [_delegate respondsToSelector:@selector(pickerView:ClickCancel:)]) {
            [_delegate pickerView:self ClickCancel:_cancleBtn];
        }
    }
    [self hidePickeView];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_isTouch) {
        UITouch *touch = [touches anyObject];
        if (touch.view == self) {
            [self hidePickeView];
        }
    }
    
}
- (void)dealloc {
    NSLog(@"%s",__func__);
}
@end
