//
//  ZLAddShowPictureView.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZLAddShowPictureView;

//图片排版格式
typedef enum : NSUInteger {
    ZLShowPicType_Default,//带添加按钮
    ZLShowPicType_SpeedDial, //九宫格
    ZLShowPicType_SpeedDial_ButOne,//一张特殊显示,其余九宫格显示
    ZLShowPicType_StyleKindsOf, //不同图片数显示不同类型
} ZLShowPicType;

@protocol ZLAddShowPictureViewDelegate <NSObject>

@optional
//添加图片
- (void)addShowPictureView_addPictureEvent;
//删除图片
- (void)addShowPictureView:(ZLAddShowPictureView *)pictureVirew deleteIndex:(NSInteger)deleteIndex;
//浏览图片
- (void)addShowPictureView:(ZLAddShowPictureView *)pictureVirew browsePictureIndex:(NSInteger)selectedIndex withSuperImagesView:(UIView *)imagesView;

//添加长按手势
- (void)addShowPictureView:(ZLAddShowPictureView *)pictureVirew longPress:(UILongPressGestureRecognizer *)press;

@end


@interface ZLAddShowPictureView : UIView
@property(nonatomic,weak)id<ZLAddShowPictureViewDelegate>pictureDelegate;

@property(nonatomic,strong)UICollectionView *picCollectionView;

//只是显示图片
@property(nonatomic,strong)NSMutableArray *onlyShowPicArrays;
//每行显示的图片数
@property(nonatomic,assign)NSInteger rowNumber;
//间隔
@property(nonatomic,assign)CGFloat space;
//显示图片的宽度
@property(nonatomic,assign)CGFloat picViewWidth;
//一张图片高度
@property(nonatomic,assign)CGFloat onePicHeight;
//是否允许删除
@property(nonatomic,assign)BOOL isDelete;
//是否是本地图片
@property(nonatomic,assign)BOOL isLocal;
//图片排版类型
@property(nonatomic,assign)ZLShowPicType picType;
//允许选择的最大图片数
@property(nonatomic,assign)NSInteger allowMaxPicNumber;

- (void)resetPicCollectionView;

/**
 添加图片

 @param frame frame
 @param imagesArr 图片数组
 @param viewWidth 控件宽度
 @param space 空间
 @param rowNumber 每行最多显示几个
 @return self
 */
- (instancetype)initAddPicWithFrame:(CGRect)frame
                     withimageArray:(NSArray *)imagesArr
                     with_viewWidth:(CGFloat)viewWidth
                         with_space:(CGFloat)space
                     with_rowNumber:(NSInteger)rowNumber;


/**
 刷新添加图片控件的高度
 
 @return 高度
 */
- (CGFloat)reloadUI_Height;


/**
  对图片数组操作之后,刷新

 @param changeArray 改变之后的数组
 */
- (void)reloadPictureViewUIWithImagesArr:(NSArray *)changeArray;

/**
 显示图片:支持九宫格,一张特殊显示的九宫格,1,2,3平铺,其他九宫格显示

 @param frame frame
 @param viewWidth 控件的宽度
 @param imagesArray 图片数组
 @param picType 类型
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame
                withViewWidth:(CGFloat)viewWidth
              withImagesArray:(NSArray *)imagesArray
                  withPicType:(ZLShowPicType)picType;



/**
 刷新显示图片的高度
 
 @return 高度
 */
- (CGFloat)reloadShowPicViewHeight;

/**
 计算高度---供外部计算

 @param picsArray 图片数组
 @param viewWidth 控件宽度
 @param onePicHeight 一张图片的高度
 @param rowNumber 每行最多显示几张
 @param space 每张图片之间的距离
 @param picType 类型
 @return 高度
 */
+ (CGFloat)calculatePicViewHeightWithPicsArray:(NSArray *)picsArray
                              withShowPicWidth:(CGFloat)viewWidth
                               withOnePicHeigth:(CGFloat)onePicHeight
                                 withRowNumber:(NSInteger)rowNumber
                                     withSpace:(CGFloat)space
                                      withType:(ZLShowPicType)picType;



@end
