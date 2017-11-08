//
//  NSObject+YYQExtension.m
//  MoponChinaFilm
//
//  Created by Mopon on 2017/4/10.
//  Copyright © 2017年 Mopon. All rights reserved.
//

#import "NSObject+YYQExtension.h"
#import <objc/runtime.h>

@implementation NSObject (YYQExtension)

+ (BOOL)swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel{
    
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    if (!originalMethod || !newMethod) return NO;
    
    class_addMethod(self, originalSel, class_getMethodImplementation(self, originalSel), method_getTypeEncoding(originalMethod));
    class_addMethod(self,
                    newSel,
                    class_getMethodImplementation(self, newSel),
                    method_getTypeEncoding(newMethod));
    method_exchangeImplementations(class_getInstanceMethod(self, originalSel),
                                   class_getInstanceMethod(self, newSel));
    return YES;
}

+ (BOOL)swizzleClassMethod:(SEL)originalSel with:(SEL)newSel{
    
    Class class = object_getClass(self);
    Method originalMethod = class_getInstanceMethod(class, originalSel);
    Method newMethod = class_getInstanceMethod(class, newSel);
    if (!originalMethod || !newMethod) return NO;
    method_exchangeImplementations(originalMethod, newMethod);
    return YES;
    
}

- (id)performSelector:(SEL)aSelector withObjects:(NSArray *)objects{

    //将类与类的某个方法 封装成方法签名对象
    NSMethodSignature *signature = [self methodSignatureForSelector:aSelector];
    //方法不存在 抛出异常
    if (signature == nil) {
        NSString *info = [NSString stringWithFormat:@"-[%@ %@]:unrecognized selector sent to instance",[self class],NSStringFromSelector(aSelector)];
        @throw [[NSException alloc] initWithName:@"方法没有" reason:info userInfo:nil];
        return nil;
    }
    //创建消息调用对象
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    //设置消息的调用对象
    invocation.target = self;
    //设置消息调用对象的选择器
    invocation.selector = aSelector;
    NSInteger arguments = signature.numberOfArguments -2;
    NSInteger objectCount = objects.count;
    NSInteger count = MIN(arguments, objectCount);
    //设置消息调用的参数  固定的target是参数1 selector是参数2 所以下标要从2开始
    for (int i = 0; i<count; i++) {
        id param = objects[i];
        [invocation setArgument:&param atIndex:i+2];
    }
    //retain所有参数 防止参数被释放
    [invocation retainArguments];
    //调用消息
    [invocation invoke];
    
    //获取是否有返回值
    id res = nil;
    //判断是否有返回值
    if ([signature methodReturnLength] != 0) {
    
        [invocation getReturnValue:&res];
    }
    
    return res;
}

- (void)setObjectForMapingKey:(id)obj{

    unsigned int count = 0;
    Ivar *ivarList = class_copyIvarList([obj class], &count);
    for (int i = 0; i<count; i++) {
        Ivar ivar = ivarList[i];
        NSString *propertyName = [[NSString stringWithUTF8String:ivar_getName(ivar)] substringFromIndex:1];
        if ([propertyName containsString:@"\""]) {
            [propertyName stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        }
        id value = [obj valueForKey:propertyName];
        if (!value) {
            value = @"";
        }
        [self setValue:value forKey:propertyName];
    }
    free(ivarList);
}

+ (NSString *)yq_stringForClass{
    
    return NSStringFromClass(self);
}

+ (NSString *)mp_identifier{
    return NSStringFromClass(self);
}

@end
