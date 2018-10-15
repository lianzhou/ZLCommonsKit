//
//  UITableViewCell+LineImageView.h
//  AFNetworking
//
//  Created by li_chang_en on 2017/12/11.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (LineImageView)

@property (strong, nonatomic) UIImageView * topLineView;
@property (strong, nonatomic) UIImageView * bottomLineView;

+(UIImage *)lineImage;
@end
