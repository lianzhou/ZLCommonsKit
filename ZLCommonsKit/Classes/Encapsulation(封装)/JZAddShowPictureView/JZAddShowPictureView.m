//
//  JZAddShowPictureView.m
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import "JZAddShowPictureView.h"
#import "JZPicItemCell.h"
#import "Masonry.h"
#import "UIImageView+JZSDWebImage.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <YYKit.h>
#import "JZSystemMacrocDefine.h"
#import "JZPicModel.h"

static NSString *JZShowPicCollectionViewCellID = @"JZShowPicCollectionViewCell";
static NSString *JZPicItemCellID = @"JZPicItemCell";
@interface JZAddShowPictureView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)NSMutableArray *imagesArray;    //图片数组
@property(nonatomic,assign)NSInteger btn_width;

@property(nonatomic,strong)UICollectionView *onlyShowPicCollectionView;

@end

@implementation JZAddShowPictureView

+ (instancetype)shareInstance {
    static JZAddShowPictureView *addShowPictureView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        addShowPictureView = [[JZAddShowPictureView alloc] init];
        
    });
    return addShowPictureView;
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializer];
    }
    return self;
}
//添加图片
- (instancetype)initAddPicWithFrame:(CGRect)frame withimageArray:(NSArray *)imagesArr with_viewWidth:(CGFloat)viewWidth with_space:(CGFloat)space with_rowNumber:(NSInteger)rowNumber
{
    self = [super initWithFrame:frame];
    if (self) {
        _imagesArray = [imagesArr mutableCopy];
        self.picViewWidth = viewWidth;
        self.space = space;
        self.rowNumber = rowNumber;
        [self initializer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                withViewWidth:(CGFloat)viewWidth
              withImagesArray:(NSArray *)imagesArray
                  withPicType:(JZShowPicType)picType {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.picType = picType;
        self.picViewWidth = viewWidth;
        self.onlyShowPicArrays = [imagesArray mutableCopy];
        [self createShowPicView];
        [self createShowPicData];
    }
    return self;
    
}

- (void)initializer{
    
    [self createCollectionView];
}

#pragma mark - 显示图片创建View

- (void)createShowPicView {
    
    
    [self.onlyShowPicCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.onlyShowPicCollectionView reloadData];
    
    
}
- (void)createShowPicData {
    self.rowNumber = 3;//默认是3
    self.btn_width = (self.picViewWidth-(self.rowNumber -1)*self.space)/self.rowNumber;
}


#pragma mark - 添加图片创建View
- (void)createCollectionView
{
    [self addSubview:self.picCollectionView];
    self.btn_width = (self.picViewWidth-((self.rowNumber - 1)*self.space))/self.rowNumber;
    [self.picCollectionView registerClass:[JZPicItemCell class] forCellWithReuseIdentifier:JZPicItemCellID];
    [self.picCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [UIView animateWithDuration:0.25 animations:^{
        [self.picCollectionView reloadData];
        
    }];
    
}

#pragma mark -添加图片
- (void)addPicClick:(UIButton *)sender
{
    if (self.pictureDelegate && [self.pictureDelegate respondsToSelector:@selector(addShowPictureView_addPictureEvent)]) {
        [self.pictureDelegate addShowPictureView_addPictureEvent];
    }
}

#pragma mark -删除图片
- (void)deletePic:(UIButton *)sender
{
    if (self.pictureDelegate && [self.pictureDelegate respondsToSelector:@selector(addShowPictureView:deleteIndex:)]) {
        [self.pictureDelegate addShowPictureView:self deleteIndex:sender.tag - 200];
    }
}


#pragma mark -带加号的View高度
- (CGFloat)reloadUI_Height
{
    NSInteger number = 0;
    if (self.allowMaxPicNumber == _imagesArray.count) {
        number = _imagesArray.count;
    }else{
        number = _imagesArray.count + 1;
    }
    CGFloat firstNumber = (number)/self.rowNumber; //商
    CGFloat secondNumber = (number)%self.rowNumber; //余数
    
    NSInteger lineNumber = 0.0;
    if (firstNumber>0) {
        if (secondNumber>0) {
            lineNumber = firstNumber+1;
        }else{
            lineNumber = firstNumber;
        }
    }else{
        lineNumber = 1;
    }
    return lineNumber*self.btn_width + (lineNumber - 1)*self.space;
}

#pragma mark -CollectionViewDelegate


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == _picCollectionView) {
        if (self.allowMaxPicNumber == _imagesArray.count) {
            return _imagesArray.count;
        }else{
            return _imagesArray.count+1;
        }
    }else{
        if (self.onlyShowPicArrays.count > 9) {
            return 9;
        } else {
            return self.onlyShowPicArrays.count;
        }
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) wealSelf = self;
    if (collectionView == self.picCollectionView) {
        JZPicItemCell *picCell = [collectionView dequeueReusableCellWithReuseIdentifier:JZPicItemCellID forIndexPath:indexPath];
        [picCell imageWithImageStr:nil withCurrentIndex:indexPath.row withImageArr:_imagesArray];
        
        picCell.actionBlock = ^(UIView *imageView){
            
            __strong typeof(self) strongSelf = wealSelf;
            NSLog(@"%ld",(long)strongSelf.imagesArray.count);
            NSLog(@"浏览:%ld,viewTag:%ld",(long)indexPath.row,(long)indexPath.row + 200);
            if (strongSelf.imagesArray.count == 0) {
                if (strongSelf.pictureDelegate && [strongSelf.pictureDelegate respondsToSelector:@selector(addShowPictureView_addPictureEvent)]) {
                    [strongSelf.pictureDelegate addShowPictureView_addPictureEvent];
                }
            }else{
                NSLog(@"%ld",(long)self.imagesArray.count);
                if (indexPath.row == strongSelf.imagesArray.count) {
                    if (strongSelf.pictureDelegate && [strongSelf.pictureDelegate respondsToSelector:@selector(addShowPictureView_addPictureEvent)]) {
                        [strongSelf.pictureDelegate addShowPictureView_addPictureEvent];
                    }
                }else{
                    if (strongSelf.pictureDelegate && [strongSelf.pictureDelegate respondsToSelector:@selector(addShowPictureView:browsePictureIndex:withSuperImagesView:)]) {
                        [strongSelf.pictureDelegate addShowPictureView:strongSelf browsePictureIndex:indexPath.row withSuperImagesView:collectionView];
                    }
                    
                }
            }
        };
        picCell.deleteBlock = ^(){
            NSLog(@"删除");
            if (JZCheckObjectNull(self.imagesArray)|| indexPath.row > self.imagesArray.count) {
                return;
            }
            [self.imagesArray removeObjectAtIndex:indexPath.row];
            [self.picCollectionView reloadData];
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset([self reloadUI_Height]);
            }];
            if (self.pictureDelegate && [self.pictureDelegate respondsToSelector:@selector(addShowPictureView:deleteIndex:)]) {
                [self.pictureDelegate addShowPictureView:self deleteIndex:indexPath.row];
            }
        };
        return picCell;
    }else {
        JZShowPicCollectionViewCell *showPicCollectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:JZShowPicCollectionViewCellID forIndexPath:indexPath];
        
        
        JZPicModel *picModel = [[JZPicModel alloc] init];
        picModel.itemWidth = self.btn_width;
        NSString *image = [self.onlyShowPicArrays objectAtIndex:indexPath.row];
        if (self.onlyShowPicArrays.count >9 && indexPath.row == 8) {
            picModel.isShowPicNum = YES;
            picModel.picNum = self.onlyShowPicArrays.count;
        }
        picModel.imageUrl = image;
        [showPicCollectionViewCell collectionCelDataWithModel:picModel withIndexPath:indexPath];
        showPicCollectionViewCell.actionBlock = ^(UIView *imageView){
            __strong typeof(wealSelf) strongSelf = wealSelf;
            if (strongSelf.pictureDelegate && [strongSelf.pictureDelegate respondsToSelector:@selector(addShowPictureView:browsePictureIndex:withSuperImagesView:)]) {
                [strongSelf.pictureDelegate addShowPictureView:strongSelf browsePictureIndex:indexPath.row withSuperImagesView:collectionView];
                
            }
        };
        showPicCollectionViewCell.pressBlock = ^(UILongPressGestureRecognizer *press) {
          
            __strong typeof(wealSelf) strongSelf = wealSelf;
            if (strongSelf.pictureDelegate && [strongSelf.pictureDelegate respondsToSelector:@selector(addShowPictureView:longPress:)]) {
                [strongSelf.pictureDelegate addShowPictureView:self longPress:press];
            }
        };
        
        return showPicCollectionViewCell;
    }
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _picCollectionView) {
        return CGSizeMake(_btn_width, _btn_width);
    }else{
        if (self.picType == JZShowPicType_SpeedDial_ButOne) {
            if (self.onlyShowPicArrays.count == 1) {
                return CGSizeMake(self.picViewWidth, self.onePicHeight);
            }else{
                return CGSizeMake(self.btn_width, self.btn_width);
            }
        }else if (self.picType == JZShowPicType_SpeedDial){
            return CGSizeMake(self.btn_width, self.btn_width);
        }else{
            if (self.onlyShowPicArrays.count == 1) {
                return CGSizeMake(self.picViewWidth, self.onePicHeight);
            }else if (self.onlyShowPicArrays.count == 2||self.onlyShowPicArrays.count == 3){
                return CGSizeMake((self.picViewWidth - (self.onlyShowPicArrays.count-1)*self.space)/self.onlyShowPicArrays.count, (self.picViewWidth - (self.onlyShowPicArrays.count-1)*self.space)/self.onlyShowPicArrays.count);
            }else{
                return CGSizeMake(self.btn_width, self.btn_width);
            }
        }
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return self.space;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return self.space;
}

