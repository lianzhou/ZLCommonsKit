//
//  BaseModel.m
//  BaseTableViewDemo
//
//  Created by zhangjiang on 2017/5/15.
//  Copyright © 2017年 zhangjiang. All rights reserved.
//

#import "JZBaseTitleModel.h"
#import "JZSystemMacrocDefine.h"


@implementation JZBaseTitleModel

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
         _title = [dic objectForKey:@"title"];
         _detailTitle = [dic objectForKey:@"detailTitle"];
         _titleFont = [dic objectForKey:@"titleFont"];
         _detailFont = [dic objectForKey:@"detailFont"];
         _identifier = @"JZBaseTitleModel";
         _modelSize = [[dic objectForKey:@"modelSize"] CGSizeValue];
         _collectionCellModelType = JZTitleCollectionCustomCell;
    }
    return self;
}
+ (Class)classForContentType:(JZTitleCollectionCellModelType)contentType
{
    NSString *className = [[JZBaseTitleModel TitleCellContentTypeDict]objectForKey:@(contentType)];
    return NSClassFromString(className);
}
+ (NSDictionary *)TitleCellContentTypeDict
{
    return @{
             @(JZTitleCollectionCellModelTypeDefault)  : @"JZTitleCollectionBaseCell",
             @(JZTitleCollectionCustomCell)             : @"JZTitleCollectionCustomCell",
             };
}
- (void)normalCellForSel:(nonnull SEL)arg1 target:(nonnull id)arg2{
    _actionTarget = arg2;
    _actionSel = arg1;
}

- (void)makeNormalCell:(id)arg1{
    if (_actionTarget) {
        if ([_actionTarget respondsToSelector:_actionSel]) {
            JZPerformSelectorLeakWarning(
                                         [_actionTarget performSelector:_actionSel withObject:arg1 withObject:self];
                                         );
        }
        
    }
}

+ (id)normalCellForSel:(nonnull SEL)arg1 target:(nonnull id)arg2 title:(id)arg3 {
    JZBaseTitleModel * cellModel = [[JZBaseTitleModel alloc] init];
    [cellModel normalCellForSel:arg1 target:arg2];
    cellModel.title = arg3;
    return cellModel;
}

-(CGRect)bottomlineWidth{
    
    CGRect rect = [self.title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 40) options:NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleFont} context:nil];
    return rect;
}
@end
