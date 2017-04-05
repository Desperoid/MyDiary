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
@property (nonatomic, strong) NSHashTable *listeners;
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
        self.listeners = [NSHashTable weakObjectsHashTable];
        self.queue = dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL_WITH_AUTORELEASE_POOL);
        [self readAllContactsFromDataBase];
    }
    return self;
}

#pragma mark - public function

- (void)addListener:(id<MDEmergencyContactsListener>)listener
{
   
    @synchronized (self) {
        [self.listeners addObject:listener];
    }
}

- (void)removeListener:(id<MDEmergencyContactsListener>)listener
{
    @synchronized (self) {
        [self.listeners removeObject:listener];
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
            for (id<MDEmergencyContactsListener> listener in self.listeners) {
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
