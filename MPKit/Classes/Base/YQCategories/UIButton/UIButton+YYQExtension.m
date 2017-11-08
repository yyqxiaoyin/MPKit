//
//  UIButton+YYQExtension.h
//
//  Created by 尹永奇 on 16/6/15.
//  Copyright © 2016年 尹永奇. All rights reserved.
//



#import "UIButton+YYQExtension.h"
#import <objc/runtime.h>


@interface UIButton ()


@end

@implementation UIButton (YYQExtension)


-(void)addTouchHandle:(TouchBlock)touchHandle{
    
    objc_setAssociatedObject(self, _cmd, touchHandle, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    [self addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}


-(void)btnClick:(UIButton *)btn{
    
    TouchBlock block = objc_getAssociatedObject(self, @selector(addTouchHandle:));
    
    if (block) {
        block(btn);
    }
}


@end
