//
//  NSArray+YYQExtension.m
//
//  Created by 尹永奇 on 16/6/15.
//  Copyright © 2016年 尹永奇. All rights reserved.
//

#import "NSArray+YYQExtension.h"

@implementation NSArray (YYQExtension)

+ (NSArray *)arrayWithPlistData:(NSData *)plist {
    if (!plist) return nil;
    NSArray *array = [NSPropertyListSerialization propertyListWithData:plist options:NSPropertyListImmutable format:NULL error:NULL];
    if ([array isKindOfClass:[NSArray class]]) return array;
    return nil;
}

- (id)randomObject{
    if (self.count) {
        return self[arc4random_uniform((u_int32_t)self.count)];
    }
    
    return nil;
}

-(id)objectOrNilAtIndex:(NSUInteger)index{
    
    return index<self.count? self[index] :nil;
}

@end

@implementation NSMutableArray (YYQExtension)

+ (NSMutableArray *)arrayWithPlistData:(NSData *)plist {
    if (!plist) return nil;
    NSMutableArray *array = [NSPropertyListSerialization propertyListWithData:plist options:NSPropertyListMutableContainersAndLeaves format:NULL error:NULL];
    if ([array isKindOfClass:[NSMutableArray class]]) return array;
    return nil;
}

- (void)removeFirstObject{

    [self removeObjectAtIndex:0];
}

@end
