//
//  avplayerVC.h
//  TBPlayer
//
//  Created by qianjianeng on 16/2/27.
//  Copyright © 2016年 SF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZBaseViewController.h"

@interface JZAVPlayerViewController : JZBaseViewController <UINavigationControllerDelegate>

@property (nonatomic,copy)NSString *urlString;

@property (nonatomic,copy)NSString *imageName;

@property (nonatomic,assign)CGSize  videoSize;

@property (nonatomic, copy) void (^deleteVideoBlock)(void);

@property (nonatomic,strong)UIView *startView;

@property (nonatomic, strong)UIImage *firstIamge;

- (void)goToBack;

- (void)play;

@end
