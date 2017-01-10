//
//  MDEmergencyContactsViewController.m
//  MyDiary
//
//  Created by Geng on 2017/1/8.
//  Copyright © 2017年 Geng. All rights reserved.
//

#import "MDEmergencyContactsViewController.h"
#import "TableViewIndexView.h"
#import "MDContactsTableViewCell.h"
#import "MDEmergencyContactsManager.h"
#import "MDBaseToolBar.h"

static NSString *const kContactsTableViewCellNibName = @"MDContactsTableViewCell";
static NSString *const kContactsTableViewCellNibIdentifier = @"MDContactsTableViewCellIdentifier";
static NSString *const kTableViewCellIdentifier = @"tableViewCellIdentifier";
static NSInteger kCellHeight = 60;
static NSInteger kCellGap = 20;
static NSInteger kSectionHeaderHeight = 20;
static NSInteger kSectionFooterHeight = 0.5;

@interface MDEmergencyContactsViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *contactSearchTextField;  //联络人搜索textField
@property (weak, nonatomic) IBOutlet UITableView *contactsTableView;
@property (weak, nonatomic) IBOutlet TableViewIndexView *tableIndexView;   //索引view
@property (weak, nonatomic) IBOutlet UIImageView *bodyViewBackgroundImageView;//联系人列表背景ImageView

@property (weak, nonatomic) IBOutlet MDBaseToolBar *toolbar; //下方toolbar
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutToolbarBottom; //toolbar下边约束
@property (nonatomic, strong) NSMutableDictionary<NSString*,NSMutableArray*> *contactsDic;           //联系人名字首字母:联系人数组
@property (nonatomic, strong) NSArray *indexAlphabet;   //索引字母表
@property (nonatomic, copy) NSArray *emergencyContacts;  //紧急联系人
@end

@implementation MDEmergencyContactsViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveKeyboardShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveKeyboardHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    self.indexAlphabet = [UILocalizedIndexedCollation currentCollation].sectionIndexTitles;
    self.contactsDic = [NSMutableDictionary dictionaryWithCapacity:[self.indexAlphabet count]];
    for (NSString *alphabet in self.indexAlphabet) {
        NSMutableArray *mutArray = [NSMutableArray array];
        [self.contactsDic setObject:mutArray forKey:alphabet];
    }
    self.emergencyContacts = [[MDEmergencyContactsManager shareInstance] getAllContacts];
    [self classContacts];
}

