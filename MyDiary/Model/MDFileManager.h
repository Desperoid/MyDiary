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
 获取备忘录文件路径

 @return 备忘录文件路径
 */
- (NSString*)getUserMemoFilePath;


/**
 获取联系人文件路径

 @return 联系人文件路径
 */
- (NSString*)getUserContactorFilePath;


/**
 获取日记文件路径

 @return 日记文件路径
 */
- (NSString*)getUserDiaryFilePath;


/**
 获取数据库保存地址

 @return 数据库保存地址
 */
- (NSString*)getUserDBFilePath;
@end
