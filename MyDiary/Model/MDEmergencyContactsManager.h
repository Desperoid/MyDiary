//
//  MDEmergencyContactsManager.h
//  MyDiary
//
//  Created by Geng on 2017/1/10.
//  Copyright © 2017年 Geng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDEmergencyContact.h"
@interface MDEmergencyContactsManager : NSObject

+ (instancetype)shareInstance;

- (NSArray<MDEmergencyContact*>*)getAllContacts;

@end
