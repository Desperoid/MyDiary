//
//  MDEmergencyContactsManager.m
//  MyDiary
//
//  Created by Geng on 2017/1/10.
//  Copyright © 2017年 Geng. All rights reserved.
//

#import "MDEmergencyContactsManager.h"
#import "MDDBManager.h"

@interface MDEmergencyContactsManager ()
@property (nonatomic, strong) NSMutableArray *allContacts;
@property (nonatomic, strong) dispatch_queue_t queue;
@end

@implementation MDEmergencyContactsManager

+ (instancetype)shareInstance
{
    static MDEmergencyContactsManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MDEmergencyContactsManager alloc] initPrivate];
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
//        _allContacts = [NSMutableArray array];
//        MDEmergencyContact *contact = [[MDEmergencyContact alloc] init];
//        contact.contactName = @"TAKI";
//        contact.phoneNumber = @"425-845156";
//        [_allContacts addObject:contact];
//        MDEmergencyContact *contact1 = [[MDEmergencyContact alloc] init];
//        contact1.contactName = @"TAKI";
//        contact1.phoneNumber = @"425-845156";
//        [_allContacts addObject:contact1];
        
        self.queue = dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL_WITH_AUTORELEASE_POOL);
        [self readAllContactsFromDataBase];
    }
    return self;
}

#pragma mark - public function
- (NSArray<MDEmergencyContact *> *)getAllContacts
{
    return self.allContacts;
}

- (void)saveNewContact:(MDEmergencyContact *)contact
{
    dispatch_async(self.queue, ^{
         [[MDDBManager shareInstance] saveNewContact:contact];
    });
}

- (void)deleteContact:(MDEmergencyContact *)contact
{
    dispatch_async(self.queue, ^{
        [[MDDBManager shareInstance] deleteContact:contact];
    });
}

- (void)modifyContact:(MDEmergencyContact *)contact
{
    dispatch_async(self.queue, ^{
        [[MDDBManager shareInstance] modifyContact:contact];
    });
}

#pragma mark - private funtion

- (void)readAllContactsFromDataBase
{
    dispatch_async(self.queue, ^{
        self.allContacts = [[[MDDBManager shareInstance] getAllContacts] mutableCopy];
    });
}

@end
