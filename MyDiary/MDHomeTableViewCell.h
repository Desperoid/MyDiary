//
//  MDHomeTableViewCell.h
//  MyDiary
//
//  Created by Geng on 2017/1/6.
//  Copyright © 2017年 Geng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDHomeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headIcon; //头像
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;  //标题
@property (weak, nonatomic) IBOutlet UILabel *countLabel; //数字
@property (weak, nonatomic) IBOutlet UIImageView *customAccessory; //自定义accessory箭头

@end
