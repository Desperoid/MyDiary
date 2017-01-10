//
//  MDContactsTableViewCell.m
//  MyDiary
//
//  Created by Geng on 2017/1/9.
//  Copyright © 2017年 Geng. All rights reserved.
//

#import "MDContactsTableViewCell.h"

@implementation MDContactsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius = 5.0f;
    self.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
