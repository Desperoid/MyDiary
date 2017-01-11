//
//  ViewController.m
//  MyDiary
//
//  Created by Geng on 2017/1/5.
//  Copyright © 2017年 Geng. All rights reserved.
//

#import "MDHomeViewController.h"
#import "MDHomeTableViewCell.h"
#import "MDEmergencyContactsManager.h"
#import <IQKeyboardManager.h>
#import "MDDiaryViewController.h"

static NSString * const kEmergencyContacts = @"紧急联系人";
static NSString * const kDiary             = @"日记";
static NSString * const kprohibition       = @"禁止事项";

@interface MDHomeViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *homeTableView;
@property (nonatomic, strong) NSMutableDictionary *listItemsDic;  //tableView表单选项
@property (weak, nonatomic) IBOutlet UIButton *settingButton;     //设置按钮
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;  //搜索textfield
@property (weak, nonatomic) IBOutlet UIImageView *userIconImageView; //头像
@property (weak, nonatomic) IBOutlet UILabel *userShortNameLabel;    //名字
@property (weak, nonatomic) IBOutlet UILabel *userFullNameLabel;     //全名
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footerViewLayoutBottom;  //搜索栏下方与self.view下方的垂直距离

@end

static NSString *const kHomeTableViewCellNibName = @"MDHomeTableViewCell";
static NSString *const kHomeTableViewCellIdentifier = @"homeTableViewCellIdentifier";

@implementation MDHomeViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    //监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveKeyBoradShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveKeyBoradHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    
    [self initData];
    [self initView];
}


/**
 初始化数据
 */
- (void)initData
{
    self.listItemsDic = [NSMutableDictionary dictionaryWithDictionary:@{kEmergencyContacts:@(0),
                                                                        kDiary:@(0),
                                                                        kprohibition:@(0)}];
    NSInteger contactsCount = [[[MDEmergencyContactsManager shareInstance] getAllContacts] count];
    [self.listItemsDic setObject:@(contactsCount) forKey:kEmergencyContacts];
}

/**
 初始化界面
 */
- (void)initView
{
    //homeTableView
    self.homeTableView.rowHeight = UITableViewAutomaticDimension;
    self.homeTableView.estimatedRowHeight = 96;
    [self.homeTableView setTableFooterView:[[UIView alloc] init]];
    [self.homeTableView registerNib:[UINib nibWithNibName:kHomeTableViewCellNibName bundle:nil] forCellReuseIdentifier:kHomeTableViewCellIdentifier];
    //settingButton
    UIImage *image = [self.settingButton imageForState:UIControlStateNormal];
    [self.settingButton setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    self.settingButton.tintColor = self.searchTextField.backgroundColor;
    
    //searchTextField
    UIImage *img = [UIImage imageNamed:@"ic_search_white_18dp"];
    UIImageView *searchLeftView = [[UIImageView alloc] initWithImage:img];
    searchLeftView.frame = CGRectMake(0, 0, 25, 25);
    self.searchTextField.leftView = searchLeftView;
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    
    //head icon
}

#pragma mark - Target Function
- (IBAction)clickSettingButton:(UIButton *)sender
{
    [self openSetting];
}

#pragma mark - Notification
- (void)didReceiveKeyBoradShowNotification:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    CGFloat keyboardAniamtionDuraiont = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSUInteger animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    [UIView animateWithDuration:keyboardAniamtionDuraiont delay:0 options:animationCurve animations:^{
        self.footerViewLayoutBottom.constant = CGRectGetHeight(keyboardFrame);
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)didReceiveKeyBoradHideNotification:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    CGFloat keyboardAniamtionDuraiont = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSUInteger animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    [UIView animateWithDuration:keyboardAniamtionDuraiont delay:0 options:animationCurve animations:^{
        self.footerViewLayoutBottom.constant = 0;
        [self.view layoutIfNeeded];
    } completion:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listItemsDic.allKeys count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MDHomeTableViewCell *homeCell = [self.homeTableView dequeueReusableCellWithIdentifier:kHomeTableViewCellIdentifier];
    if (!homeCell) {
        homeCell = [[NSBundle mainBundle] loadNibNamed:kHomeTableViewCellNibName owner:self options:nil].firstObject;
    }
    return homeCell;
}

#pragma mark - UITableviewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                [self openEmergencyContacts];
                break;
            case 1:
                [self openDiary];
            case 2:
                [self openProhibition];
            default:
                break;
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[MDHomeTableViewCell class]]) {
        MDHomeTableViewCell *homeCell = (MDHomeTableViewCell *)cell;
        NSArray *allKeys = [self.listItemsDic allKeys];
        if (indexPath.row < [allKeys count]) {
            NSString *title = allKeys[indexPath.row];
            NSInteger count = [self.listItemsDic[title] integerValue];
            homeCell.titleLabel.text = title;
            homeCell.countLabel.text = [NSString stringWithFormat:@"%zd",count];
            if ([title isEqualToString:kEmergencyContacts]) {
                homeCell.headIcon.image = [UIImage imageNamed:@"ic_topic_contacts"];
            }
            else if ([title isEqualToString:kDiary]) {
                homeCell.headIcon.image = [UIImage imageNamed:@"ic_topic_diary"];
            }
            else if ([title isEqualToString:kprohibition]) {
                homeCell.headIcon.image = [UIImage imageNamed:@"ic_topic_memo"];
            }
        }
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

#pragma mark - Private Function

/**
 跳转到紧急联系人页面
 */
- (void)openEmergencyContacts
{
    [self performSegueWithIdentifier:@"presentEmergencyConatacts" sender:nil];
}


/**
 跳转到日记页面
 */
- (void)openDiary
{
    [self performSegueWithIdentifier:@"presentDiary" sender:nil];
}


/**
 跳转到禁止事项
 */
- (void)openProhibition
{
    
}


/**
 跳转到设置界面
 */
- (void)openSetting
{
    
}

@end
