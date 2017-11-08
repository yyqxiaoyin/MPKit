//
//  NSData+YYQExtension.h
//
//  Created by 尹永奇 on 16/6/15.
//  Copyright © 2016年 尹永奇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (YYQExtension)

/**
 *  根据文件名读取本地文件转换成data （文件名要带后缀）
 *
 *  @param resourceName 本地文件的名字（要带后缀）
 */
+(NSData *)dataWithResourceName:(NSString *)resourceName;

/**
 *  返回小写MD5加密字符串
 */
- (NSString *)md5String;

/**
 *  转换成utf-8编码的字符串
 */
- (NSString *)utf8String;

/**
 *  转换成16进制字符串
 */
- (NSString *)hexString;

/**
 *  解析json数据 返回字典或者数组
 */
- (id)jsonValueDecoded;

@end
