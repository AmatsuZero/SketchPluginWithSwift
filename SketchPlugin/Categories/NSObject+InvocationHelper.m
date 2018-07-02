//
//  NSObject+InvocationHelper.m
//  SketchPlugin
//
//  Created by Jiang,Zhenhua on 2018/7/2.
//  Copyright © 2018年 Daubert. All rights reserved.
//

#import "NSObject+InvocationHelper.h"

@implementation NSObject (InvocationHelper)

- (id)djsp_performSelector:(SEL)aSelector array:(NSArray *)objects
{
    NSMethodSignature *signature = [self methodSignatureForSelector:aSelector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self];
    [invocation setSelector:aSelector];
    
    NSUInteger i = 1;
    for (id object in objects) {
        __unsafe_unretained id unsafeObject = object;
        [invocation setArgument:&unsafeObject atIndex:++i];
    }
    [invocation invoke];
    if ([signature methodReturnLength]) {
        void *result = nil;
        [invocation getReturnValue:&result];
        return (__bridge id)result;
    }
    return nil;
}

+ (id)performSelector:(SEL)aSelector array:(NSArray *)objects
{
    NSMethodSignature* signature = [NSObject instanceMethodSignatureForSelector:aSelector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self];
    [invocation setSelector:aSelector];
    
    NSUInteger i = 1;
    for (id object in objects) {
        __unsafe_unretained id unsafeObject = object;
        [invocation setArgument:&unsafeObject atIndex:++i];
    }
    [invocation invoke];
    if ([signature methodReturnLength]) {
        void *result = nil;
        [invocation getReturnValue:&result];
        return (__bridge id)result;
    }
    return nil;
}

@end
