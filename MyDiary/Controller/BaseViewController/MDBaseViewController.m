//
//  MDBaseViewController.m
//  MyDiary
//
//  Created by Geng on 2017/1/6.
//  Copyright © 2017年 Geng. All rights reserved.
//

#import "MDBaseViewController.h"

@interface MDBaseViewController ()<UIGestureRecognizerDelegate>

@end

@implementation MDBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.navigationController.interactivePopGestureRecognizer &&
        [self.navigationController.viewControllers count] <= 1) {
        return NO;
    }
    return YES;
}

@end
