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
@property (nonatomic, copy) NSArray<MDMemoEntry*> *entriesInTable; //显示在table列表中的entry
@end

static NSString *const kMemoTableViewCellIdentifier = @"MemoTableViewCellIdentifier";
static NSString *const kMemoTableViewCellName = @"MDMemoTableViewCell";
@implementation MDMemoViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //离开页面时保存修改
    [[MDMemoManager shareInstance] modifyMemo:self.memo withMemoEntries:self.entriesInTable];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initView];
}

- (void)initData
{
    self.entriesInTable = self.memo.memoEntries;
}

- (void)initView
{
    //navigationbar
    [self.navigationController.navigationBar setBarTintColor:[[MDDiaryThemeManager shareInstance] themeMainColor]];
    [self.navigationController.navigationBar setTintColor:[[MDDiaryThemeManager shareInstance] themeTextColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[[MDDiaryThemeManager shareInstance] themeTextColor]}];
    
    //自定义返回按钮
    UIBarButtonItem *customBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"pk_back_btn"] style:UIBarButtonItemStylePlain target:self action:@selector(popSelf)];
    self.navigationItem.leftBarButtonItem = customBackButton;
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
        [self resignKeyboard];
    }
}

- (IBAction)clickWriteBarButton:(UIBarButtonItem *)sender
{
    [self resignKeyboard];
    if ([self.entriesInTable count]>0) {
         [self.memoTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.entriesInTable count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
   
    [self addOneMemoEntry];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.entriesInTable count];
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
        if (index < [self.entriesInTable count]) {
            MDMemoEntry *memoEntry = self.entriesInTable[index];
            NSString *memoString = memoEntry.entryName;
            memoCell.MemoText = memoString;
            memoCell.haveFinished = memoEntry.finished;
            if ([memoString length] == 0) {
                [self startEditMemoEntry:memoCell inTableIndexPath:indexPath];
            }
        }
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    MDMemoEntry *entry = self.entriesInTable[indexPath.row];
    entry.finished = !entry.finished;
    if ([cell isKindOfClass:[MDMemoTableViewCell class]]) {
        MDMemoTableViewCell *memoCell = (MDMemoTableViewCell *)cell;
        memoCell.haveFinished = entry.finished;
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
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
         [tableView setEditing:NO animated:YES];
        UIAlertController *alertConroller = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除此条记录" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //todo:删除该条记录
            if ([cell isKindOfClass:[MDMemoTableViewCell class]]) {
                MDMemoTableViewCell *memoCell = (MDMemoTableViewCell*)cell;
                [self deleteMemoEntry:memoCell inTableIndexPath:indexPath];
            }
           
        }];
        [alertConroller addAction:cancelAction];
        [alertConroller addAction:confirmAction];
        [self presentViewController:alertConroller animated:YES completion:nil];
    }];
    //编辑
    __weak __typeof(self) weakSelf = self;
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
         __strong __typeof(self) strongSelf = weakSelf;
        if ([cell isKindOfClass:[MDMemoTableViewCell class]]) {
            MDMemoTableViewCell *memoCell = (MDMemoTableViewCell*)cell;
            [strongSelf startEditMemoEntry:memoCell inTableIndexPath:indexPath];
        }
        
    }];
    return @[deleteAction,editAction];
}

#pragma mark - private function

/**
 navigationcontroller 将self出栈
 */
- (void)popSelf
{
    [self.navigationController popViewControllerAnimated:YES];
}


/**
 新增一条备忘录条目
 */
- (void)addOneMemoEntry
{
    MDMemoEntry *entry = [[MDMemoEntry alloc] init];
    entry.entryName = @"";
    entry.finished = NO;
    NSMutableArray *mutaArray = [NSMutableArray arrayWithArray:self.entriesInTable];
    [mutaArray addObject:entry];
    self.entriesInTable = mutaArray;
    [self.memoTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.entriesInTable count]-1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}


/**
 开始编辑一条备忘录条目
 */
- (void)startEditMemoEntry:(MDMemoTableViewCell*)memoCell inTableIndexPath:(NSIndexPath*)indexPath
{
    [self.memoTableView setEditing:NO animated:YES];
    [self.memoTableView setUserInteractionEnabled:NO];
    self.isEditMemo = YES;
    self.tap.enabled = YES;
    memoCell.haveFinished = NO;
    MDMemoEntry *entry = self.entriesInTable[indexPath.row];
    //编辑结局的回调
    [memoCell editMemoCompletion:^(NSString *memoText) {
        self.tap.enabled = NO;
        self.isEditMemo = NO;
        [self.memoTableView setUserInteractionEnabled:YES];
        if ([memoText length] > 0) {
            entry.entryName = memoText;
            entry.finished = NO;
            NSMutableArray *mutaArray = [NSMutableArray arrayWithArray:self.entriesInTable];
            [mutaArray replaceObjectAtIndex:indexPath.row withObject:entry];
            self.entriesInTable = mutaArray;
        }
        //修改后为空白文字
        else {
            [self deleteMemoEntry:memoCell inTableIndexPath:indexPath];
        }
    }];
}


/**
 删除一条备忘录条目

 @param momeCell 删除条目所在的cell
 @param indexPath 删除条目在taleView中的indexPath
 */
- (void)deleteMemoEntry:(MDMemoTableViewCell*)momeCell inTableIndexPath:(NSIndexPath*)indexPath
{
    NSMutableArray *mutaArray = [NSMutableArray arrayWithArray:self.entriesInTable];
    [mutaArray removeObjectAtIndex:indexPath.row];
    self.entriesInTable = mutaArray;
    [self.memoTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
