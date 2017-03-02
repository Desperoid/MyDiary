//
//  TableViewIndexView.m
//  MailClientApp
//
//  Created by Geng on 2016/12/28.
//
//

#import "TableViewIndexView.h"

@interface TableViewIndexView ()
@property (nonatomic, strong) NSArray<UILabel*> *indexLabels;   //索引label
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture; //触摸手势
@property (nonatomic, strong) UISelectionFeedbackGenerator *selectionFeedback; //选择震动
@end

@implementation TableViewIndexView
#pragma mark - Life Circle
- (instancetype)init
{
    if (self = [super init]) {
        [self customInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self customInit];
    }
    return self;
}

- (void)customInit
{
    self.indexMargin = 0;
    self.textColor  = [UIColor blackColor];
    self.indexTextFont = [UIFont systemFontOfSize:12];
    self.textAlignment = NSTextAlignmentCenter;
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnIndexView:)];
    self.selectionFeedback = [[UISelectionFeedbackGenerator alloc] init];
    [self addGestureRecognizer:self.tapGesture];
}

#pragma mark - Overrride

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    [self.selectionFeedback prepare];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSInteger labelCount = [self.indexArray count];
    CGFloat labelHeight = (CGRectGetHeight(self.frame)+self.indexMargin)/labelCount - self.indexMargin;
    for (int i = 0 ; i < labelCount; i++) {
        UILabel *label = self.indexLabels[i];
        CGRect frame = label.frame;
        frame.origin.y = i*(labelHeight+self.indexMargin);
        frame.size.height = labelHeight;
        label.frame = frame;
    }
}

#pragma mark - Target Action
- (void)tapOnIndexView:(UITapGestureRecognizer *)tapGeture
{
    CGPoint tapLocation = [tapGeture locationInView:tapGeture.view];
    UILabel *tapedLabel = (UILabel*)[self hitTest:tapLocation withEvent:nil];
    NSUInteger index = [self.indexLabels indexOfObject:tapedLabel];
    if (index != NSNotFound && self.touchCallBack) {
        [self.selectionFeedback selectionChanged];
        self.touchCallBack(index);
    }
}

#pragma mark - Setter Getter
- (void)setIndexArray:(NSArray<NSString *> *)indexArray
{
    [self clearIndexLabel];
    _indexArray = indexArray;
    [self createIndexLabel];
}

- (void)setIndexTextFont:(UIFont *)indexTextFont
{
    if ([_indexTextFont isEqual:indexTextFont]) {
        return;
    }
    _indexTextFont = indexTextFont;
    [self refreshLabels];
}

- (void)setTextColor:(UIColor *)textColor
{
    if ([_textColor isEqual:textColor]) {
        return;
    }
    _textColor = textColor;
    [self refreshLabels];
}

- (void)setIndexMargin:(NSUInteger)indexMargin
{
    if (_indexMargin == indexMargin) {
        return;
    }
    _indexMargin = indexMargin;
    [self refreshLabels];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    if (_textAlignment == textAlignment) {
        return;
    }
    _textAlignment = textAlignment;
    [self refreshLabels];
}

#pragma mark - Private Function
- (void)refreshLabels
{
    for (int i = 0; i<[self.indexLabels count];i++) {
        UILabel *label = self.indexLabels[i];
        label.font = self.indexTextFont;
        label.textColor = self.textColor;
        label.textAlignment = self.textAlignment;
        NSInteger offset = (self.indexMargin + CGRectGetHeight(label.frame))*i;
        CGRect frame = label.frame;
        frame.origin.y = offset;
        label.frame = frame;
    }
}

- (void)clearIndexLabel
{
    if (self.indexArray && [self.indexArray count]>0) {
        for (UILabel *label in self.indexArray) {
            [label removeFromSuperview];
        }
    }
}

- (void)createIndexLabel
{
    NSInteger labelCount = [self.indexArray count];
    NSMutableArray *mutArray = [NSMutableArray arrayWithCapacity:labelCount];
    CGFloat labelWidth = CGRectGetWidth(self.frame);
    CGFloat labelHeight = (CGRectGetHeight(self.frame)+self.indexMargin)/labelCount - self.indexMargin;
    for (int i = 0 ; i < labelCount; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, i*(labelHeight+self.indexMargin), labelWidth, labelHeight)];
        label.textColor = self.textColor;
        label.font = self.indexTextFont;
        label.text = self.indexArray[i];
        label.backgroundColor = [UIColor clearColor];
        label.userInteractionEnabled = YES;
        label.textAlignment = self.textAlignment;
        [mutArray addObject:label];
        [self addSubview:label];
    }
    self.indexLabels = mutArray;
}

@end
