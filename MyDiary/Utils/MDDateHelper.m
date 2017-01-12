//
//  MDDateHelper.m
//  MyDiary
//
//  Created by 周庚 on 2017/1/13.
//  Copyright © 2017年 Geng. All rights reserved.
//

#import "MDDateHelper.h"
static NSCalendar *calendar;
static NSDateFormatter *dateFormatter;

@implementation MDDateHelper
+ (NSDateComponents *)dateComponentsWithDate:( NSDate * _Nonnull  )date
{
    if (!calendar) {
       calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        calendar.timeZone = [NSTimeZone localTimeZone];
        calendar.locale = [NSLocale currentLocale];
    }
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitHour|NSCalendarUnitMinute
                                               fromDate:date];
    return components;
}

+ (NSDate *)nextDayFromDay:(NSDate *)date
{
    if (!calendar) {
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        calendar.timeZone = [NSTimeZone localTimeZone];
        calendar.locale = [NSLocale currentLocale];
    }
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = 1;
    return [calendar dateByAddingComponents:components toDate:date options:0];
    
}

+(NSDate *)previousDayFromDay:(NSDate *)date
{
    if (!calendar) {
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        calendar.timeZone = [NSTimeZone localTimeZone];
        calendar.locale = [NSLocale currentLocale];
    }
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = -1;
    return [calendar dateByAddingComponents:components toDate:date options:0];
}

+(NSArray<NSString *> *)getAllWeekDaySymbols
{
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeZone = [NSTimeZone localTimeZone];
        dateFormatter.locale = [NSLocale currentLocale];
    }
    return [dateFormatter shortMonthSymbols];
}
@end