#pragma mark - 对图片数组操作之后,刷新
- (void)reloadPictureViewUIWithImagesArr:(NSArray *)changeArray {
    
    self.imagesArray = [changeArray mutableCopy];
    [self.picCollectionView reloadData];
}

#pragma mark - 刷新显示图片的高度
- (CGFloat)reloadShowPicViewHeight {
    CGFloat picViewHeight = 0;
    if (self.picType == JZShowPicType_SpeedDial_ButOne) {
        if (self.onlyShowPicArrays.count > 0) {
            if (self.onlyShowPicArrays.count == 1) {
                picViewHeight = self.onePicHeight;
            }else{
                picViewHeight = [self nineBoxHeight];
            }
        }
        
    }else if (self.picType == JZShowPicType_SpeedDial){
        picViewHeight = [self nineBoxHeight];
    }else{
        if (self.onlyShowPicArrays.count == 1) {
            picViewHeight = self.onePicHeight;
        }else if (self.onlyShowPicArrays.count == 2 || self.onlyShowPicArrays.count == 3){
            CGFloat btn_Width = (self.picViewWidth-((self.onlyShowPicArrays.count - 1)*self.space))/self.onlyShowPicArrays.count;
            picViewHeight = btn_Width;
            
        }else{
            picViewHeight = [self nineBoxHeight];
        }
    }
    
    return picViewHeight;
}
//九宫格高度
- (CGFloat)nineBoxHeight
{
    CGFloat picViewHeight = 0;
    CGFloat btn_Width = (self.picViewWidth-((self.rowNumber - 1)*self.space))/self.rowNumber;
    NSInteger firstNumber = self.onlyShowPicArrays.count/self.rowNumber; //商
    NSInteger column = self.rowNumber;
    NSInteger secondNumber = self.onlyShowPicArrays.count%column; //余数
    NSInteger lineNumber = 0.0;
    if (self.onlyShowPicArrays.count > 9) {
        firstNumber = 3;
        secondNumber = 0;
    }
    if (firstNumber>0) {
        if (secondNumber>0) {
            lineNumber = firstNumber+1;
        }else{
            lineNumber = firstNumber;
        }
    }else{
        lineNumber = 1;
    }
    picViewHeight = lineNumber*btn_Width + (lineNumber - 1)*self.space;
    return picViewHeight;
}


