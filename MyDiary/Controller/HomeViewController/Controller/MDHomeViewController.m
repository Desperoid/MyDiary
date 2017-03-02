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
#import "UIImage+MDProtrait.h"
#import "MDMemoViewController.h"
#import "MDMemoManager.h"

static NSString * const kEmergencyContacts = @"紧急联系人";
static NSString * const kDiary             = @"日记";
static NSString * const kprohibition       = @"禁止事项";

@interface MDHomeTableListItem : NSObject
@property (nonatomic, copy) NSString *listItemName;
@property (nonatomic, assign) NSInteger listItemCount;
@end

@implementation MDHomeTableListItem
@end

@interface MDHomeViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *homeTableView;
@property (nonatomic, strong) NSMutableArray<MDHomeTableListItem*> *listItemsArray;  //tableView表单选项
@property (weak, nonatomic) IBOutlet UIButton *settingButton;     //设置按钮
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;  //搜索textfield
@property (weak, nonatomic) IBOutlet UIImageView *userIconImageView; //头像
@property (weak, nonatomic) IBOutlet UILabel *userShortNameLabel;    //名字
@property (weak, nonatomic) IBOutlet UILabel *userFullNameLabel;     //全名
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footerViewLayoutBottom;  //搜索栏下方与self.view下方的垂直距离
@property (nonatomic, strong) NSArray<MDMemo*> *memosArray;  //备忘录

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

/**
 初始化数据
 */
- (void)initData
{
    self.listItemsArray = [NSMutableArray array];
    
    MDHomeTableListItem *contacts = [[MDHomeTableListItem alloc] init];
    contacts.listItemName = kEmergencyContacts;
    contacts.listItemCount = [[[MDEmergencyContactsManager shareInstance] getAllContacts] count];
    [self.listItemsArray addObject:contacts];
    
    MDHomeTableListItem *diary = [[MDHomeTableListItem alloc] init];
    diary.listItemName = kDiary;
    diary.listItemCount = 0;
    [self.listItemsArray addObject:diary];
    
    self.memosArray = [[MDMemoManager shareInstance] getAllMemo];
    for (int i = 0; i<[self.memosArray count]; i++ ) {
        MDMemo *memo = self.memosArray[i];
        MDHomeTableListItem *memoItem = [[MDHomeTableListItem alloc] init];
        memoItem.listItemName = memo.memoName;
        memoItem.listItemCount = [memo.memoEntries count];
        [self.listItemsArray addObject:memoItem];
    }
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
    self.userIconImageView.image = [UIImage protraitWithImageNamed:@"head_protrait_Mitsuha"];
}

#pragma mark - Target Function
- (IBAction)clickSettingButton:(UIButton *)sender
{
    [self openSetting:sender];
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
    return [self.listItemsArray count];
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
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                [self openEmergencyContacts:cell];
                break;
            case 1:
                [self openDiary:cell];
                break;
            case 2:
                [self openProhibition:cell];
                break;
            default:
                break;
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[MDHomeTableViewCell class]]) {
        MDHomeTableViewCell *homeCell = (MDHomeTableViewCell *)cell;
        if (indexPath.row < [self.listItemsArray count]) {
            NSString *title = self.listItemsArray[indexPath.row].listItemName;
            NSInteger count = self.listItemsArray[indexPath.row].listItemCount;
            homeCell.titleLabel.text = title;
            homeCell.countLabel.text = [NSString stringWithFormat:@"%zd",count];
            if ([title isEqualToString:kEmergencyContacts]) {
                homeCell.headIcon.image = [UIImage imageNamed:@"ic_topic_contacts"];
            }
            else if ([title isEqualToString:kDiary]) {
                homeCell.headIcon.image = [UIImage imageNamed:@"ic_topic_diary"];
            }
            else {
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

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self resignKeyboard];
}

#pragma mark - segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MDHomeTableViewCell *cell = (MDHomeTableViewCell *)sender;
    NSString *title = cell.titleLabel.text;
    NSInteger index = [self.homeTableView indexPathForCell:cell].row - 2;
    if ([segue.identifier isEqualToString:@"presentMemo"]) {
        MDMemoViewController *destController = (MDMemoViewController *)[segue destinationViewController];
        destController.title = title;
        MDMemo *memo =  [[MDMemoManager shareInstance] getAllMemo][index];
        destController.memo = memo;
    }
}

#pragma mark - Private Function

/**
 跳转到紧急联系人页面
 */
- (void)openEmergencyContacts:(id)sender
{
    [self performSegueWithIdentifier:@"presentEmergencyConatacts" sender:nil];
}


/**
 跳转到日记页面
 */
- (void)openDiary:(id)sender
{
    [self performSegueWithIdentifier:@"presentDiary" sender:nil];
}


/**
 跳转到禁止事项
 */
- (void)openProhibition:(id)sender
{
    [self performSegueWithIdentifier:@"presentMemo" sender:sender];
}


/**
 跳转到设置界面
 */
- (void)openSetting:(id)sender
{
    
}

@end
