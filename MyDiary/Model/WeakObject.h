//
//  WeakObject.h
//  MailClientApp
//
//  Created by Geng on 16/10/10.
//  在创建类似于listener这种多个代理形式回调时，通常需要用NSArray,NSMutableArray,
//  NSDictionary,NSMutableDictionary,NSSet,NSMutableSet来管理多个listener.因为
//  NSArray,NSDictionary,NSSet会对容器内的成员retain, 和导致listener引用计数增加而不能正确
//  被释放。
//  创建WeakObject实例，将listener赋值给该实例的insideObject属性，再将该实例添加到NSArray,NSDictionary,NSSet中
//  不影响listener的释放。
//  重写isEqual:方法，直接比较两个WeakObject实例优先比较其insideObject;
//  重写respondsToSelector:方法，优先调用insideObejct的respondsToSelector: 方法，若insideObject不响应该
//  方法，调用[super respondsToSelector:].
//  重写forwardingTargetForSelector:方法，能直接向WeakObject实例调用insideObject中的实例方法.
// （注意：若WeakObject实例中也实现了该方法，则会调用WeakObject的方法，不会调用insideObject中的方法）

#import <Foundation/Foundation.h>

@interface WeakObject : NSObject
@property (nonatomic, unsafe_unretained) id insideObject;

- (instancetype)initWithInsideObject:(id)insideObject;

@end
