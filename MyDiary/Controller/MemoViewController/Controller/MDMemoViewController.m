//
//  MDMemoViewController.m
//  MyDiary
//
//  Created by Geng on 2017/1/17.
//  Copyright © 2017年 Geng. All rights reserved.
//

#import "MDMemoViewController.h"
#import "MDDiaryThemeManager.h"
#import "MDMemoTableViewCell.h"

@interface MDMemoViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *memoTableView;
@property (nonatomic, assign) BOOL isEditMemo;  //正在编辑备忘录
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@end

static NSString *const kMemoTableViewCellIdentifier = @"MemoTableViewCellIdentifier";
static NSString *const kMemoTableViewCellName = @"MDMemoTableViewCell";
@implementation MDMemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBarTintColor:[[MDDiaryThemeManager shareInstance] themeMainColor]];
    [self.navigationController.navigationBar setTintColor:[[MDDiaryThemeManager shareInstance] themeTextColor]];
    [self initData];
    [self initView];
}

- (void)initData
{
    
}

- (void)initView
{
    //tableview
    self.memoTableView.tableFooterView = [[UIView alloc] init];
    [self.memoTableView registerNib:[UINib nibWithNibName:kMemoTableViewCellName bundle:nil] forCellReuseIdentifier:kMemoTableViewCellIdentifier];
    self.memoTableView.rowHeight = 60.0f;
    
    //tap
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInView)];
    [self.view addGestureRecognizer:self.tap];
    self.tap.enabled = NO;
}

#pragma mark - target action
- (void)tapInView
{
    if (self.isEditMemo) {
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.allMemos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MDMemoTableViewCell *memoCell = [self.memoTableView dequeueReusableCellWithIdentifier:kMemoTableViewCellIdentifier];
    memoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return memoCell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[MDMemoTableViewCell class]]) {
        MDMemoTableViewCell *memoCell = (MDMemoTableViewCell *)cell;
        memoCell.memoTextColor = [[MDDiaryThemeManager shareInstance] themeMainColor];
        NSInteger index = indexPath.row;
        if (index < [[self.allMemos allKeys] count]) {
            NSString *memoString = [self.allMemos allKeys][index];
            NSNumber *finished = [self.allMemos allValues][index];
            memoCell.MemoText = memoString;
            if ([finished boolValue]) {
                memoCell.haveFinished = YES;
            }
            else {
                memoCell.haveFinished = NO;
            }
        }
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[MDMemoTableViewCell class]]) {
        MDMemoTableViewCell *memoCell = (MDMemoTableViewCell *)cell;
        memoCell.haveFinished = !memoCell.haveFinished;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isEditMemo) {
        return UITableViewCellEditingStyleNone;
    }
    return UITableViewCellEditingStyleDelete;
}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //删除
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        UIAlertController *alertConroller = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除此条记录" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [tableView setEditing:NO animated:YES];
        }];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [tableView setEditing:NO animated:YES];
            //todo:删除该条记录
        }];
        [alertConroller addAction:cancelAction];
        [alertConroller addAction:confirmAction];
        [self presentViewController:alertConroller animated:YES completion:nil];
    }];
    //编辑
    __weak __typeof(self) weakSelf = self;
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
         __strong __typeof(self) strongSelf = weakSelf;
        [tableView setEditing:NO animated:YES];
        [tableView setScrollEnabled:NO];
        if ([cell isKindOfClass:[MDMemoTableViewCell class]]) {
            MDMemoTableViewCell *memoCell = (MDMemoTableViewCell*)cell;
            strongSelf.isEditMemo = YES;
            strongSelf.tap.enabled = YES;
            memoCell.haveFinished = NO;
            [memoCell editMemoCompletion:^(NSString *memoText) {
                strongSelf.tap.enabled = NO;
                [tableView setScrollEnabled:YES];
                NSMutableArray *keys = [NSMutableArray arrayWithArray:[strongSelf.allMemos allKeys]];
                NSMutableArray *values = [NSMutableArray arrayWithArray:[strongSelf.allMemos allValues]];
                [keys replaceObjectAtIndex:indexPath.row withObject:memoText];
                strongSelf.allMemos = [NSDictionary dictionaryWithObjects:values forKeys:keys];
                strongSelf.isEditMemo = NO;
            }];
        }
        
    }];
    return @[deleteAction,editAction];
}

@end
