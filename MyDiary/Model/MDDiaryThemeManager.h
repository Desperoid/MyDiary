//
//  MDDiaryThemeManager.h
//  MyDiary
//
//  Created by Geng on 2017/1/18.
//  Copyright © 2017年 Geng. All rights reserved.
//
//  主题管理类

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MDDiaryThemeManager : NSObject
@property (nonatomic, strong) UIColor *themeMainColor;
@property (nonatomic, strong) UIColor *themeTextColor;
+ (instancetype)shareInstance;

@end
