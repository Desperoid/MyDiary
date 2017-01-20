//
//  MDDiaryViewController.m
//  MyDiary
//
//  Created by Geng on 2017/1/11.
//  Copyright © 2017年 Geng. All rights reserved.
//

#import "MDDiaryViewController.h"
#import "MDBaseToolBar.h"
#import "MDDiaryCalendarView.h"
#import "MDEntriesListView.h"

static NSString * const kEntriesName = @"Entries";
static NSString * const kCalendarName = @"Calendar";
static NSString * const kDiaryName = @"Diary";

@interface MDDiaryViewController ()
@property (nonatomic, strong) UISegmentedControl *titleSegment;   //navigationbar上的segmentedControl
@property (weak, nonatomic) IBOutlet MDBaseToolBar *footerToolBar;  //下方toolbar
@property (weak, nonatomic) IBOutlet UIView *diaryView;
@property (weak, nonatomic) IBOutlet MDDiaryCalendarView *calendaryView;
@property (weak, nonatomic) IBOutlet MDEntriesListView *entiresListView;

@end

@implementation MDDiaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initView];
}

- (void)initData
{
    
}

- (void)initView
{
    //navigationabr
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    //titleView
    self.titleSegment = [[UISegmentedControl alloc] initWithItems:@[kEntriesName, kCalendarName, kDiaryName]];
    [self.titleSegment addTarget:self action:@selector(titleSegmentSelectedIndexChanged:) forControlEvents:UIControlEventValueChanged];
    [self.titleSegment setSelectedSegmentIndex:0];
    [self.titleSegment setTintColor:[UIColor colorWithRed:230/255.0 green:141/255.0 blue:133/255.0 alpha:1]];
    self.navigationItem.titleView = self.titleSegment;
    //footer tool bar
    [self.footerToolBar.menuButton addTarget:self action:@selector(clickMenuButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.footerToolBar.writeButton addTarget:self action:@selector(clickCameraButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.footerToolBar.cameraButton addTarget:self action:@selector(clickCameraButton:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)titleSegmentSelectedIndexChanged:(UISegmentedControl *)sender
{
    NSLog(@"selected index:%zd",sender.selectedSegmentIndex);
    switch (sender.selectedSegmentIndex) {
        case 0:{
            self.entiresListView.hidden = NO;
            self.calendaryView.hidden = YES;
            self.diaryView.hidden = YES;
        }
            break;
        case 1: {
            self.entiresListView.hidden = YES;
            self.calendaryView.hidden = NO;
            self.diaryView.hidden = YES;
        }
            break;
        case 2: {
            self.entiresListView.hidden = YES;
            self.calendaryView.hidden = YES;
            self.diaryView.hidden = NO;
        }
            break;
        default:
            break;
    }
}

@end
