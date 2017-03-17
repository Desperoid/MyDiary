//
//  MDDBManager.m
//  MyDiary
//
//  Created by Geng on 2017/2/23.
//  Copyright © 2017年 Geng. All rights reserved.
//

#import "MDDBManager.h"
#import <FMDB.h>
#import "MDFileManager.h"
#import "MDEmergencyContact.h"
#import "MDDiary.h"

@interface MDDBManager ()
@property (nonatomic, strong) FMDatabaseQueue *queue;
@end

@implementation MDDBManager
+ (instancetype)shareInstance
{
    static MDDBManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MDDBManager alloc] initPrivate];
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
        [self createTable];
    }
    return self;
}

- (void)createTable
{
    NSString *createContactorTableSQL = @"CREATE TABLE IF NOT EXISTS contacts(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, phoneNum TEXT);";
    NSString *createDiaryTableSQL = @"CREATE TABLE IF NOT EXISTS diaries(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, content TEXT, date DATETIME, weather TEXT, mood TEXT, longitude DOUBLE, latitude DOUBLE, location TEXT);";
    NSString *createTagTableSQL = @"CREATE TABLE IF NOT EXISTS tags(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)";
    [self.queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            [db executeStatements:[NSString stringWithFormat:@"%@%@%@",createContactorTableSQL, createDiaryTableSQL, createTagTableSQL]];
        }
        [db close];
    }];
}

- (FMDatabaseQueue *)queue
{
    if (!_queue) {
        NSString *dbFilePath = [[MDFileManager shareInstance] getUserDBFilePath];
        _queue = [FMDatabaseQueue databaseQueueWithPath:dbFilePath];
    }
    return _queue;
}
@end

@implementation MDDBManager (MDEmergencyContactsManager)

- (NSArray<MDEmergencyContact*>*)getAllContacts
{
    __block NSMutableArray *contacts = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            FMResultSet* result = [db executeQuery:@"SELECT * FROM contacts"];
            while ([result next]) {
                MDEmergencyContact *contact = [self contactFromDBResutSet:result];
                [contacts addObject:contact];
            }
        }
        [db close];
    }];
    return contacts;
}

- (BOOL)saveNewContact:(MDEmergencyContact*)contact;
{
    __block NSError *error;
    __block BOOL success = NO;
    [self.queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
          success =  [db executeUpdate:@"INSERT INTO contacts (name, phoneNum) VALUES (?, ?)" values:@[contact.contactName, contact.phoneNumber] error:&error];
            if(success) {
               FMResultSet *result = [db executeQuery:@"SELECT last_insert_rowid(), id FROM contacts"];
                if ([result next]) {
                    contact.contactId = [result intForColumn:@"id"];
                }
            }
        }
        [db close];
    }];
    return success;
}

- (MDEmergencyContact*)contactFromDBResutSet:(FMResultSet*)resultSet
{
    MDEmergencyContact *contact = [[MDEmergencyContact alloc] init];
    contact.contactId = [resultSet longLongIntForColumn:@"id"];
    contact.contactName = [resultSet stringForColumn:@"name"];
    contact.phoneNumber = [resultSet stringForColumn:@"phoneNum"];
    return contact;
}

- (BOOL)deleteContact:(MDEmergencyContact *)contact
{
    __block NSError *error;
    __block BOOL success = NO;
    [self.queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            success = [db executeUpdate:@"DELETE FROM contacts WHERE id = ?" values:@[@(contact.contactId)] error:&error];
        }
        [db close];
    }];
    return success;
}

- (BOOL)modifyContact:(MDEmergencyContact*)contact
{
    __block NSError *error;
    __block BOOL success = NO;
    [self.queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            success = [db executeUpdate:@"UPDATE contacts SET name=?,phoneNum=? WHERE id=?" values:@[contact.contactName, contact.phoneNumber, @(contact.contactId)] error:&error];
        }
        [db close];
    }];
    return success;
}


- (NSInteger)getContactsCount
{
    __block NSInteger count = NSNotFound;
    [self.queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            FMResultSet *resut = [db executeQuery:@"SELECT count(id) AS count FROM contacts"];
            if ([resut next]) {
                count = [resut intForColumn:@"count"];
            }
            [db close];
        }
    }];
    return count;
}
@end

@implementation MDDBManager (MDDiaryManager)

- (NSArray<MDDiary *> *)getAllDiaries
{
    __block NSMutableArray *diaries = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM diaries"];
            while ([resultSet next]) {
                MDDiary *diary = [self diaryFromDBResultSet:resultSet];
                [diaries addObject:diary];
            }
        }
        [db close];
    }];
    return diaries;
}

