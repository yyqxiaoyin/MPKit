//
//  UIBarButtonItem+YYQExtension.h
//  Pods-YYQCategory_Example
//
//  Created by Mopon on 2017/10/18.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (YYQExtension)

/**
 返回一个图片样式的导航栏按钮

 @param nmlImg 默认状态的图片
 @param hltImg 选中状态的图片
 @param target 按钮响应对象
 @param action 按钮点击触发方法
 @return UIBarButtonItem对象
 */
+ (instancetype)mp_barBtnItemWithNmlImg:(NSString *)nmlImg
                                 hltImg:(NSString *)hltImg
                                 target:(id)target
                                 action:(SEL)action;

/**
 *  返回指定样式导航条Item
 *
 *  @param nmlImg 正常状态的图片
 *  @param hltImg 高度状态的图片
 *  @param target 按钮taget
 *  @param action 按钮点击触发方法
 *
 *  @return UIBarButtonItem
 */
+ (instancetype)mp_barBtnItemWithNmlImg:(NSString *)nmlImg
                                 hltImg:(NSString *)hltImg
                                 selImg:(NSString *)selImg
                                 target:(id)target
                                 action:(SEL)action;

/**
 返回一个文字样式的导航栏按钮

 @param title 标题
 @param titleColor 标题颜色
 @param titleFont 标题字体
 @param target 按钮响应对象
 @param action 按钮点击触发方法
 @return UIBarButtonItem对象
 */
+ (instancetype)mp_barBtnItemWithTitle:(NSString *)title
                            titleColor:(UIColor *)titleColor
                             titleFont:(UIFont *)titleFont
                                target:(id)target
                                action:(SEL)action;

@end
