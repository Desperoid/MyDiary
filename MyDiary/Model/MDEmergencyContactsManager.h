//
//  MDEmergencyContactsManager.h
//  MyDiary
//
//  Created by Geng on 2017/1/10.
//  Copyright © 2017年 Geng. All rights reserved.
//
//  紧急联系人管理类

#import <Foundation/Foundation.h>
#import "MDEmergencyContact.h"
@interface MDEmergencyContactsManager : NSObject

+ (instancetype)shareInstance;

- (NSArray<MDEmergencyContact*>*)getAllContacts;

- (BOOL)saveNewContact:(MDEmergencyContact*)contact;

- (BOOL)deleteContact:(MDEmergencyContact*)contact;

- (BOOL)modifyContact:(MDEmergencyContact *)contact;

@end
