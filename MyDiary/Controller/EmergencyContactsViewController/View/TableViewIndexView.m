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
@property (nonatomic, strong) UISelectionFeedbackGenerator *selectionFeedback; //选择震动
@property (nonatomic, assign) NSInteger selectedIndex;//选中的index;
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
    self.selectionFeedback = [[UISelectionFeedbackGenerator alloc] init];
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    UILabel *touchedLabel = (UILabel*)[self hitTest:[touch locationInView:self] withEvent:event];
    NSUInteger index = [self.indexLabels indexOfObject:touchedLabel];
    if (index != NSNotFound && self.touchCallBack) {
        if (index!=self.selectedIndex) {
            self.selectedIndex = index;
            [self.selectionFeedback selectionChanged];
            self.touchCallBack(index);
        }
    }
    else {
        [super touchesBegan:touches withEvent:event];
    }
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    UILabel *touchedLabel = (UILabel*)[self hitTest:[touch locationInView:self] withEvent:event];
    NSUInteger index = [self.indexLabels indexOfObject:touchedLabel];
    if (index != NSNotFound && self.touchCallBack) {
        if (index!=self.selectedIndex) {
            self.selectedIndex = index;
            [self.selectionFeedback selectionChanged];
            self.touchCallBack(index);
        };
        
    }
    else {
        [super touchesMoved:touches withEvent:event];
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
