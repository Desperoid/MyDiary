//
//  MDHomeTableViewCell.m
//  MyDiary
//
//  Created by Geng on 2017/1/6.
//  Copyright © 2017年 Geng. All rights reserved.
//

#import "MDHomeTableViewCell.h"

@implementation MDHomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //修改customAccessory颜色
    UIImage *image = self.customAccessory.image;
    UIImage *temlateImage =  [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.customAccessory.image = temlateImage;
    self.customAccessory.tintColor = self.titleLabel.textColor;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //修改headIcon颜色
    UIImage *image = self.headIcon.image;
    UIImage *temlateImage =  [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.headIcon.image = temlateImage;
    self.headIcon.tintColor = self.titleLabel.textColor;
}

@end
