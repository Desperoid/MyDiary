//
//  MDBaseToolBar.m
//  MyDiary
//
//  Created by Geng on 2017/1/10.
//  Copyright © 2017年 Geng. All rights reserved.
//

#import "MDBaseToolBar.h"
static NSInteger kButtonWidth = 48;
static NSInteger kButtonHeight = 24;

@interface MDBaseToolBar ()

@end

@implementation MDBaseToolBar

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
    self.menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.writeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.menuButton setImage:[UIImage imageNamed:@"ic_menu_white_24dp"] forState:UIControlStateNormal];
    [self.writeButton setImage:[UIImage imageNamed:@"ic_mode_edit_white_24dp"] forState:UIControlStateNormal];
    [self.cameraButton setImage:[UIImage imageNamed:@"ic_photo_camera_white_24dp"] forState:UIControlStateNormal];
    
    
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.menuButton, self.writeButton, self.cameraButton]];
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.alignment = UIStackViewAlignmentFill;
    stackView.distribution = UIStackViewDistributionEqualSpacing;
    stackView.spacing = 5.0f;
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:stackView];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.menuButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kButtonWidth]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.menuButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kButtonHeight]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.menuButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.writeButton attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.menuButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.cameraButton attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.menuButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.writeButton attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.menuButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.cameraButton attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:stackView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1. constant:20]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:stackView attribute:NSLayoutAttributeTrailing multiplier:1. constant:20]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:stackView attribute:NSLayoutAttributeCenterY multiplier:1. constant:0]];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
