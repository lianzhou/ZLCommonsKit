//
//  JZRecordVideoModel.h
//  e学云
//
//  Created by li_chang_en on 2017/10/16.
//  Copyright © 2017年 李长恩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JZRecordVideoModel : NSObject

/* 文件存储路径 */
@property (nonatomic,strong) NSString *localStorePath;
@property (nonatomic,strong) NSString *localImagePath;
/* 文件在服务器的远程地址 */
@property (nonatomic,strong) NSString *remotePath;
/* 文件物理尺寸 */
@property (nonatomic,assign) CGSize    videoSize;
/* 文件时长 */
@property (nonatomic,assign) NSInteger timeLength;//录制时间

@end
