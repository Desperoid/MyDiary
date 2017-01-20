//
//  MDBaseNaivgationController.m
//  MyDiary
//
//  Created by Geng on 2017/1/8.
//  Copyright © 2017年 Geng. All rights reserved.
//

#import "MDBaseNaivgationController.h"

@interface MDBaseNaivgationController ()

@end

@implementation MDBaseNaivgationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //隐藏navigationbar 下方分割线
    [self.navigationBar setShadowImage:[UIImage new]];
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

@end
