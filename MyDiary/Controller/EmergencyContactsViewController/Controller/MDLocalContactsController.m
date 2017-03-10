//
//  MDLocalContactsController.m
//  MyDiary
//
//  Created by Geng on 2017/3/9.
//  Copyright © 2017年 Geng. All rights reserved.
//

#import "MDLocalContactsController.h"
#import <Contacts/Contacts.h>

@interface MDLocalContactsController ()
@property (nonatomic, strong) CNContactStore *contactStore;
@property (nonatomic, strong) NSMutableArray *contactsArray;
@end

@implementation MDLocalContactsController
static NSString * cellIdentifier = @"LocalContactsCellIdentifier";
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self initView];
}

- (void)initData
{
    self.contactStore =  [[CNContactStore alloc] init];
    self.contactsArray = [NSMutableArray array];
    [self.contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            [self fetchContacts];
        }
    }];
}

- (void)initView
{
     [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)fetchContacts
{
    CNContactFormatter *fullNameFormatter = [CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName];
    NSArray *keysToFetch = @[fullNameFormatter, CNContactPhoneNumbersKey, CNContactImageDataKey];
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSError *error;
       if( [self.contactStore enumerateContactsWithFetchRequest:fetchRequest error:&error usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
            if ([contact areKeysAvailable:keysToFetch]) {
                [self.contactsArray addObject:contact];
            }
       }]){
           dispatch_async(dispatch_get_main_queue(), ^{
               [self.tableView reloadData];
           });
       }
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.contactsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    return cell;

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;
    if (index < [self.contactsArray count]) {
        CNContact *contact = self.contactsArray[index];
        NSString *fullName = [CNContactFormatter stringFromContact:contact style:CNContactFormatterStyleFullName];
        NSData *imageData = contact.imageData;
        NSArray *phoneLabels = contact.phoneNumbers;
        cell.textLabel.text = fullName;
        cell.imageView.image = [UIImage imageWithData:imageData];
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
