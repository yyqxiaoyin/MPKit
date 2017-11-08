//
//  UILabel+YYQExtension.h
//  Pods-YYQCategory_Example
//
//  Created by Mopon on 2017/10/18.
//

#import <UIKit/UIKit.h>

@interface UILabel (YYQExtension)

/**
 根据给出限制的size获取属性文字高度

 @param size 限制尺寸
 @return 属性文字最适合高度
 */
-  (CGFloat)attributeTextHeightWithSize:(CGSize)size;

/**
 设置居下显示
 */
- (void)alignBottom;

@end
