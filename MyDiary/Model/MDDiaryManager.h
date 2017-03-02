//
//  MDDiaryManager.h
//  MyDiary
//
//  Created by 周庚 on 2017/1/11.
//  Copyright © 2017年 Geng. All rights reserved.
//
//  日记管理类

#import <Foundation/Foundation.h>
#import "MDDiary.h"

@interface MDDiaryManager : NSObject
+ (instancetype)shareInstance;

- (NSArray<MDDiary*>*)getAllDiaries;

- (NSArray<MDDiary*>*)getDiariesFromDate:(NSDate*)startDate toDate:(NSDate*)endDate;

- (BOOL)saveNewDary:(MDDiary*)NewDiay;

- (BOOL)modifyDary:(MDDiary*)NewDiay;

@end
