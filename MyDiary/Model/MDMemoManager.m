//
//  MDMemoManager.m
//  MyDiary
//
//  Created by Geng on 2017/2/4.
//  Copyright © 2017年 Geng. All rights reserved.
//

#import "MDMemoManager.h"
#import "MDFileManager.h"

@implementation MDMemoEntry

@end

@implementation MDMemo

@end

@interface MDMemoManager ()
@property (nonatomic, strong) NSMutableArray<MDMemo*> *allMemmo;
@property (nonatomic, strong) NSHashTable *listeners;
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
        self.listeners = [NSHashTable weakObjectsHashTable];
    }
    return self;
}

- (NSArray<MDMemo *> *)getAllMemo
{
    return self.allMemmo;
}

- (MDMemo *)modifyMemo:(MDMemo *)memo withMemoEntries:(NSArray<MDMemoEntry *> *)memoEntries
{
    memo.memoEntries = memoEntries;
    for (int i = 0; i < [self.allMemmo count]; i++) {
        MDMemo *oldmemo = self.allMemmo[i];
        if ([oldmemo.memoName isEqualToString:memo.memoName]) {
            [self.allMemmo replaceObjectAtIndex:i withObject:memo];
            break;
        }
    }
    if (![self saveMemo]) {
        NSLog(@"修改备忘录失败");
    }
    return memo;
}

#pragma mark - 文件相关
- (NSArray<MDMemo*> *)readAllMemo
{
    NSString *memoFilePath = [[MDFileManager shareInstance] getUserMemoFilePath];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:memoFilePath];
    NSArray<NSDictionary*> *memoDictArray = [dic objectForKey:kMemoKey];
    NSMutableArray<MDMemo*> *memos = [NSMutableArray array];
    for (NSDictionary *memoDict in memoDictArray) {
        MDMemo *memo = [self getMemoFromDictionary:memoDict];
        [memos addObject:memo];
    }
    return memos;
}
- (BOOL)saveMemo
{
    NSString *memoFilePath = [[MDFileManager shareInstance] getUserMemoFilePath];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSMutableArray<NSDictionary*> *memoDictArray = [NSMutableArray arrayWithCapacity:[self.allMemmo count]];
    for (MDMemo *memo in self.allMemmo) {
        NSDictionary *memoDic = [self getDictionaryFromMemo:memo];
        [memoDictArray addObject:memoDic];
    }
    [dic setObject:memoDictArray forKey:kMemoKey];
    BOOL saveResult = [dic writeToFile:memoFilePath atomically:YES];
    if (!saveResult) {
        NSLog(@"保存备忘录失败");
    }
    return saveResult;
}

#pragma mark - private function

/**
 NSDictionary转MDMemo

 @param dictionary dictionary
 @return MDMemo
 */
- (MDMemo*)getMemoFromDictionary:(NSDictionary*)dictionary
{
    MDMemo *memo = [[MDMemo alloc] init];
    memo.memoName = [dictionary.allKeys firstObject];
    NSArray<NSDictionary*> *entryPropetyArray = [dictionary objectForKey:memo.memoName];
    NSMutableArray<MDMemoEntry*> *entris = [NSMutableArray array];
    for (NSDictionary* porpertyArray in entryPropetyArray) {
        MDMemoEntry *entry = [self getMemoEntryFromDictionary:porpertyArray];
        [entris addObject:entry];
    }
    memo.memoEntries = entris;
    return memo;
}


/**
 NSDictionary转MDMemoEntry

 @param dicitoanry NSDictionary
 @return MDMemoEntry
 */
- (MDMemoEntry*)getMemoEntryFromDictionary:(NSDictionary*)dicitoanry
{
    MDMemoEntry *entry = [[MDMemoEntry alloc] init];
    entry.entryName = [dicitoanry.allKeys firstObject];
    entry.finished = [[dicitoanry objectForKey:entry.entryName] boolValue];
    return entry;
}


/**
 MDMemo转NSDictionary

 @param memo MDMemo
 @return NSDictionary
 */
- (NSDictionary *)getDictionaryFromMemo:(MDMemo*)memo
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSMutableArray *entryDictsArray = [NSMutableArray arrayWithCapacity:[memo.memoEntries count]];
    for (MDMemoEntry *entry in memo.memoEntries) {
        NSDictionary *entryDic = [self getDictionaryFromMemoEntry:entry];
        [entryDictsArray addObject:entryDic];
    }
    [dic setObject:entryDictsArray forKey:memo.memoName];
    return dic;
}


/**
 MDMemoEntry转NSDictionary

 @param entry MDMemoEntry
 @return NSDictionary
 */
- (NSDictionary *)getDictionaryFromMemoEntry:(MDMemoEntry*)entry
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@(entry.finished) forKey:entry.entryName];
    return dic;
}
#pragma mark MDMemoManagerListener
- (void)notifyListenersMemoModified:(MDMemo*)memo
{
    for (id<MDMemoManagerListener> listener in self.listeners) {
        if (listener && [listener respondsToSelector:@selector(onMemoModified:)]) {
            [listener onMemoModified:memo];
        }
    }
}
@end
