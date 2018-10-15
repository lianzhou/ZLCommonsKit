//
//  JZTableViewHeaderFooterView.m
//  JZCommonsKit
//
//  Created by admin on 2018/4/18.
//

#import "JZTableViewHeaderFooterView.h"
#import "JZSystemMacrocDefine.h"

@implementation JZTableViewHeaderFooterView

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
    self.contentView.backgroundColor = JZ_KMainColor;

}
@end
