//
//  NSObject+InvocationHelper.h
//  SketchPlugin
//
//  Created by Jiang,Zhenhua on 2018/7/2.
//  Copyright © 2018年 Daubert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (InvocationHelper)

- (_Nullable id)djsp_performSelector:(SEL)aSelector array:(NSArray * _Nonnull)objects;

+ (_Nullable id)performSelector:(SEL)aSelector array:(NSArray * _Nonnull)objects;

@end
