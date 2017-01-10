//
//  MDContactsTableViewCell.h
//  MyDiary
//
//  Created by Geng on 2017/1/9.
//  Copyright © 2017年 Geng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDContactsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;

@end
