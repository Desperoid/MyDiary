//
//  MDDateHelper.h
//  MyDiary
//
//  Created by 周庚 on 2017/1/13.
//  Copyright © 2017年 Geng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDDateHelper : NSObject
+ (NSDateComponents * _Nonnull)dateComponentsWithDate:( NSDate * _Nonnull  )date;

+ (NSDate*)nextDayFromDay:(NSDate*)date;

+ (NSDate*)previousDayFromDay:(NSDate*)date;

+ (NSArray<NSString*>*)getAllWeekDaySymbols;
@end
