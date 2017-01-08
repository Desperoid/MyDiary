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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLayoutSubviews
{
    for (UIView *view in self.navigationBar.subviews) {
        if (view.frame.size.height <= 1.0) {
            view.hidden = YES;
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
