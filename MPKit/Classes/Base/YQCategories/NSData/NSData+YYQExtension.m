//
//  NSData+YYQExtension.m
//
//  Created by 尹永奇 on 16/6/15.
//  Copyright © 2016年 尹永奇. All rights reserved.
//

#import "NSData+YYQExtension.h"
#include <CommonCrypto/CommonCrypto.h>

@implementation NSData (YYQExtension)

+(NSData *)dataWithResourceName:(NSString *)resourceName{
    NSString *path = [[NSBundle mainBundle] pathForResource:resourceName ofType:@""];
    if (!path) return nil;
    NSData *data = [NSData dataWithContentsOfFile:path];
    return data;
}

- (NSString *)md5String{
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(self.bytes, (CC_LONG)self.length, result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSString *)utf8String{
    if(self.length >0 ){
        
        return [[NSString alloc]initWithData:self encoding:NSUTF8StringEncoding];
    }
    return @"";
}

- (NSString *)hexString{
    NSUInteger length = self.length;
    NSMutableString *result = [NSMutableString stringWithCapacity:length * 2];
    const unsigned char *byte = self.bytes;
    for (int i = 0; i < length; i++, byte++) {
        [result appendFormat:@"%02X", *byte];
    }
    return result;
}

-(id)jsonValueDecoded{
    NSError *error = nil;
    id value = [NSJSONSerialization JSONObjectWithData:self options:kNilOptions error:&error];
    if (error) {
        NSLog(@"json解析失败 erro：%@",error);
    }
    return value;
}

@end
