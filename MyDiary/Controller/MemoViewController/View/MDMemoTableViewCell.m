//
//  MDMemoTableViewCell.m
//  MyDiary
//
//  Created by Geng on 2017/1/19.
//  Copyright © 2017年 Geng. All rights reserved.
//

#import "MDMemoTableViewCell.h"

@interface MDMemoTableViewCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *contentTextfield;
@property (weak, nonatomic) IBOutlet UIImageView *dotImageView;
@property (nonatomic, strong) NSMutableDictionary *normalTextAttributeDic;  //正常状态下文字的attribute
@property (nonatomic, strong) NSMutableDictionary *selectedTextAttributedDic; //选中状态下文字的attribute
@property (nonatomic, copy) MemoTableViewCellCallBack callback;
@end

@implementation MDMemoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIColor *textColor = [UIColor colorWithRed:230/255.0 green:141/255.0 blue:133/255.0 alpha:1];
    UIColor *lightTextColor = [textColor colorWithAlphaComponent:0.3];
    self.normalTextAttributeDic = [NSMutableDictionary dictionaryWithDictionary:
                                   @{NSFontAttributeName: [UIFont systemFontOfSize:16],
                                     NSForegroundColorAttributeName: textColor}];
    self.selectedTextAttributedDic = [NSMutableDictionary dictionaryWithDictionary:
                                      @{NSFontAttributeName: [UIFont systemFontOfSize:16],
                                        NSForegroundColorAttributeName: lightTextColor,
                                        NSStrikethroughStyleAttributeName:@(2)}];
    self.contentTextfield.borderStyle = UITextBorderStyleNone;
    UIImage *img = [self.dotImageView image];
    self.dotImageView.image = [img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.dotImageView.tintColor = [UIColor grayColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.contentTextfield.userInteractionEnabled = NO;
    self.callback = nil;
    self.haveFinished = NO;
}

#pragma mark - UITextfieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    self.MemoText = textField.text;
    [self changeMemoLabelText];
    if (self.callback) {
        self.callback(self.MemoText);
    }
    self.contentTextfield.userInteractionEnabled = NO;
    self.callback = nil;
}

#pragma mark - public function
- (void)editMemoCompletion:(MemoTableViewCellCallBack)callback
{
    self.callback = callback;
    self.contentTextfield.userInteractionEnabled = YES;
    [self.contentTextfield becomeFirstResponder];
}

#pragma mark - private function
- (void)changeMemoLabelText
{
    if (!self.MemoText || [self.MemoText length] == 0) {
        return;
    }
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:self.MemoText];
    NSDictionary *attributeDic = [self getMemoAttributeDic];
    [attString setAttributes:attributeDic range:NSMakeRange(0, [attString length])];
    [self.contentTextfield setAttributedText:attString];
}

- (NSDictionary*)getMemoAttributeDic
{
    if (self.haveFinished) {
        return self.selectedTextAttributedDic;
    }
    else {
        return self.normalTextAttributeDic;
    }
    
}
#pragma mark - setter and getter
- (void)setMemoText:(NSString *)MemoText
{
    if ([_MemoText isEqualToString:MemoText]) {
        return;
    }
    _MemoText = [MemoText copy];
    [self changeMemoLabelText];
}

- (void)setMemoTextColor:(UIColor *)memoTextColor
{
    _memoTextColor = [memoTextColor copy];
    self.contentTextfield.textColor = _memoTextColor;
    [self.normalTextAttributeDic setObject:_memoTextColor forKey:NSForegroundColorAttributeName];
    UIColor *selectedTextColor = [_memoTextColor colorWithAlphaComponent:0.5];
    [self.selectedTextAttributedDic setObject:selectedTextColor forKey:NSForegroundColorAttributeName];
    [self changeMemoLabelText];
}

- (void)setHaveFinished:(BOOL)haveFinished
{
    _haveFinished = haveFinished;
    [self changeMemoLabelText];
}

@end
