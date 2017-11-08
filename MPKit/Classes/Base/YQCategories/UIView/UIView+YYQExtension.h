//
//  UIView+YYQExtension.h
//
//  Created by 尹永奇 on 16/6/15.
//  Copyright © 2016年 尹永奇. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    UIViewBorderDirectionTop,
    UIViewBorderDirectionLeft,
    UIViewBorderDirectionBottom,
    UIViewBorderDirectionRight,
} UIViewBorderDirection;

@interface UIView (YYQExtension)

/**
 *  删除所有子view
 *  不能用在view的 drawRect方法
 */
-(void)removeAllSubviews;

/**
 *  添加边框
 *
 *  @param borderColor 边框颜色
 *  @param borderWidth 边框宽度
 */
-(void)setBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

/**
 *  给视图的一边添加边框
 *
 *  @param direction    方向
 *  @param borderColor 边框颜色
 *  @param borderWidth 边框高度
 */
-(void)setBorderWithPosition:(UIViewBorderDirection)direction color:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

/**
 *  给视图截图
 *
 *  @return 视图的截图
 */
-(UIImage *)snapshotImage;

/**
 *  根据给定frame获取视图截图
 *
 *  @param frame 要截取的frame
 */
-(UIImage *)snapshotImageWithFrame:(CGRect)frame;

/**
 *  调试（给view添加个边框颜色方便修改及查看）
 */
-(void)debug:(UIColor *)color width:(CGFloat)width;

/**
 *  移除多个视图
 */
+(void)removeViews:(NSArray *)views;

/**
 *  获取view所在的控制器
 */
- (UIViewController*)viewController;

/**
 获取响应某个方法的子视图,可能返回ni

 @param selector 方法编号
 @return 子视图
 */
- (UIView *)subViewWithResponseToSelector:(SEL)selector;

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat maxX;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat maxY;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat radius;
@end
