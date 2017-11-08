//
//  NSObject+PropertyString.m
//  DictionaryToModel
//
//  Created by Mopon on 16/8/5.
//  Copyright © 2016年 Mopon. All rights reserved.
//

#import "NSObject+PropertyString.h"
#import <objc/runtime.h>

@implementation NSObject (PropertyString)

+(void)createPropertyCodeWithDictionary:(NSDictionary *)dict{

    NSMutableString *codeString = [NSMutableString string];
    
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
       
        
        NSString *code ;
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFString")]) {
            
            code = [NSString stringWithFormat:@"@property (nonatomic ,strong) NSString *%@;",key];
            
        }else if([obj isKindOfClass:NSClassFromString(@"__NSCFNumber")]){
        
            code = [NSString stringWithFormat:@"@property (nonatomic, assign) int %@;",key];
            
        }else if([obj isKindOfClass:NSClassFromString(@"__NSCFArray")]){
            
            code = [NSString stringWithFormat:@"@property (nonatomic, strong) NSArray *%@;",key];
            
        }else if([obj isKindOfClass:NSClassFromString(@"__NSCFDictionary")]){
            
            code = [NSString stringWithFormat:@"@property (nonatomic, strong) NSDictionary *%@;",key];
            
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFBoolean")]){
            code = [NSString stringWithFormat:@"@property (nonatomic, assign) BOOL %@;",key]
            ;
        }
        
        [codeString appendFormat:@"\n%@\n",code];
        
    }];
    NSLog((@"%s [%d 行] %@"), __PRETTY_FUNCTION__, __LINE__, codeString);
    
}

@end
