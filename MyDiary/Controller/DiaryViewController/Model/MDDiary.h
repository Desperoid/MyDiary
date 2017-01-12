//
//  MDEntry.h
//  MyDiary
//
//  Created by 周庚 on 2017/1/11.
//  Copyright © 2017年 Geng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MDDiaryWeather) {
    MDDiaryWeatherSunny,
    MDDiaryWeatherCloud,
    MDDiaryWeatherRainy,
    MDDiaryWeatherSnowy,
    MDDiaryWeatherWindy,
    MDDiaryWeatherfoggy,
};

@interface MDDiary : NSObject
NS_ASSUME_NONNULL_BEGIN
@property (nonatomic, strong) NSString *diaryTitle;
@property (nonatomic, strong) NSString *diaryContent;
@property (nonatomic, strong) NSDate   *diaryDate;
@property (nonatomic, assign) MDDiaryWeather weather;
@property (nonatomic, copy)   NSArray<NSString*> *tags;
NS_ASSUME_NONNULL_END
@end
