//
//  MDEmergencyContactsViewController.m
//  MyDiary
//
//  Created by Geng on 2017/1/8.
//  Copyright © 2017年 Geng. All rights reserved.
//

#import "MDEmergencyContactsViewController.h"

@interface MDEmergencyContactsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *contactSearchTextField;  //联络人搜索textField

@end

@implementation MDEmergencyContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)initData
{
    
}

- (void)initView
{
    UIImage *img = [UIImage imageNamed:@"ic_search_white_18dp"];
    UIImageView *searchLeftView = [[UIImageView alloc] initWithImage:img];
    searchLeftView.frame = CGRectMake(0, 0, 25, 25);
    self.contactSearchTextField.leftView = searchLeftView;
    self.contactSearchTextField.leftViewMode = UITextFieldViewModeAlways;
}


@end
