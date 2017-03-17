//
//  MDEmergencyContactsManager.m
//  MyDiary
//
//  Created by Geng on 2017/1/10.
//  Copyright © 2017年 Geng. All rights reserved.
//

#import "MDEmergencyContactsManager.h"
#import "MDDBManager.h"
#import "WeakObject.h"

@interface MDEmergencyContactsManager ()
@property (nonatomic, strong) NSMutableArray<WeakObject*> *listeners;
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
        self.listeners = [NSMutableArray array];
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

- (void)addListener:(id<MDEmergencyContactsListener>)listener
{
   
    WeakObject *wo = [[WeakObject alloc] init];
    wo.insideObject = listener;
    @synchronized (self) {
        [self.listeners addObject:wo];
    }
}

- (void)removeListener:(id<MDEmergencyContactsListener>)listener
{
    WeakObject *wo = [[WeakObject alloc] init];
    wo.insideObject = listener;
    @synchronized (self) {
        [self.listeners removeObject:wo];
    }
}
-(void)getAllContactsFromDB:(void (^)(NSArray<MDEmergencyContact *> *))completeBlock
{
    dispatch_async(self.queue, ^{
        self.allContacts = [[[MDDBManager shareInstance] getAllContacts] mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completeBlock) {
                completeBlock(self.allContacts);
            }
        });
    });
}

- (void)getContactsCount:(void(^)(NSInteger count))completeBlock
{
    dispatch_async(self.queue, ^{
        self.allContacts = [[[MDDBManager shareInstance] getAllContacts] mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completeBlock) {
                completeBlock([self.allContacts count]);
            }
        });
    });
}

- (void)saveNewContact:(MDEmergencyContact *)contact
{
    dispatch_async(self.queue, ^{
        if (!contact.contactName || !contact.phoneNumber) {
            [self listenerResponseSelector:@selector(contactDidAdded:success:) contact:contact success:NO];
            return ;
        }
        BOOL success = [[MDDBManager shareInstance] saveNewContact:contact];
        [self listenerResponseSelector:@selector(contactDidAdded:success:) contact:contact success:success];
    });
}

- (void)deleteContact:(MDEmergencyContact *)contact
{
    dispatch_async(self.queue, ^{
        BOOL success = [[MDDBManager shareInstance] deleteContact:contact];
        [self listenerResponseSelector:@selector(contactDidDelete:success:) contact:contact success:success];
    });
}

- (void)modifyContact:(MDEmergencyContact *)contact
{
    dispatch_async(self.queue, ^{
        BOOL success = [[MDDBManager shareInstance] modifyContact:contact];
        [self listenerResponseSelector:@selector(contactDidModified:success:) contact:contact success:success];
    });
}

- (void)readContactsCount:(void(^)(NSInteger count))completeBlock
{
    dispatch_async(self.queue, ^{
        NSInteger count = [[MDDBManager shareInstance] getContactsCount];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completeBlock) {
                completeBlock(count);
            }
        });
    });
}

#pragma mark - private funtion

- (void)readAllContactsFromDataBase
{
    dispatch_async(self.queue, ^{
        self.allContacts = [[[MDDBManager shareInstance] getAllContacts] mutableCopy];
    });
}

- (void)listenerResponseSelector:(SEL)selector contact:(MDEmergencyContact*)contact success:(BOOL)success
{
    dispatch_async(dispatch_get_main_queue(), ^{
        @synchronized (self) {
            for (WeakObject* wo in self.listeners) {
                id<MDEmergencyContactsListener> listener = wo.insideObject;
                if (listener && [listener respondsToSelector:selector]) {
                    MDEmergencyContact *param1 = contact;
                    BOOL param2 = success;
                    NSMethodSignature *signature = [[listener class] instanceMethodSignatureForSelector:selector];
                    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
                    [invocation setArgument:&param1 atIndex:2];
                    [invocation setArgument:&param2 atIndex:3];
                    [invocation setSelector:selector];
                    [invocation invokeWithTarget:listener];
                }
            }
        }
    });
}

@end
