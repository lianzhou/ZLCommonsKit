//
//  ZLPicItemCell.m
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import "ZLPicItemCell.h"
#import <Masonry/Masonry.h>
#import "ZLPicModel.h"
#import "UIImageView+ZLSDWebImage.h"
#import "UIView+ZLUIViewExtension.h"
#import "UIImage+Picker.h"
@interface ZLPicItemCell ()

@end

@implementation ZLPicItemCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializer];
    }
    return self;
}



- (void)initializer{
    
    
    [self makeConstraints];
    [self.contentView layoutIfNeeded];
}

//- (CGSize)intrinsicContentSize {
//    
//    return self.contentView.bounds.size;
//}

//添加或者浏览
- (void)picAction:(UITapGestureRecognizer *)tapSender
{
    if (_actionBlock) {
        _actionBlock(self.itemView);
    }
}

//删除
- (void)deletePicClick:(UIButton *)sender
{
    if (_deleteBlock) {
        _deleteBlock();
    }
}

- (void)imageWithImageStr:(NSString *)imageStr withCurrentIndex:(NSInteger)currentIndex withImageArr:(NSMutableArray *)imageArray
{
    
    if (imageArray.count == 0) {
        CGFloat btn_Width = (([UIScreen mainScreen].bounds.size.width - 30)-((6 - 1)*5))/6;
        if (self.frame.size.width <= btn_Width) {
            _itemView.image = [UIImage imageNamed:@"publishHomework_add_pic"];
        }else{
            _itemView.image = [UIImage imageNamed:@"mjl_addNormal_picture"];
        }
        _itemView.tag = 888;
        _deleteView.hidden = YES;
        _deleteBtn.hidden = YES;
    }else{
        if (currentIndex== imageArray.count) {//最后一个加号按钮
            CGFloat btn_Width = (([UIScreen mainScreen].bounds.size.width - 30)-((6 - 1)*5))/6;
            if (self.frame.size.width <= btn_Width) {
                _itemView.image = [UIImage imageNamed:@"publishHomework_add_pic"];
            }else{
                _itemView.image = [UIImage imageNamed:@"mjl_addNormal_picture"];
            }
            _itemView.tag = 888;
            _deleteView.hidden = YES;
            _deleteBtn.hidden = YES;
        }else{
            _itemView.tag = currentIndex + 200;
            _itemView.image = [imageArray objectAtIndex:currentIndex];
            _deleteView.hidden = NO;
            _deleteBtn.hidden = NO;
        }
    }
}
#pragma mark - 约束
- (void)makeConstraints{
    
    [self.itemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.top.mas_equalTo(self.mas_top);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    [self.deleteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_itemView.mas_right).mas_offset(-1);
        make.top.mas_equalTo(_itemView.mas_top).mas_offset(1);
        make.width.mas_offset(20);
        make.height.mas_offset(20);
    }];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_itemView.mas_right).mas_offset(-1);
        make.top.mas_equalTo(_itemView.mas_top).mas_offset(1);
        make.width.mas_offset(20);
        make.height.mas_offset(20);
    }];
    
    [self.itemView layoutIfNeeded];
}

#pragma mark - 懒加载
- (UIImageView *)itemView
{
    if (!_itemView) {
        _itemView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _itemView.backgroundColor = [UIColor whiteColor];
        _itemView.userInteractionEnabled = YES;
        _itemView.contentMode = UIViewContentModeScaleAspectFill;
        _itemView.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(picAction:)];
        [_itemView addGestureRecognizer:tap];
        
        [self.contentView addSubview:_itemView];
    }
    return _itemView;
}

- (UIView *)deleteView
{
    if (!_deleteView) {
        //删除按钮
        _deleteView = [[UIView alloc]initWithFrame:CGRectZero];
        _deleteView.backgroundColor = [UIColor blackColor];
        _deleteView.alpha = 0.5;
        
        [_itemView addSubview:_deleteView];
    }
    return _deleteView;
}


- (UIButton *)deleteBtn
{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage imageNamed:@"mjl_Nav_close"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deletePicClick:) forControlEvents:UIControlEventTouchUpInside];
        [_itemView addSubview:_deleteBtn];
    }
    return _deleteBtn;
}



@end

@interface ZLShowPicCollectionViewCell ()


@end

@implementation ZLShowPicCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createViews];
    }
    return self;
}


