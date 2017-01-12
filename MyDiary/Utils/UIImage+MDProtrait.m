//
//  UIImage+MDProtrait.m
//  MyDiary
//
//  Created by 周庚 on 2017/1/12.
//  Copyright © 2017年 Geng. All rights reserved.
//

#import "UIImage+MDProtrait.h"

@implementation UIImage (MDProtrait)
+ (instancetype)protraitWithImageNamed:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    CGSize imageSize = image.size;
    //创建图片上下文
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    
    //绘制边框的圆
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(context, CGRectMake(0, 0, imageSize.width, imageSize.height));
    
    //剪切可视范围
    CGContextClip(context);
    
    //绘制头像
    [image drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    
    UIImage *protrait = UIGraphicsGetImageFromCurrentImageContext();
    return protrait;
}
@end
