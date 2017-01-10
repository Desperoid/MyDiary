//
//  MDEmergencyContactsManager.m
//  MyDiary
//
//  Created by Geng on 2017/1/10.
//  Copyright © 2017年 Geng. All rights reserved.
//

#import "MDEmergencyContactsManager.h"

@interface MDEmergencyContactsManager ()
@property (nonatomic, strong) NSMutableArray *allContacts;
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
        _allContacts = [NSMutableArray array];
        MDEmergencyContact *contact = [[MDEmergencyContact alloc] init];
        contact.contactName = @"TAKI";
        contact.phoneNumber = @"425-845156";
        [_allContacts addObject:contact];
        MDEmergencyContact *contact1 = [[MDEmergencyContact alloc] init];
        contact1.contactName = @"TAKI";
        contact1.phoneNumber = @"425-845156";
        [_allContacts addObject:contact1];
    }
    return self;
}

- (NSArray<MDEmergencyContact *> *)getAllContacts
{
    return self.allContacts;
}

@end