+ (CGFloat)calculatePicViewHeightWithPicsArray:(NSArray *)picsArray
                              withShowPicWidth:(CGFloat)viewWidth
                              withOnePicHeigth:(CGFloat)onePicHeight
                                 withRowNumber:(NSInteger)rowNumber
                                     withSpace:(CGFloat)space
                                      withType:(JZShowPicType)picType {
    
    CGFloat picViewHeight = 0;
    if (picsArray.count > 0) {
        if (picType == JZShowPicType_SpeedDial_ButOne) {
            
            if (picsArray.count == 1) {
                picViewHeight = onePicHeight;
            }else{
                CGFloat btn_Width = (viewWidth-((rowNumber - 1)*space))/rowNumber;
                NSInteger firstNumber = picsArray.count/rowNumber; //商
                NSInteger column = rowNumber;
                CGFloat secondNumber = picsArray.count%column; //余数
                CGFloat lineNumber = 0.0;
                if (picsArray.count > 9) {
                    firstNumber = 3;
                    secondNumber = 0;
                }
                if (firstNumber>0) {
                    if (secondNumber>0) {
                        lineNumber = firstNumber+1;
                    }else{
                        lineNumber = firstNumber;
                    }
                }else{
                    lineNumber = 1;
                }
                picViewHeight = lineNumber*btn_Width + (lineNumber - 1)*space;
            }
        }else if (picType == JZShowPicType_SpeedDial){
            CGFloat btn_Width = (viewWidth-((rowNumber - 1)*space))/rowNumber;
            NSInteger firstNumber = picsArray.count/rowNumber; //商
            NSInteger column = rowNumber;
            CGFloat secondNumber = picsArray.count%column; //余数
            CGFloat lineNumber = 0.0;
            if (picsArray.count > 9) {
                firstNumber = 3;
                secondNumber = 0;
            }
            if (firstNumber>0) {
                if (secondNumber>0) {
                    lineNumber = firstNumber+1;
                }else{
                    lineNumber = firstNumber;
                }
            }else{
                lineNumber = 1;
            }
            picViewHeight = lineNumber*btn_Width + (lineNumber - 1)*space;
        }else{
            if (picsArray.count == 1) {
                picViewHeight = onePicHeight;
            }else if (picsArray.count == 2 || picsArray.count == 3){
                CGFloat btn_Width = (viewWidth-(picsArray.count - 1)*space)/picsArray.count;
                picViewHeight = btn_Width;
            }else{
                CGFloat btn_Width = (viewWidth-((rowNumber - 1)*space))/rowNumber;
                NSInteger firstNumber = picsArray.count/rowNumber; //商
                NSInteger column = rowNumber;
                CGFloat secondNumber = picsArray.count%column; //余数
                CGFloat lineNumber = 0.0;
                if (picsArray.count > 9) {
                    firstNumber = 3;
                    secondNumber = 0;
                }
                if (firstNumber>0) {
                    if (secondNumber>0) {
                        lineNumber = firstNumber+1;
                    }else{
                        lineNumber = firstNumber;
                    }
                }else{
                    lineNumber = 1;
                }
                picViewHeight = lineNumber*btn_Width + (lineNumber - 1)*space;
            }
        }
    }
    
    
    return picViewHeight;
    
}