- (void)saveNewDiary:(MDDiary *)diary
{
    __block NSError *error;
    [self.queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString *weather = [self stringFromDiayWeather:diary.weather];
            NSString *mood = [self stringFromDiaryMood:diary.mood];
            [db executeUpdate:@"INSERT INTO diaries (id, title, content, date, weather, mood, longitude, latitude, location) VALUES (?,?,?,?,?,?,?,?,?)" values:@[[NSNull null], diary.diaryTitle, diary.diaryContent, diary.diaryDate, weather,mood, @(diary.coordinate.longitude), @(diary.coordinate.latitude),diary.location] error:&error];
        }
        [db close];
    }];
}

- (void)modifyDiary:(MDDiary *)diary
{
    __block NSError *error;
    [self.queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString *weather = [self stringFromDiayWeather:diary.weather];
            NSString *mood = [self stringFromDiaryMood:diary.mood];
            [db executeQuery:@"UPDATE diaries SET title = ?, content=?, date=?,weather=?,mood=?,longitude=?,latitude=?,location=?" values:@[diary.diaryTitle, diary.diaryContent, diary.diaryDate, weather, mood, @(diary.coordinate.longitude), @(diary.coordinate.latitude), diary.location] error:&error];
        }
        [db close];
    }];
}

- (void)deleteDiary:(MDDiary *)diary
{
    __block NSError *error;
    [self.queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            [db executeUpdate:@"DELETE FROM diaries WHERE id = ?" values:@[@(diary.diaryId)] error:&error];
        }
        [db close];
    }];
}

- (MDDiary*)diaryFromDBResultSet:(FMResultSet*)resultSet
{
    MDDiary *diary = [[MDDiary alloc] init];
    diary.diaryId = [resultSet longLongIntForColumn:@"id"];
    diary.diaryTitle = [resultSet stringForColumn:@"title"];
    diary.diaryContent = [resultSet stringForColumn:@"content"];
    diary.diaryDate = [resultSet dateForColumn:@"date"];
    diary.weather = [self diaryWeatherFromString:[resultSet stringForColumn:@"weather"]];
    diary.mood = [self diaryMoodFromString:[resultSet stringForColumn:@"mood"]];
    double longitude = [resultSet doubleForColumn:@"longitude"];
    double latitude = [resultSet doubleForColumn:@"latitude"];
    MDCoordinate coordinate = {longitude, latitude};
    diary.coordinate = coordinate;
    diary.location = [resultSet stringForColumn:@"location"];
    return diary;
}

- (NSString *)stringFromDiayWeather:(MDDiaryWeather)weather
{
    switch (weather) {
        case MDDiaryWeatherSunny:
            return @"sunny";
            break;
        case MDDiaryWeatherCloud:
            return @"cloud";
        case MDDiaryWeatherfoggy:
            return @"foggy";
        case MDDiaryWeatherRainy:
            return @"rainy";
        case MDDiaryWeatherSnowy:
            return @"snowy";
        case MDDiaryWeatherWindy:
            return @"windy";
        default:
            break;
    }
}

- (MDDiaryWeather)diaryWeatherFromString:(NSString*)string
{
    if ([string compare:@"sunny" options:NSCaseInsensitiveSearch] == NSOrderedSame){
        return MDDiaryWeatherSunny;
    }
    else if ([string compare:@"cloud" options:NSCaseInsensitiveSearch] == NSOrderedSame){
        return MDDiaryWeatherCloud;
    }
    else if ([string compare:@"foggy" options:NSCaseInsensitiveSearch] == NSOrderedSame){
        return MDDiaryWeatherfoggy;
    }
    else if ([string compare:@"rainy" options:NSCaseInsensitiveSearch] == NSOrderedSame){
        return MDDiaryWeatherRainy;
    }
    else if ([string compare:@"windy" options:NSCaseInsensitiveSearch] == NSOrderedSame){
        return MDDiaryWeatherWindy;
    }
    return MDDiaryWeatherSunny;
}

- (NSString *)stringFromDiaryMood:(MDDiaryMood)mood
{
    switch (mood) {
        case MDDiaryMoodHappy:
            return @"happy";
            break;
        case MDDiaryMoodSoso:
            return @"soso";
        case MDDiaryMoodUnhappy:
            return @"unhappy";
        default:
            break;
    }
}

- (MDDiaryMood)diaryMoodFromString:(NSString*)string
{
    if ([string compare:@"happy" options:NSCaseInsensitiveSearch] == NSOrderedSame){
        return MDDiaryMoodHappy;
    }
    else if ([string compare:@"soso" options:NSCaseInsensitiveSearch] == NSOrderedSame){
        return MDDiaryMoodSoso;
    }
    else if ([string compare:@"unhappy" options:NSCaseInsensitiveSearch] == NSOrderedSame){
        return MDDiaryMoodUnhappy;
    }
    return MDDiaryMoodHappy;
}
@end
