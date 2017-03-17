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
#import "UIImage+MDProtrait.h"

static NSString *const kContactsTableViewCellNibName = @"MDContactsTableViewCell";
static NSString *const kContactsTableViewCellNibIdentifier = @"MDContactsTableViewCellIdentifier";
static NSString *const kTableViewCellIdentifier = @"tableViewCellIdentifier";
static CGFloat kCellHeight = 60;
static CGFloat kCellGap = 20;
static CGFloat kSectionHeaderHeight = 60;
static CGFloat kSectionFooterHeight = 1;

@interface MDEmergencyContactsViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, MDEmergencyContactsListener>
@property (weak, nonatomic) IBOutlet UITextField *contactSearchTextField;  //联络人搜索textField
@property (weak, nonatomic) IBOutlet UITableView *contactsTableView;
@property (weak, nonatomic) IBOutlet TableViewIndexView *tableIndexView;   //索引view
@property (weak, nonatomic) IBOutlet UIImageView *bodyViewBackgroundImageView;//联系人列表背景ImageView

@property (weak, nonatomic) IBOutlet MDBaseToolBar *toolbar; //下方toolbar
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutToolbarBottom; //toolbar下边约束
@property (nonatomic, strong) NSMutableDictionary<NSString*,NSMutableArray*> *contactsDic;           //联系人名字首字母:联系人数组
@property (nonatomic, strong) NSArray *indexAlphabet;   //索引字母表
@property (nonatomic, copy) NSMutableArray *emergencyContacts;  //紧急联系人
@property (nonatomic, copy) NSString *myNewcontactName;    //新联系人名字
@property (nonatomic, copy) NSString *myNewcontactPhoneNum; //新联系人电话
@end

@implementation MDEmergencyContactsViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[MDEmergencyContactsManager shareInstance] removeListener:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    [self initView];
}

- (void)initData
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveKeyboardShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveKeyboardHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    [[MDEmergencyContactsManager shareInstance] addListener:self];
    self.indexAlphabet = [UILocalizedIndexedCollation currentCollation].sectionIndexTitles;
    self.contactsDic = [NSMutableDictionary dictionaryWithCapacity:[self.indexAlphabet count]];
    [self reloadContactData];
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
    
    self.navigationItem.hidesBackButton = YES;
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
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
    [self.navigationController popViewControllerAnimated:YES];
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
- (IBAction)addContactButtonDidClicked:(UIBarButtonItem *)sender
{
    //显示action sheet
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *addContactFromLocalContacts = [UIAlertAction actionWithTitle:@"从手机联系人中添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self performSegueWithIdentifier:@"showLocalContacts" sender:sender];
    }];
    UIAlertAction *newContact = [UIAlertAction actionWithTitle:@"创建联系人" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showCreateNewContactView];
    }];
    [actionSheet addAction:cancel];
    [actionSheet addAction:addContactFromLocalContacts];
    [actionSheet addAction:newContact];
    [self presentViewController:actionSheet animated:YES completion:nil];
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

    if (section < [self.indexAlphabet count]) {
        NSString *index = self.indexAlphabet[section];
        NSArray *contacts = self.contactsDic[index];
        if (contacts && [contacts isKindOfClass:[NSArray class]] && [contacts count] > 0) {
            return nil;
        }
    }
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
        cTabelViewCell.icon.image = [UIImage protraitWithImageNamed:@"head_protrait_TAKI"];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //点击空白处
    if (indexPath.row%2 != 0) {
        return;
    }
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
    MDEmergencyContact *contact = [self getContactWithIndexPath:indexPath];
    UITableViewRowAction * deleAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除该联系人吗" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [tableView setEditing:NO animated:YES];
        }];
        
        UIAlertAction * exitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [tableView setEditing:NO animated:YES];
            [[MDEmergencyContactsManager shareInstance] deleteContact:contact];
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

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self resignKeyboard];
}

#pragma mark - MDEmergencyContactsListener

- (void)contactDidModified:(MDEmergencyContact *)contact success:(BOOL)success
{
    if (!success) {
        return;
    }
    NSUInteger index = NSNotFound;
    for (int i = 0 ;i<[self.emergencyContacts count]; i++) {
        MDEmergencyContact *oldContact = self.emergencyContacts[i];
        if (oldContact.contactId == contact.contactId) {
            index = i;
            break;
        }
    }
    if (index != NSNotFound) {
        MDEmergencyContact *oldContact = self.emergencyContacts[index];
        oldContact.contactName = contact.contactName;
        oldContact.phoneNumber = contact.phoneNumber;
        [self.contactsTableView reloadData];
    }
    else {
        [self reloadContactData];
    }
}

