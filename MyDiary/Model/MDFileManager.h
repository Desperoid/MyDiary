//
//  MDFileManager.h
//  MyDiary
//
//  Created by Geng on 2017/2/6.
//  Copyright © 2017年 Geng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDFileManager : NSObject
+ (instancetype)shareInstance;


/**
 获取用户文件夹路径

 @return 用户文件夹路径
 */
- (NSString*)getUserFilePath;


extern NSString * const kMemoKey;
/**
 获取用户备忘录文件路径

 @return 用户备忘录文件路径
 */
- (NSString*)getUserMemoFilePath;
@end
