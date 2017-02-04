//
//  MDMemoManager.m
//  MyDiary
//
//  Created by Geng on 2017/2/4.
//  Copyright © 2017年 Geng. All rights reserved.
//

#import "MDMemoManager.h"

@implementation MDMemoEntry

@end

@implementation MDMemo

@end

@interface MDMemoManager ()
@property (nonatomic, strong) NSArray<MDMemo*> *allMemmo;
@end

@implementation MDMemoManager
#pragma mark - life circle
+ (instancetype)shareInstance
{
    static MDMemoManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MDMemoManager alloc] initPrivate];
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
        NSMutableArray *mutarray = [NSMutableArray array];
        MDMemoEntry *entry1 = [[MDMemoEntry alloc] init];
        MDMemoEntry *entry2 = [[MDMemoEntry alloc] init];
        MDMemoEntry *entry3 = [[MDMemoEntry alloc] init];
        
        entry1.entryName = @"胡萝卜";
        entry1.finished = @(YES);
        entry2.entryName = @"茄子";
        entry2.finished = @(NO);
        entry3.entryName = @"黄瓜";
        entry3.finished = @(YES);
        
        MDMemo *memo = [[MDMemo alloc] init];
        memo.MemoName = @"禁止事项";
        memo.memoEntries = mutarray;
        self.allMemmo = @[memo];
    }
    return self;
}

- (NSArray<MDMemo *> *)getAllMemo
{
    return self.allMemmo;
}

@end