- (void)contactDidDelete:(MDEmergencyContact *)contact success:(BOOL)success
{
    if (!success) {
        return;
    }
    NSUInteger index = NSNotFound;
    for (int i = 0 ;i<[self.emergencyContacts count]; i++) {
        MDEmergencyContact *oldContact = self.emergencyContacts[i];
        if (oldContact.contactId == contact.contactId) {
            index = i;
            break;
        }
    }
    if (index != NSNotFound) {
        [self.emergencyContacts removeObjectAtIndex:index];
        self.contactsDic = [[self classContactsWithNewContacts:self.emergencyContacts] mutableCopy];
        [self.contactsTableView reloadData];
    }
    else {
        [self reloadContactData];
    }
}

- (void)contactDidAdded:(MDEmergencyContact *)contact success:(BOOL)success
{
    if (!success) {
        return;
    }
    [self.emergencyContacts addObject:contact];
    self.contactsDic = [[self classContactsWithNewContacts:self.emergencyContacts] mutableCopy];
    [self.contactsTableView reloadData];
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

- (void)reloadContactData
{
    [[MDEmergencyContactsManager shareInstance] getAllContactsFromDB:^(NSArray<MDEmergencyContact *> *contacts) {
        self.emergencyContacts = [NSMutableArray arrayWithArray:contacts];
        self.contactsDic = [[self classContactsWithNewContacts:self.emergencyContacts] mutableCopy];
        [self.contactsTableView reloadData];
    }];
}


/**
 对所有联系人根据名字首字母进行分类
 */
- (NSDictionary*)classContactsWithNewContacts:(NSArray*)newContacts
{
    NSMutableDictionary *mutaDic = [NSMutableDictionary dictionary];
    NSArray *indexAlphabet = [UILocalizedIndexedCollation currentCollation].sectionIndexTitles;
    for (NSString *alphabet in indexAlphabet) {
        NSMutableArray *mutArray = [NSMutableArray array];
        [mutaDic setObject:mutArray forKey:alphabet];
    }
    //获得当前UILocalizedIndexedCollation对象并且引用赋给collation,A-Z的数据
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    //获得索引数和section标题数
    NSInteger index, sectionTitlesCount = [[collation sectionTitles] count];
    
    //将用户数据进行分类，存储到对应的sesion数组中
    for (MDEmergencyContact *contcts in newContacts) {
        
        //根据timezone的localename，获得对应的的section number
        NSInteger sectionNumber = [collation sectionForObject:contcts collationStringSelector:@selector(contactName)];
        
        //获得section的数组
        NSMutableArray *sectionUserObjs = [mutaDic objectForKey:[collation sectionIndexTitles][sectionNumber]];
        
        //添加内容到section中
        [sectionUserObjs addObject:contcts];
    }
    
    //排序，对每个已经分类的数组中的数据进行排序，如果仅仅只是分类的话可以不用这步
    for (index = 0; index < sectionTitlesCount; index++) {
        NSString *alphabet = [collation sectionIndexTitles][index];
        
        NSMutableArray *userObjsArrayForSection = [mutaDic objectForKey:alphabet];
        
        //获得排序结果
        NSArray *sortedUserObjsArrayForSection = [collation sortedArrayFromArray:userObjsArrayForSection collationStringSelector:@selector(contactName)];
        
        //替换原来数组
        [mutaDic setObject:[sortedUserObjsArrayForSection mutableCopy] forKey:alphabet];
    }
    return mutaDic;
}

- (void)showCreateNewContactView
{
    UIAlertController *alertController =  [UIAlertController alertControllerWithTitle:@"创建联系人" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        MDEmergencyContact *contact = [[MDEmergencyContact alloc] init];
        contact.contactName = self.myNewcontactName;
        contact.phoneNumber = self.myNewcontactPhoneNum;
        [[MDEmergencyContactsManager shareInstance] saveNewContact:contact];
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"姓名";
        textField.text = self.myNewcontactName;
        textField.keyboardType = UIKeyboardTypeDefault;
        [textField addTarget:self action:@selector(inputNewContactName:) forControlEvents:UIControlEventEditingChanged];
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = self.myNewcontactPhoneNum;
        textField.keyboardType = UIKeyboardTypePhonePad;
        textField.placeholder = @"手机号码";
        [textField addTarget:self action:@selector(inputNewContactPhoneNum:) forControlEvents:UIControlEventEditingChanged];
    }];
    [alertController addAction:cancel];
    [alertController addAction:confirm];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)inputNewContactName:(UITextField*)textfield
{
    self.myNewcontactName = textfield.text;
}

- (void)inputNewContactPhoneNum:(UITextField*)textfield
{
    self.myNewcontactPhoneNum = textfield.text;
}

- (void)setEmergencyContacts:(NSMutableArray *)emergencyContacts
{
    _emergencyContacts = emergencyContacts;
}

@end
