//
//  MDDBManager.h
//  MyDiary
//
//  Created by Geng on 2017/2/23.
//  Copyright © 2017年 Geng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MDEmergencyContact, MDDiary;
@interface MDDBManager : NSObject
+ (instancetype)shareInstance;
@end

@interface MDDBManager (MDEmergencyContactsManager)
- (void)saveNewContact:(MDEmergencyContact*)contact;

- (NSArray<MDEmergencyContact*>*)getAllContacts;

- (void)deleteContact:(MDEmergencyContact*)contact;
@end

@interface MDDBManager (MDDiaryManager)

- (NSArray<MDDiary*>*)getAllDiaries;

- (void)saveNewDiary:(MDDiary*)diary;

- (void)deleteDiary:(MDDiary*)diary;

- (void)modifyDiary:(MDDiary*)diary;
@end
