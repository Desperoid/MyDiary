//
//  MDMemoViewController.h
//  MyDiary
//
//  Created by Geng on 2017/1/17.
//  Copyright © 2017年 Geng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDMemoViewController : UIViewController
@property (nonatomic, copy) NSArray<NSDictionary<NSString*,NSNumber*>*> *allMemoEntries; //@[@{"do something":@(YES)}, @{"do another thing":@(NO)}]
@end
