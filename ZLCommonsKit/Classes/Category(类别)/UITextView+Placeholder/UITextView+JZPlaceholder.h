//
//  UITextView+JZPlaceholder.h
//  eStudy
//
//  Created by zhoulian on 17/6/8.
//

#import <UIKit/UIKit.h>

@interface UITextView (JZPlaceholder)


@property (nonatomic, strong,readonly) UILabel *jz_placeholderLabel;

@property (nonatomic, strong) IBInspectable NSString *jz_placeholder;
@property (nonatomic, strong) IBInspectable UIColor  *jz_placeholderColor;
@property (nonatomic, strong) IBInspectable UIFont   *jz_placeholderFont;


@end