- (void)initView
{
    //naviagationbar titleView
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    titleLabel.textColor = self.navigationItem.rightBarButtonItems.firstObject.tintColor;
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"紧急联系人";
    self.navigationItem.titleView = titleLabel;
    
    //searchTextField
    UIImage *img = [UIImage imageNamed:@"ic_search_white_18dp"];
    UIImageView *searchLeftView = [[UIImageView alloc] initWithImage:img];
    searchLeftView.frame = CGRectMake(0, 0, 25, 25);
    self.contactSearchTextField.leftView = searchLeftView;
    self.contactSearchTextField.leftViewMode = UITextFieldViewModeAlways;
    
    //tableIndexView
    self.tableIndexView.indexArray = self.indexAlphabet;
    self.tableIndexView.textAlignment = NSTextAlignmentCenter;
    self.tableIndexView.textColor = [UIColor whiteColor];
    __weak __typeof(self) weakSelf = self;
    self.tableIndexView.touchCallBack = ^(NSUInteger index){
        typeof(self) strongSelf = weakSelf;
        if (index < [strongSelf.contactsTableView numberOfSections]) {
            [strongSelf.contactsTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:NSIntegerMax inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    };
    
    //tableview
    self.contactsTableView.tableFooterView = [[UIView alloc] init];
    [self.contactsTableView registerNib:[UINib nibWithNibName:kContactsTableViewCellNibName bundle:nil] forCellReuseIdentifier:kContactsTableViewCellNibIdentifier];
    [self.contactsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kTableViewCellIdentifier];
    

    //bodyViewBackgroundImageView
    self.bodyViewBackgroundImageView.image = [UIImage imageNamed:@"contacts_bg_mitsuha"];
    
    //toolbar
    [self.toolbar.menuButton addTarget:self action:@selector(clickMenuButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolbar.writeButton addTarget:self action:@selector(clickWriteDiaryButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolbar.cameraButton addTarget:self action:@selector(clickCameraButton:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - Target Function
- (void)clickMenuButton:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickWriteDiaryButton:(UIButton *)sender
{
}

- (void)clickCameraButton:(UIButton *)sender
{
    
}
- (IBAction)searchTextfieldContentChanged:(UITextField *)sender
{
    NSLog(@"%@",sender.text);
}

#pragma mark - Notification
- (void)recieveKeyboardShowNotification:(NSNotification *)notification
{
    if ([self.contactSearchTextField isFirstResponder]) {
        NSDictionary *userInfo = notification.userInfo;
        CGFloat keyboardAniamtionDuraiont = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        CGRect keyboardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        NSUInteger animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
        [UIView animateWithDuration:keyboardAniamtionDuraiont delay:0 options:animationCurve animations:^{
            self.layoutToolbarBottom.constant = CGRectGetHeight(keyboardFrame);
            [self.view layoutIfNeeded];
        } completion:nil];
    }
}

- (void)recieveKeyboardHideNotification:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    CGFloat keyboardAniamtionDuraiont = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSUInteger animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    [UIView animateWithDuration:keyboardAniamtionDuraiont delay:0 options:animationCurve animations:^{
        self.layoutToolbarBottom.constant = 0;
        [self.view layoutIfNeeded];
    } completion:nil];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.indexAlphabet count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section < [self.indexAlphabet count]) {
        NSString *index = self.indexAlphabet[section];
        NSArray *contacts = self.contactsDic[index];
        if (contacts && [contacts isKindOfClass:[NSArray class]] && [contacts count] > 0) {
            return [contacts count]*2-1;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2 == 0) {
        MDContactsTableViewCell *cell = [self.contactsTableView dequeueReusableCellWithIdentifier:kContactsTableViewCellNibIdentifier];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:kContactsTableViewCellNibName owner:self options:nil].firstObject;
        }
        return cell;
    }
    else {
        UITableViewCell *cell= [self.contactsTableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, kSectionHeaderHeight)];
    headerView.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] initWithFrame:headerView.frame];
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = [UIColor whiteColor];
    label.text = self.indexAlphabet[section];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [headerView addSubview:label];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, kSectionFooterHeight)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    return footerView;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[MDContactsTableViewCell class]]) {
        MDContactsTableViewCell *cTabelViewCell = (MDContactsTableViewCell *)cell;
        MDEmergencyContact *contact = [self getContactWithIndexPath:indexPath];
        cTabelViewCell.nameLabel.text = contact.contactName;
        cTabelViewCell.telLabel.text = contact.phoneNumber;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0) {
        return kCellHeight;
    }
    return kCellGap;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kSectionHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return kSectionFooterHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //点击空白处
    if (indexPath.row%2 != 0) {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MDEmergencyContact *contact = [self getContactWithIndexPath:indexPath];
    NSString *phoneNumebr = contact.phoneNumber;
    if (contact.phoneNumber && contact.phoneNumber > 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNumebr]] options:@{} completionHandler:nil];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0) {
        return YES;
    }
    return NO;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction * deleAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除该联系人吗" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [tableView setEditing:NO animated:YES];
        }];
        
        UIAlertAction * exitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [tableView setEditing:NO animated:YES];
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:exitAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }];
    deleAction.backgroundColor = [UIColor clearColor];
    
    return @[deleAction];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - privateFunction

- (MDEmergencyContact *)getContactWithIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section < [self.indexAlphabet count]) {
        NSMutableArray *array = [self.contactsDic objectForKey:self.indexAlphabet[indexPath.section]];
        if (indexPath.row/2 < [array count]) {
            return array[indexPath.row/2];
        }
    }
    return nil;
}


/**
 对所有联系人根据名字首字母进行分类
 */
- (void)classContacts
{
    //获得当前UILocalizedIndexedCollation对象并且引用赋给collation,A-Z的数据
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    //获得索引数和section标题数
    NSInteger index, sectionTitlesCount = [[collation sectionTitles] count];
    
    //将用户数据进行分类，存储到对应的sesion数组中
    for (MDEmergencyContact *contcts in self.emergencyContacts) {
        
        //根据timezone的localename，获得对应的的section number
        NSInteger sectionNumber = [collation sectionForObject:contcts collationStringSelector:@selector(contactName)];
        
        //获得section的数组
        NSMutableArray *sectionUserObjs = [self.contactsDic objectForKey:[collation sectionIndexTitles][sectionNumber]];
        
        //添加内容到section中
        [sectionUserObjs addObject:contcts];
    }
    
    //排序，对每个已经分类的数组中的数据进行排序，如果仅仅只是分类的话可以不用这步
    for (index = 0; index < sectionTitlesCount; index++) {
        NSString *alphabet = [collation sectionIndexTitles][index];
        
        NSMutableArray *userObjsArrayForSection = [self.contactsDic objectForKey:alphabet];
        
        //获得排序结果
        NSArray *sortedUserObjsArrayForSection = [collation sortedArrayFromArray:userObjsArrayForSection collationStringSelector:@selector(contactName)];
        
        //替换原来数组
        [self.contactsDic setObject:[sortedUserObjsArrayForSection mutableCopy] forKey:alphabet];
    }
}


@end