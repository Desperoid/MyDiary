//
//  MDDiaryThemeManager.m
//  MyDiary
//
//  Created by Geng on 2017/1/18.
//  Copyright © 2017年 Geng. All rights reserved.
//

#import "MDDiaryThemeManager.h"

@implementation MDDiaryThemeManager
+ (instancetype)shareInstance
{
    static MDDiaryThemeManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MDDiaryThemeManager alloc] initPrivate];
    });
    return instance;
}

- (instancetype)initPrivate
{
    if (self = [super init]) {
        //do other initialize
        _themeMainColor = [UIColor colorWithRed:230/255.0 green:141/255.0 blue:133/255.0 alpha:1];
        _themeTextColor = [UIColor whiteColor];
    }
    return self;
}

- (instancetype)init
{
    return [[self class] shareInstance];
}

#pragma mark - setter and getter
- (UIColor *)themeTextColor
{
    return _themeTextColor;
}

- (UIColor *)themeMainColor
{
    return _themeMainColor;
}
@end