- (void)createViews {
    
    [self.mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.contentView);
    }];
    [self.mainImageView addSubview:self.picNumBtn];
    [self.picNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mainImageView.mas_right).mas_offset(-5);
        make.bottom.mas_equalTo(self.mainImageView.mas_bottom).mas_offset(-5);
        make.width.mas_equalTo(46);
        make.height.mas_equalTo(18);
    }];
    [self.mainImageView layoutIfNeeded];
}


- (void)collectionCelDataWithModel:(ZLPicModel *)picModel withIndexPath:(NSIndexPath *)indexPath {
    
    if (picModel.isShowPicNum && indexPath.row == 8) {
        self.picNumBtn.hidden = NO;
        [self.picNumBtn setTitle:[NSString stringWithFormat:@"%ld",(long)picModel.picNum] forState:UIControlStateNormal];
    } else {
        self.picNumBtn.hidden = YES;
    }
    
    NSString *imageUrl = nil;
    
    CGFloat itemWidth = CGRectGetWidth(self.frame);
    CGFloat itemHeight = CGRectGetHeight(self.frame);
    if (itemWidth == picModel.itemWidth && itemHeight == picModel.itemWidth) {
        itemWidth = itemHeight = 200;
    }
    
    if ([picModel.imageUrl hasPrefix:@"http://dfs.img.ZLexueyun.com/"]) {
        imageUrl = [NSString stringWithFormat:@"%@?imageView2/2/w/%f/h/%f",picModel.imageUrl,itemWidth,itemHeight];
        imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@"dfs.img.ZLexueyun.com/" withString:@"dfs.view-img.ZLexueyun.com/"];
    }else if ([picModel.imageUrl hasPrefix:@"http://test.img.juziwl.cn/"]){
        imageUrl = [NSString stringWithFormat:@"%@?imageView2/2/w/%f/h/%f",picModel.imageUrl,itemWidth,itemHeight];
        imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@"test.img.juziwl.cn/" withString:@"test.view-img.juziwl.cn/"];
    } else{
        imageUrl = picModel.imageUrl;
    }
    //周连添加判断本地图片还是网络图片
    NSURL *url=[NSURL URLWithString:imageUrl];
    //NSLog(@"ZLPicltemCell Scheme: %@", [url scheme]);
    
    if([[url scheme] isEqualToString:@"http"] || [[url scheme] isEqualToString:@"https"]){
        [self.mainImageView zl_setImageWithString:imageUrl placeholderType:ZLPlaceholderImageTypeDefault_60_60];
    }
    else{
        @autoreleasepool {
            self.mainImageView.image=[UIImage imageWithContentsOfFile:imageUrl];
        }
    }
    
    self.mainImageView.tag = 200 + indexPath.row;
}

- (void)imageTapClick:(UITapGestureRecognizer *)tapGuesSender {
    if (_actionBlock) {
        _actionBlock(tapGuesSender.view);
    }
}

- (void)longPressed:(UILongPressGestureRecognizer *)press {
    
    if (self.pressBlock) {
        
        self.pressBlock(press);
    }
}

#pragma mark - 懒加载

- (UIImageView *)mainImageView {
    if (!_mainImageView) {
        _mainImageView = [[UIImageView alloc] init];
        _mainImageView.contentMode = UIViewContentModeScaleAspectFill;
        _mainImageView.clipsToBounds = YES;
        _mainImageView.userInteractionEnabled = YES;
        _mainImageView.backgroundColor = [UIColor lightGrayColor];
        [_mainImageView zl_setTarget:self action:@selector(imageTapClick:)];
        [self.contentView addSubview:_mainImageView];
        
        //添加长按手势 无聊
        [_mainImageView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)]];
    }
    return _mainImageView;
}

- (UIButton *)picNumBtn {
    if (!_picNumBtn) {
        _picNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _picNumBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _picNumBtn.layer.cornerRadius = 9;
        _picNumBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_picNumBtn setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1] forState:UIControlStateNormal];
        [_picNumBtn setImage:[UIImage imageNamedWithPickerName:@"xhp_zone_pic_num"] forState:UIControlStateNormal];
        _picNumBtn.userInteractionEnabled = NO;
        _picNumBtn.adjustsImageWhenHighlighted = NO;
        _picNumBtn.hidden = YES;
        _picNumBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        _picNumBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    }
    return _picNumBtn;
}
@end

