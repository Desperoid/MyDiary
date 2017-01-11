//
//  MDDiaryManager.h
//  MyDiary
//
//  Created by 周庚 on 2017/1/11.
//  Copyright © 2017年 Geng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDDiary.h"

@interface MDDiaryManager : NSObject
+ (instancetype)shareInstance;

- (NSArray<MDDiary*>*)getAllDiaries;

@end
