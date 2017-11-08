//
//  UIButton+YYQExtension.h
//
//  Created by 尹永奇 on 16/6/15.
//  Copyright © 2016年 尹永奇. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TouchBlock)(UIButton *btn);

@interface UIButton (YYQExtension)

 

/**
 *  给按钮添加点击事件（block方式）
 *
 *  @param touchHandle 点击按钮回调
 */
-(void)addTouchHandle:(TouchBlock)touchHandle;



@end
