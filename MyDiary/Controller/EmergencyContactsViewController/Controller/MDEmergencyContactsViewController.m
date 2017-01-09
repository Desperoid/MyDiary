//
//  MDEmergencyContactsViewController.m
//  MyDiary
//
//  Created by Geng on 2017/1/8.
//  Copyright © 2017年 Geng. All rights reserved.
//

#import "MDEmergencyContactsViewController.h"
#import "TableViewIndexView.h"

@interface MDEmergencyContactsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *contactSearchTextField;  //联络人搜索textField
@property (weak, nonatomic) IBOutlet UITableView *contactsTableView;
@property (weak, nonatomic) IBOutlet TableViewIndexView *tableIndexView;   //索引view
@property (nonatomic, strong) NSMutableDictionary<NSString*,NSArray*> *contactsDic;           //联系人名字首字母:联系人数组
@property (nonatomic, strong) NSArray *indexAlphabet;   //索引字母表
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
    self.contactsDic = [NSMutableDictionary dictionary];
    self.indexAlphabet = [UILocalizedIndexedCollation currentCollation].sectionIndexTitles;
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
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.contactsTableView.bounds];
    backgroundView.image = [UIImage imageNamed:@"contacts_bg_mitsuha"];
    self.contactsTableView.backgroundView = backgroundView;
    self.contactsTableView.tableFooterView = [[UIView alloc] init];
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
        if (contacts && [contacts isKindOfClass:[NSArray class]]) {
            return [contacts count];
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UITableViewCell new];
}


@end
