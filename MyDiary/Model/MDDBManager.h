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
- (BOOL)saveNewContact:(MDEmergencyContact*)contact;

- (NSArray<MDEmergencyContact*>*)getAllContacts;

- (BOOL)deleteContact:(MDEmergencyContact*)contact;

- (BOOL)modifyContact:(MDEmergencyContact*)contact;

- (NSInteger)getContactsCount;
@end

@interface MDDBManager (MDDiaryManager)

- (NSArray<MDDiary*>*)getAllDiaries;

- (void)saveNewDiary:(MDDiary*)diary;

- (void)deleteDiary:(MDDiary*)diary;

- (void)modifyDiary:(MDDiary*)diary;
@end
