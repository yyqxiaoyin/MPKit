//
//  CALayer+YYQExtension.h
//
//  Created by 尹永奇 on 16/6/15.
//  Copyright © 2016年 尹永奇. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    
    //方块翻转
    TransitionTypeCube,
    
    //抽离
    TransitionTypeSuckEffect,
    
    //水纹波动
    TransitionTypeRippleEffect,
    
    //上翻页
    TransitionTypePageCurl,
    
    //下翻页
    TransitionTypePageUnCurl,
    
    //翻转
    TransitionTypeOglFlip,
    
    //镜头快门开
    TransitionTypeCameraIrisHollowOpen,
    
    //镜头快门关
    TransitionTypeCameraIrisHollowClose,
    
    //随机
    TransitionTypeRamdom,
    
} TransitionType;

/**
 动画方向
 */
typedef enum : NSUInteger {
    //从上
    TransitionSubtypeFromTop=0,
    
    //从左
    TransitionSubtypeFromLeft,
    
    //从下
    TransitionSubtypeFromBotoom,
    
    //从右
    TransitionSubtypeFromRight,
    
    //随机
    TransitionSubtypeFromRamdom,
    
} TransitionSubType;

/**
 动画曲线
 */
typedef enum : NSUInteger {
    
    //默认
    TransitionCurveDefault,
    
    //缓进
    TransitionCurveEaseIn,
    
    //缓出
    TransitionCurveEaseOut,
    
    //缓进缓出
    TransitionCurveEaseInEaseOut,
    
    //线性
    TransitionCurveLinear,
    
    //随机
    TransitionCurveRamdom,

} TransitionCurve;


@interface CALayer (YYQExtension)


#pragma mark - 动画
/**
 *  给layer加上转场动画
 *
 *  @param transitionType    动画类型
 *  @param transitionSubType 动画方向
 *  @param transitionCurve   动画曲线
 *  @param duration          动画时间
 */
-(void)transitionWithTransitionType:(TransitionType )transitionType transitionSubType:(TransitionSubType)transitionSubType transitionCurve:(TransitionCurve)transitionCurve duration:(CGFloat )duration;


/**
 *  抖动动画
 *
 *  @param region      抖动幅度
 *  @param duration    抖动时间（控制抖动速率）
 *  @param repeatCount 抖动重复次数
 */
-(void)transitionShakeWithAngle:(CGFloat)region duration:(CGFloat)duration repeatCount:(NSInteger)repeatCount;

/**
 *  缩小后放大再还原(如按钮点击动画)
 *
 *  @param duration 动画时长
 *  @param maxScale 放大的最大倍数
 *  @param minScale 缩小最小倍数
 */
-(void)transitionClickWithDuration:(CGFloat)duration maxScale:(CGFloat)maxScale minScale:(CGFloat)minScale;

/**
 *  渐入渐出动画
 *
 *  @param duration 动画时长
 *  @param curve    动画取消
 */
- (void)addFadeAnimationWithDuration:(NSTimeInterval)duration curve:(UIViewAnimationCurve)curve;


#pragma mari - 基础

/**
 *  设置layer边框宽度跟layer边框颜色
 *
 *  @param borderColor 边框颜色
 *  @param borderWidth 边框宽度
 */
-(void)setBorderColor:(CGColorRef)borderColor borderWidth:(CGFloat)borderWidth;


@end
