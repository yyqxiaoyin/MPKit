//
//  NSObject+YYQExtension.h
//  MoponChinaFilm
//
//  Created by Mopon on 2017/4/10.
//  Copyright © 2017年 Mopon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (YYQExtension)

/**
 交换两个实例方法的实现
 
 @param originalSel 方法1
 @param newSel 方法2
 @return YES 交换成功 其他交换失败
 */
+ (BOOL)swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel;


/**
 交换两个类方法的实现
 
 @param originalSel 类方法1
 @param newSel 类方法2
 @return YES 交换成功 其他交换失败
 */
+ (BOOL)swizzleClassMethod:(SEL)originalSel with:(SEL)newSel;


/**
 调用多参数方法

 @param aSelector 方法选择器
 @param objects 参数列表
 @return 返回值
 */
- (id)performSelector:(SEL)aSelector withObjects:(NSArray *)objects;

- (void)setObjectForMapingKey:(id)obj;

/**
   获取当前class的字符串

 @return 返回当前class的字符串
 */
+ (NSString *)yq_stringForClass;
+ (NSString *)mp_identifier;

@end
