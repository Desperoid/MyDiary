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
@property (nonatomic, copy) NSString *memoName;
@property (nonatomic, copy) NSArray<MDMemoEntry*> *memoEntries;
@end

@interface MDMemoManager : NSObject
+ (instancetype)shareInstance;


/**
 获取所有备忘录

 @return  所有备忘录MDMemo的数组array
 */
- (NSArray<MDMemo*>*)getAllMemo;



/**
 修改备忘录

 @param memo 需要修改的备忘录
 @param memoEntries 修改后的备忘录条目
 @return 修改后的备忘录
 */
- (MDMemo*)modifyMemo:(MDMemo*)memo withMemoEntries:(NSArray<MDMemoEntry*>*)memoEntries;

@end
