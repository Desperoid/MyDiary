//
//  ViewController.m
//  MyDiary
//
//  Created by Geng on 2017/1/5.
//  Copyright © 2017年 Geng. All rights reserved.
//

#import "MDHomeViewController.h"
#import "MDHomeTableViewCell.h"

@interface MDHomeViewController ()
@property (weak, nonatomic) IBOutlet UITableView *homeTableView;

@end

static NSString *const kHomeTableViewCellNibName = @"MDHomeTableViewCell";
static NSString *const kHomeTableViewCellIdentifier = @"homeTableViewCellIdentifier";

@implementation MDHomeViewController

- (void)viewDidLoad {
   [super viewDidLoad];
   [self.homeTableView registerNib:[UINib nibWithNibName:kHomeTableViewCellNibName bundle:nil] forCellReuseIdentifier:kHomeTableViewCellIdentifier];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   MDHomeTableViewCell *homeCell = [self.homeTableView dequeueReusableCellWithIdentifier:kHomeTableViewCellIdentifier];
   if (!homeCell) {
      homeCell = [[NSBundle mainBundle] loadNibNamed:kHomeTableViewCellNibName owner:self options:nil].firstObject;
   }
   return homeCell;
}



@end
