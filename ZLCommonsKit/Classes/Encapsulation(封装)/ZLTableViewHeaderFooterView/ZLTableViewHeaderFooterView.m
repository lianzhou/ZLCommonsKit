//
//  ZLTableViewHeaderFooterView.m
//  ZLCommonsKit
//
//  Created by admin on 2018/4/18.
//

#import "ZLTableViewHeaderFooterView.h"
#import "ZLSystemMacrocDefine.h"

@implementation ZLTableViewHeaderFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textLabel.font = [UIFont systemFontOfSize:13];
    self.textLabel.textColor = UIColorFromRGB(0x999999);
    self.contentView.backgroundColor = ZL_KMainColor;

}
@end
