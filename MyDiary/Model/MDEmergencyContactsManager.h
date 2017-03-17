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

@protocol MDEmergencyContactsListener <NSObject>
- (void)contactDidModified:(MDEmergencyContact*)contact success:(BOOL)success;
- (void)contactDidDelete:(MDEmergencyContact*)contact success:(BOOL)success;
- (void)contactDidAdded:(MDEmergencyContact*)contact success:(BOOL)success;
@end

@interface MDEmergencyContactsManager : NSObject

+ (instancetype)shareInstance;

- (void)addListener:(id<MDEmergencyContactsListener>)listener;

- (void)removeListener:(id<MDEmergencyContactsListener>)listener;

- (void)getAllContactsFromDB:(void(^)(NSArray<MDEmergencyContact*>* contacts))completeBlock;

- (void)getContactsCount:(void(^)(NSInteger count))completeBlock;

- (void)saveNewContact:(MDEmergencyContact*)contact;

- (void)deleteContact:(MDEmergencyContact*)contact;

- (void)modifyContact:(MDEmergencyContact *)contact;

- (void)readContactsCount:(void(^)(NSInteger count))completeBlock;

@end
