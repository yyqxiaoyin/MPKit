//
//  NSArray+YYQExtension.h
//
//  Created by 尹永奇 on 16/6/15.
//  Copyright © 2016年 尹永奇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (YYQExtension)

/**
 *  读取内容为数组的plist数据
 *
 *  @param plist 内容为数组的plist NSData数据
 */
+ (NSArray *)arrayWithPlistData:(NSData *)plist;

/**
 *  随机在数组中取出一个数据返回
 */
- (id)randomObject;

/**
 *  根据下标在数组中取出一个返回,如果数组越界。返回nil
    相比于系统的objectAtIndex:方法。这个方法不会抛出异常
 *  @param index 下标
 */
- (id)objectOrNilAtIndex:(NSUInteger)index;

@end

@interface NSMutableArray (YYQExtension)

/**
 *  读取内容为数组的plist数据
 *
 *  @param plist 内容为数组的plist NSData数据
 */
+ (NSMutableArray *)arrayWithPlistData:(NSData *)plist;

/**
 *  删除第一条数据
 */
- (void)removeFirstObject;



@end
