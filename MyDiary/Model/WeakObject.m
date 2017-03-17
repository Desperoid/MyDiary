//
//  WeakObject.m
//  MailClientApp
//
//  Created by Geng on 16/10/10.
//
//

#import "WeakObject.h"
#import <objc/runtime.h>

@implementation WeakObject

#pragma mark --- life circle
- (instancetype)initWithInsideObject:(id)insideObject
{
   if (self = [self init]) {
      _insideObject = insideObject;
   }
   return self;
}

#pragma mark --- method forwarding
- (id)forwardingTargetForSelector:(SEL)aSelector
{
   if ([self.insideObject respondsToSelector:aSelector]) {
      return self.insideObject;
   }
   return [super forwardingTargetForSelector:aSelector];
}


#pragma mark --- override
- (BOOL)isEqual:(id)object
{
   if ([object isMemberOfClass:[self class]]) {
      WeakObject *weakObj = (WeakObject*)object;
      return [self.insideObject isEqual:weakObj.insideObject];
   }
   return [super isEqual:object];
}

- (NSUInteger)hash
{
   return [self.insideObject hash];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
   return [self.insideObject respondsToSelector:aSelector];
}

- (NSString *)description
{
   return [NSString stringWithFormat:@"%@<insideObject:%@>",[super description],_insideObject];
}

- (NSString *)debugDescription
{
   return [NSString stringWithFormat:@"%@<insideObject:%@>",[super debugDescription],_insideObject];
}

@end
