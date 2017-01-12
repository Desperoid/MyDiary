//
//  MDDiaryCalendarView.m
//  MyDiary
//
//  Created by 周庚 on 2017/1/12.
//  Copyright © 2017年 Geng. All rights reserved.
//

#import "MDDiaryCalendarView.h"
#import "MDCalendarDayView.h"
#import "MDDateHelper.h"

@interface MDDiaryCalendarView ()
@property (nonatomic, copy)   NSDate *currentDate;
@property (nonatomic, strong) MDCalendarDayView *previousDayView;
@property (nonatomic, strong) MDCalendarDayView *currentDayView;
@property (nonatomic, strong) MDCalendarDayView *nextDayView;
@end

@implementation MDDiaryCalendarView
- (instancetype)init
{
    if (self = [super init]) {
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
    self.previousDayView = [[NSBundle mainBundle] loadNibNamed:@"MDCalendarDayView" owner:self options:nil].firstObject;
    self.currentDayView = [[NSBundle mainBundle] loadNibNamed:@"MDCalendarDayView" owner:self options:nil].firstObject;
    self.nextDayView = [[NSBundle mainBundle] loadNibNamed:@"MDCalendarDayView" owner:self options:nil].firstObject;
    self.previousDayView.frame = self.bounds;
    self.currentDayView.frame = self.bounds;
    self.nextDayView.frame = self.bounds;
    self.currentDate = [NSDate date];
//    self.currentDayView.hidden = NO;
//    self.nextDayView.hidden = YES;
//    self.previousDayView.hidden = YES;
    [self addSubview:self.previousDayView];
    [self addSubview:self.nextDayView];
    [self addSubview:self.currentDayView];
    UISwipeGestureRecognizer *leftPan = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(panInView:)];
    leftPan.direction = UISwipeGestureRecognizerDirectionLeft;
    UISwipeGestureRecognizer *rightPan = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(panInView:)];
    rightPan.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:leftPan];
    [self addGestureRecognizer:rightPan];
    [self showDayView:self.currentDayView withShowDate:self.currentDate];
    [self showDayView:self.previousDayView withShowDate:[MDDateHelper previousDayFromDay:self.currentDate]];
    [self showDayView:self.nextDayView withShowDate:[MDDateHelper nextDayFromDay:self.currentDate]];
}

#pragma mark - Target action
- (void)panInView:(UISwipeGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
            [UIView transitionFromView:self.currentDayView toView:self.nextDayView duration:0.3f options:UIViewAnimationOptionTransitionCurlUp completion:^(BOOL finished) {
                MDCalendarDayView *currentTemp = self.currentDayView;
                MDCalendarDayView *preTemp = self.previousDayView;
                self.currentDayView = self.nextDayView;
                self.nextDayView = preTemp;
                self.previousDayView = currentTemp;
                
                self.currentDate = [MDDateHelper nextDayFromDay:self.currentDate];
                [self showDayView:self.nextDayView withShowDate:[MDDateHelper nextDayFromDay:self.currentDate]];
            }];
        }
        else if(gesture.direction == UISwipeGestureRecognizerDirectionRight) {
            [UIView transitionFromView:self.currentDayView toView:self.previousDayView duration:0.3f options:UIViewAnimationOptionTransitionCurlDown completion:^(BOOL finished) {
                MDCalendarDayView *currentTemp = self.currentDayView;
                MDCalendarDayView *nextTemp = self.nextDayView;
                self.currentDayView = self.previousDayView;
                self.nextDayView = currentTemp;
                self.previousDayView = nextTemp;
                
                self.currentDate = [MDDateHelper previousDayFromDay:self.currentDate];
                [self showDayView:self.previousDayView withShowDate:[MDDateHelper previousDayFromDay:self.currentDate]];
            }];
        }
    }
}

#pragma mark - private function

- (void)showDayView:(MDCalendarDayView *)dayView withShowDate:(NSDate *)date
{
    NSDateComponents *components = [MDDateHelper dateComponentsWithDate:date];
    dayView.dayLabel.text = [NSString stringWithFormat:@"%zd",components.day];
    dayView.yearLabel.text = [NSString stringWithFormat:@"%zd", components.year];
    NSArray *monthSymbols = [MDDateHelper getAllWeekDaySymbols];
    dayView.MonthLabel.text = [monthSymbols objectAtIndex:components.month-1];
}

@end
