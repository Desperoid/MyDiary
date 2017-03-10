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

- (void)saveNewContact:(MDEmergencyContact*)contact;

- (void)deleteContact:(MDEmergencyContact*)contact;

- (void)modifyContact:(MDEmergencyContact *)contact;

@end