- (void)resetPicCollectionView {
    
    [self.onlyShowPicArrays removeAllObjects];
    [self.onlyShowPicCollectionView reloadData];
    
    for (UIView * subview in self.onlyShowPicCollectionView.subviews) {
        if ([subview isKindOfClass:[UICollectionViewCell class]]) {
            [subview removeFromSuperview];
        }
    }
}
#pragma mark - 懒加载
- (NSArray *)imagesArray
{
    if (!_imagesArray) {
        _imagesArray = [[NSMutableArray alloc]init];
    }
    return _imagesArray;
}

- (UICollectionView *)picCollectionView
{
    if (!_picCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _picCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _picCollectionView.delegate = self;
        _picCollectionView.dataSource = self;
        _picCollectionView.backgroundColor = [UIColor whiteColor];
    }
    return _picCollectionView;
}

- (UICollectionView *)onlyShowPicCollectionView {
    if (!_onlyShowPicCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _onlyShowPicCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [_onlyShowPicCollectionView registerClass:[JZShowPicCollectionViewCell class] forCellWithReuseIdentifier:JZShowPicCollectionViewCellID];
        _onlyShowPicCollectionView.delegate = self;
        _onlyShowPicCollectionView.dataSource = self;
        _onlyShowPicCollectionView.scrollEnabled = NO;
        _onlyShowPicCollectionView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_onlyShowPicCollectionView];
        
    }
    return _onlyShowPicCollectionView;
}

//- (NSInteger)rowNumber
//{
//    if (_rowNumber == 0) {
//        _rowNumber = 3;
//    }
//    return _rowNumber;
//}



- (CGFloat)picViewWidth
{
    if (_picViewWidth == 0) {
        _picViewWidth = SCREEN_WIDTH;
    }
    return _picViewWidth;
}

- (CGFloat)onePicHeight
{
    if (!_onePicHeight) {
        _onePicHeight = 180;
    }
    return _onePicHeight;
}


- (BOOL)isLocal
{
    if (!_isLocal) {
        _isLocal = NO;
    }
    return _isLocal;
}

- (NSInteger)allowMaxPicNumber {
    if (!_allowMaxPicNumber) {
        _allowMaxPicNumber = 9;
    }
    return _allowMaxPicNumber;
}


#pragma mark -setter
- (void)setOnlyShowPicArrays:(NSMutableArray *)onlyShowPicArrays
{
    _onlyShowPicArrays = onlyShowPicArrays;
    if (_onlyShowPicArrays.count > 0) {
        [self.onlyShowPicCollectionView reloadData];
    }
}

- (void)setSpace:(CGFloat)space {
    _space = space;
    self.btn_width = (self.picViewWidth-(self.rowNumber -1)*self.space)/self.rowNumber;
    [self.onlyShowPicCollectionView reloadData];
}

- (void)setRowNumber:(NSInteger)rowNumber {
    _rowNumber = rowNumber;
    self.btn_width = (self.picViewWidth-(self.rowNumber -1)*self.space)/self.rowNumber;
    [self.onlyShowPicCollectionView reloadData];
}

@end

