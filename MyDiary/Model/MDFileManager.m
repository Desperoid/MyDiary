//
//  MDFileManager.m
//  MyDiary
//
//  Created by Geng on 2017/2/6.
//  Copyright © 2017年 Geng. All rights reserved.
//

#import "MDFileManager.h"

NSString *const kMemoKey = @"Memo";

@interface MDFileManager ()
@property (nonatomic, strong) NSFileManager *fileManger;
@end

@implementation MDFileManager
+ (instancetype)shareInstance
{
    static MDFileManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MDFileManager alloc] initPrivate];
    });
    return instance;
}

- (instancetype)init
{
    return [[self class] shareInstance];
}

- (instancetype)initPrivate
{
    if (self = [super init]) {
        self.fileManger = [NSFileManager defaultManager];
    }
    return self;
}

- (NSString *)getUserFilePath
{
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
}

- (NSString *)getUserMemoFilePath
{
    NSString *mainPath = [self getUserFilePath];
    NSString *filePath = [mainPath stringByAppendingPathComponent:@"memo.plist"];
    if (![self.fileManger fileExistsAtPath:filePath]) {
        NSArray *array = @[@{@"禁止事项":@[]}];
        NSDictionary *dic = @{kMemoKey:array};
        [dic writeToFile:filePath atomically:YES];
    }
    return filePath;
}

- (NSString *)getUserDBFilePath
{
    NSString *mainPath = [self getUserFilePath];
    NSString *filePath = [mainPath stringByAppendingPathComponent:@"MyDiaray.db"];
    return filePath;
}
@end
