//
//  MDMemoTableViewCell.h
//  MyDiary
//
//  Created by Geng on 2017/1/19.
//  Copyright © 2017年 Geng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  void(^MemoTableViewCellCallBack)(NSString *memoText);

@interface MDMemoTableViewCell : UITableViewCell
@property (nonatomic, copy) NSString *MemoText;
@property (nonatomic, copy) UIColor *memoTextColor;
@property (nonatomic, assign) BOOL haveFinished;   //是否划线
- (void)editMemoCompletion:(MemoTableViewCellCallBack)callback; //编辑cell内容
@end
