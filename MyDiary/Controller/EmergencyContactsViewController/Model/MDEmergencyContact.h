//
//  MDEmergencyContact.h
//  MyDiary
//
//  Created by Geng on 2017/1/10.
//  Copyright © 2017年 Geng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDEmergencyContact : NSObject

@property (nonatomic, assign) NSInteger contactId;
@property (nonatomic, copy)   NSString *contactName;
@property (nonatomic, copy)   NSString *phoneNumber;

@end
