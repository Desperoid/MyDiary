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
#import "MDDateHelper.h"
static NSString * const kEntriesListTableCellNib = @"MDEntriesListTableViewCell";
static NSString * const kEntriesListTableCellIdentifier = @"entriesListTableViewCellIdentifier";
static NSString * const kEntriesListTableGapCellIdentifier = @"entriesListTableGapCellIdentifier";
static CGFloat kTableViewMargin = 10.0f;
static CGFloat kTableViewHeaderHeight = 30.0f;
static CGFloat kTableViewCellHeight = 65.0f;
static CGFloat kTableViewCellGap = 20.0f;

@interface MDEntriesListView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *entriesTableView; //备忘录tableView
@property (nonatomic, copy) NSDictionary<NSDate*, NSMutableArray*> *diaryEntriesDic;  //日记entries,按月份分类
@end


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
    [self.entriesTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kEntriesListTableGapCellIdentifier];
    self.entriesTableView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.entriesTableView];
    
    NSArray *diariesEntryArray = [NSMutableArray arrayWithArray:[[MDDiaryManager shareInstance] getAllDiaries]];
    self.diaryEntriesDic = [self classDiaries:diariesEntryArray];
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
    return [[self.diaryEntriesDic allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section < [[self.diaryEntriesDic allValues] count]) {
        NSArray *diaryGroupArray = [self.diaryEntriesDic allValues][section];
        return [diaryGroupArray count]*2-1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row %2 == 0) {
        MDEntriesListTableViewCell *cell =  [self.entriesTableView dequeueReusableCellWithIdentifier:kEntriesListTableCellIdentifier];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:kEntriesListTableCellNib owner:self options:nil].firstObject;
        }
        return cell;
    }
    else {
        UITableViewCell *cell = [self.entriesTableView dequeueReusableCellWithIdentifier:kEntriesListTableGapCellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row %2 != 0) {
        return;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[MDEntriesListTableViewCell class]]) {
        MDEntriesListTableViewCell *entiresCell = (MDEntriesListTableViewCell*)cell;
        if (indexPath.section < [[self.diaryEntriesDic allValues] count]) {
            NSArray *diaryGroupArray = [self.diaryEntriesDic allValues][indexPath.section];
            NSInteger diaryIndex = indexPath.row/2;
            if (diaryIndex < [diaryGroupArray count]) {
                MDDiary *diary = diaryGroupArray[diaryIndex];
                entiresCell.titleLabel.text = diary.diaryTitle;
                entiresCell.contentLabel.text = diary.diaryContent;
                NSDateComponents *components = [MDDateHelper dateComponentsWithDate:diary.diaryDate];
                NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
                dateformatter.timeZone = components.timeZone;
                dateformatter.locale = components.calendar.locale;
                NSArray *weekDaySymbols = [dateformatter shortWeekdaySymbols];
                entiresCell.dayLabel.text = [NSString stringWithFormat:@"%zd",components.day];
                entiresCell.timeLabel.text = [NSString stringWithFormat:@"%zd:%zd",components.hour,components.minute];
                entiresCell.weekdayLabel.text = weekDaySymbols[components.weekday];
            }
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, kTableViewHeaderHeight)];
    CGFloat headerLabelMargin = 5.0f;
    header.backgroundColor = [UIColor clearColor];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, headerLabelMargin, header.frame.size.width, header.frame.size.height - headerLabelMargin*2)];
    headerLabel.font = [UIFont systemFontOfSize:20.f];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.backgroundColor = [UIColor clearColor];
    if (section < [[self.diaryEntriesDic allKeys] count]) {
        NSDate *MonthDate = [[self.diaryEntriesDic allKeys] objectAtIndex:section];
        NSDateComponents *components = [MDDateHelper dateComponentsWithDate:MonthDate];
        NSString *headerText;
        if (components.month == 1) {
            headerText = [NSString stringWithFormat:@"%zd.%zd",components.year,components.month];
        }
        else {
            headerText = [NSString stringWithFormat:@"%zd",components.month];
        }
        headerLabel.text = headerText;
    }
    [header addSubview:headerLabel];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0) {
        return kTableViewCellHeight;
    }
    return kTableViewCellGap;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kTableViewHeaderHeight;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认删除此条记录" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [tableView setEditing:NO animated:YES];
        }];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [tableView setEditing:NO animated:YES];
            //DOTO:删除记录
        }];
        [alert addAction:cancel];
        [alert addAction:confirm];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }];
    return @[deleteAction];
}

#pragma mark - Private Function

/**
 将日记entries按照月份分类

 @return 按月份分成数组
 */
- (NSDictionary *)classDiaries:(NSArray<MDDiary*> *)allDiariesArray
{
    //耗时操作
    NSMutableDictionary<NSDate*,NSMutableArray*> *resultDic = [NSMutableDictionary dictionary];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    calendar.timeZone = [NSTimeZone localTimeZone];
    calendar.locale = [NSLocale currentLocale];
    for (MDDiary *diary in allDiariesArray) {
        NSDate *date = diary.diaryDate;
        NSDateComponents *components = [calendar components:NSCalendarUnitMonth|NSCalendarUnitYear
                                                   fromDate:date];
        NSDate *mothDate = [calendar dateFromComponents:components];
        
        NSMutableArray<MDDiary*> *diaryGroupArray = [resultDic objectForKey:mothDate];
        if (!diaryGroupArray) {
            diaryGroupArray = [NSMutableArray array];
            [resultDic setObject:diaryGroupArray forKey:mothDate];
        }
        [diaryGroupArray addObject:diary];
        
    }
    
    return resultDic;
}

@end
