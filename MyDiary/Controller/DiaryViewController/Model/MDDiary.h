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

typedef NS_ENUM(NSUInteger, MDDiaryMood) {
    MDDiaryMoodHappy,
    MDDiaryMoodSoso,
    MDDiaryMoodUnhappy,
};
typedef struct MDCoordinate {
    double longitude;
    double latitude;
}MDCoordinate;

@interface MDDiary : NSObject
NS_ASSUME_NONNULL_BEGIN
@property (nonatomic, assign) NSInteger diaryId;   //id
@property (nonatomic, strong) NSString *diaryTitle;  //标题
@property (nonatomic, strong) NSString *diaryContent; //内容
@property (nonatomic, strong) NSDate   *diaryDate;    //日期
@property (nonatomic, assign) MDDiaryWeather weather;  //天气
@property (nonatomic, assign) MDDiaryMood mood;        //心情
@property (nonatomic, copy)   NSArray<NSString*> *tags; //日记标签
@property (nonatomic, assign) MDCoordinate coordinate; //经纬度坐标
@property (nonatomic, strong) NSString *location;      //具体位置
NS_ASSUME_NONNULL_END
@end
