//
//  MDEntriesListView.m
//  MyDiary
//
//  Created by 周庚 on 2017/1/11.
//  Copyright © 2017年 Geng. All rights reserved.
//

#import "MDEntriesListView.h"
#import "MDDiaryManager.h"
#import "MDEntriesListTableViewCell.h"
static NSString * const kEntriesListTableCellNib = @"MDEntriesListTableViewCell";
static NSString * const kEntriesListTableCellIdentifier = @"entriesListTableViewCellIdentifier";

@interface MDEntriesListView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *entriesTableView; //备忘录tableView
@property (nonatomic, copy) NSMutableArray *diaryEntries;  //日记
@end

static CGFloat kTableViewMargin = 10.0f;
static CGFloat kTableViewHeaderHeight = 30.0f;
static CGFloat kTableViewCellHeight = 65.0f;
@implementation MDEntriesListView

-(instancetype)init
{
    if (self = [self init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.entriesTableView = [[UITableView alloc] initWithFrame:CGRectMake(kTableViewMargin, 0, CGRectGetWidth(self.frame) - kTableViewMargin*2, CGRectGetHeight(self.frame)) style:UITableViewStyleGrouped];
    self.entriesTableView.delegate = self;
    self.entriesTableView.dataSource = self;
    self.entriesTableView.tableFooterView = [[UIView alloc] init];
    [self.entriesTableView registerNib:[UINib nibWithNibName:kEntriesListTableCellNib bundle:nil] forCellReuseIdentifier:kEntriesListTableCellIdentifier];
    self.entriesTableView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.entriesTableView];
    
    self.diaryEntries = [NSMutableArray arrayWithArray:[[MDDiaryManager shareInstance] getAllDiaries]];
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    self.entriesTableView.backgroundColor = [UIColor clearColor];
    self.entriesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MDEntriesListTableViewCell *cell =  [self.entriesTableView dequeueReusableCellWithIdentifier:kEntriesListTableCellIdentifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:kEntriesListTableCellNib owner:self options:nil].firstObject;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableViewCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kTableViewHeaderHeight;
}
@end
