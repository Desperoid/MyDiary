//
//  MDDiaryManager.m
//  MyDiary
//
//  Created by 周庚 on 2017/1/11.
//  Copyright © 2017年 Geng. All rights reserved.
//

#import "MDDiaryManager.h"

@interface MDDiaryManager ()
@property (nonatomic, strong) NSMutableArray *allDiaries;
@end

@implementation MDDiaryManager
+ (instancetype)shareInstance
{
    static MDDiaryManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MDDiaryManager alloc] initPrivate];
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
        _allDiaries = [NSMutableArray array];
        MDDiary *diary = [[MDDiary alloc] init];
        diary.diaryTitle = @"first diray";
        diary.diaryContent = @"Today is a good day!";
        diary.tags = @[@"first day"];
        diary.weather = MDDiaryWeatherCloud;
        diary.diaryDate = [NSDate date];
        [_allDiaries addObject:diary];
        
        MDDiary *diary1 = [[MDDiary alloc] init];
        diary1.diaryTitle = @"second diray";
        diary1.diaryContent = @"Today is also a good day!";
        diary1.tags = @[@"second day"];
        diary1.weather = MDDiaryWeatherCloud;
        NSDateComponents *components = [[NSDateComponents alloc] init];
        components.day = -1;
        NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        calendar.timeZone = [NSTimeZone localTimeZone];
        calendar.locale = [NSLocale currentLocale];
        diary1.diaryDate = [calendar dateByAddingComponents:components toDate:[NSDate date] options:0];
        [_allDiaries addObject:diary1];
    }
    return self;
}

- (NSArray<MDDiary *> *)getAllDiaries
{
    return self.allDiaries;
}

-(NSArray<MDDiary *> *)getDiariesFromDate:(NSDate *)startDate toDate:(NSDate *)endDate
{
    return  nil;
}

- (BOOL)saveNewDary:(MDDiary*)NewDiay
{
    return YES;
}

- (BOOL)modifyDary:(MDDiary*)NewDiay
{
    return YES;
}

@end
