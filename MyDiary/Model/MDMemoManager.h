//
//  MDMemoManager.h
//  MyDiary
//
//  Created by Geng on 2017/2/4.
//  Copyright © 2017年 Geng. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface MDMemoEntry : NSObject
@property (nonatomic, copy) NSString *entryName;
@property (nonatomic, assign) BOOL finished;
@end

@interface MDMemo : NSObject
@property (nonatomic, copy) NSString *MemoName;
@property (nonatomic, copy) NSArray<MDMemoEntry*> *memoEntries;
@end

@interface MDMemoManager : NSObject
+ (instancetype)shareInstance;

- (NSArray<MDMemo*>*)getAllMemo;
@end
