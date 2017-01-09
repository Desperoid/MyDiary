//
//  TableViewIndexView.h
//  MailClientApp
//
//  Created by Geng on 2016/12/28.
//
//  用于自定义创建TableView的indexView索引

#import <UIKit/UIKit.h>

typedef void(^IndexViewTouchCallBack)(NSUInteger index);

@interface TableViewIndexView : UIView

@property (nonatomic, copy) NSArray<NSString *> *indexArray;
@property (nonatomic, copy) IndexViewTouchCallBack touchCallBack;
@property (nonatomic, strong) UIFont            *indexTextFont;
@property (nonatomic, strong) UIColor           *textColor;
@property (nonatomic, assign) NSUInteger        indexMargin;
@property (nonatomic, assign) NSTextAlignment    textAlignment;

@end
