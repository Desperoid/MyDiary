//
//  MDWriteDiaryView.h
//  MyDiary
//
//  Created by Geng on 2017/4/5.
//  Copyright © 2017年 Geng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYText.h>

@interface MDWriteDiaryView : UIView
@property (nonatomic, weak) IBOutlet UIView *writeDiayHeaderView;
@property (nonatomic, weak) IBOutlet YYTextView *textView;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UIButton *saveButton;
@property (nonatomic, weak) IBOutlet UILabel *locationLabel;
@property (nonatomic, weak) IBOutlet UILabel *longitudeLabel;
@property (nonatomic, weak) IBOutlet UILabel *latitudeLabel;
@property (nonatomic, weak) IBOutlet UIButton *moodButton;
@property (nonatomic, weak) IBOutlet UIButton *weatherButton;
@end
