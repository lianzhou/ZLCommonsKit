//
//  JZRefreshHeader.m
//  eStudy
//
//  Created by zhoulian on 2017/6/5.
//  Copyright © 2017年 zhoulian. All rights reserved.
//


#import "JZRefreshHeader.h"

const CGFloat SURefreshHeaderHeight = 40.0;
const CGFloat SURefreshPointRadius = 5.0;

const CGFloat SURefreshPullLen     = 55.0;
const CGFloat SURefreshTranslatLen = 5.0;


@interface JZRefreshHeader ()

@property (nonatomic, weak  ) UIScrollView * scrollView;

@property (nonatomic, strong) UIImageView *animationView;


@property (nonatomic, strong)NSMutableArray *firstImages;

@property (nonatomic, strong)NSMutableArray *secondImages;

@property (nonatomic, strong)NSMutableArray *thirdImages;

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) BOOL animating;

@end

@implementation JZRefreshHeader

- (instancetype)init {
    if (self = [super init]) {
        self.isNormal = YES;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isNormal = YES;
    }
    return self;
}
- (NSMutableArray *)firstImages {
    if (!_firstImages) {
        _firstImages = [NSMutableArray array];
    }
    return _firstImages;
}

- (NSMutableArray *)secondImages {
    if (!_secondImages) {
        _secondImages = [NSMutableArray array];
    }
    return _secondImages;
}

- (NSMutableArray *)thirdImages {
    if (!_thirdImages) {
        _thirdImages = [NSMutableArray array];
    }
    return _thirdImages;
}


- (void)setIsNormal:(BOOL)isNormal {
    
    [self.firstImages removeAllObjects];
    [self.secondImages removeAllObjects];
    [self.thirdImages removeAllObjects];
    if (isNormal) {
        for (int i = 1; i<= 29; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Export1-1_000%02d", i]];
            [self.firstImages addObject:image];
        }
        
        for (int i = 1; i<= 53; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Export2-1_00%02d", i]];
            [self.secondImages addObject:image];
        }
        
        for (int i = 0; i< 30; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Export3-1_000%02d", i]];
            [self.thirdImages addObject:image];
        }
    }else {
        for (int i = 1; i<= 29; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Export1_000%02d", i]];
            [self.firstImages addObject:image];
        }
        
        for (int i = 1; i<= 53; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Export2_00%02d", i]];
            [self.secondImages addObject:image];
        }
        
        for (int i = 0; i< 13; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Export3_000%02d", i]];
            [self.thirdImages addObject:image];
        }
    }
    
    
}

- (void)setAnimationImages:(NSMutableArray *)animationImages repeatCount:(NSInteger )repeatCount{
    // 设置动画图片
    self.animationView.animationImages = animationImages;
    // 设置播放次数
    self.animationView.animationRepeatCount = repeatCount;
    // 设置动画的时间
    self.animationView.image = [animationImages lastObject];
    self.animationView.animationDuration = animationImages.count * 0.04;
}


- (UIImageView *)animationView {
    if (!_animationView) {
        _animationView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SURefreshHeaderHeight, SURefreshHeaderHeight)];
        _animationView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_animationView];
    }
    return _animationView;
}



#pragma mark - Override
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        self.scrollView = (UIScrollView *)newSuperview;
        self.center = CGPointMake(self.scrollView.center.x, self.center.y);
        [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }else {
        [self.superview removeObserver:self forKeyPath:@"contentOffset"];
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        self.progress = - self.scrollView.contentOffset.y;
    }
}

- (void)setPullingPercent:(CGFloat)pullingPercent
{
    if (pullingPercent > 0) {
        
        if ( self.firstImages.count == 0) return;
        // 停止动画
        [self.animationView stopAnimating];
        // 设置当前需要显示的图片
        NSUInteger index =  self.firstImages.count * pullingPercent;
        
        if (index >= self.firstImages.count) index = self.firstImages.count - 1;
        
        self.animationView.image = self.firstImages[index];
        
    }else {
        self.animationView.image = nil;
    }
}

#pragma mark - Property
- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    //如果不是正在刷新，则渐变动画
    if (!self.animating) {
        
        CGFloat temp;
        if (progress >= SURefreshPullLen) {
            
            temp = (progress - self.frame.size.height) / self.frame.size.height;
        }else {
            
            if (progress <= self.frame.size.height) {
                temp = 0;
            }else {
                self.animationView.hidden = NO;
                temp = (progress - self.frame.size.height) / self.frame.size.height;
            }
            
        }
        
        [self setPullingPercent:temp];
    }
    
    CGRect frm = self.frame;
    frm.origin.y = - (progress - 10);
    self.frame = frm;
    
    //如果到达临界点，则执行刷新动画
    if (progress >= SURefreshPullLen && !self.animating && !self.scrollView.dragging) {
        [self startAni];
        if (self.handle) {
            self.handle();
        }
    }
}

#pragma mark - Animation
- (void)startAni {
    self.animating = YES;
    [UIView animateWithDuration:0.5 animations:^{
        UIEdgeInsets inset = self.scrollView.contentInset;
        inset.top = SURefreshPullLen;
        self.scrollView.contentInset = inset;
    }];
    
    // 开始动画
    
    [self setAnimationImages:self.secondImages repeatCount:0];
    [self.animationView startAnimating];
}

- (void)removeAni {
    
    [self.animationView stopAnimating];
    
    [self.animationView.layer removeAllAnimations];
    
//    self.animationView.frame = CGRectMake(0, 0, 40, 40);
    [self setAnimationImages:self.thirdImages repeatCount:1];
    [self.animationView startAnimating];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.thirdImages.count * 0.04 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:0.5 animations:^{
            UIEdgeInsets inset = self.scrollView.contentInset;
            inset.top = 0.f;
            self.scrollView.contentInset = inset;
            
            CGRect frm = self.frame;
            frm.origin.y = - 50;
            self.frame = frm;
            
        } completion:^(BOOL finished) {

            [self.layer removeAllAnimations];
            self.animating = NO;
        }];
        
        [self.animationView stopAnimating];
        
    });
    
}

#pragma mark - Stop
- (void)endRefreshing {
    [self removeAni];
}

@end

