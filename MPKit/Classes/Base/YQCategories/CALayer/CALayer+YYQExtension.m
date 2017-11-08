//
//  CALayer+YYQExtension.h
//
//  Created by 尹永奇 on 16/6/15.
//  Copyright © 2016年 尹永奇. All rights reserved.
//

#import "CALayer+YYQExtension.h"

@implementation CALayer (YYQExtension)

#pragma mark - 动画

//抖动动画
-(void)transitionShakeWithAngle:(CGFloat)angle duration:(CGFloat)duration repeatCount:(NSInteger)repeatCount{

    NSString *aniKey = @"yyqShakeKey";
    if ([self animationForKey:aniKey] != nil) {
        [self removeAnimationForKey:aniKey];
    }
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.rotation.z";
    anim.values = @[@((-angle) / 180.0 * M_PI), @((angle) / 180.0 * M_PI), @((-angle) / 180.0 * M_PI)];
    anim.duration = duration;
    anim.repeatCount = repeatCount;
    anim.removedOnCompletion = NO;
    
    [self addAnimation:anim forKey:aniKey];
}

-(void)transitionClickWithDuration:(CGFloat)duration maxScale:(CGFloat)maxScale minScale:(CGFloat)minScale{
    
    NSString *aniKey = @"yyqClickKey";
    if ([self animationForKey:aniKey] != nil) {
        [self removeAnimationForKey:aniKey];
    }
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = duration;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(maxScale, maxScale, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(minScale, minScale, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    
    [self addAnimation:animation forKey:aniKey];

}

- (void)addFadeAnimationWithDuration:(NSTimeInterval)duration curve:(UIViewAnimationCurve)curve {
    if (duration <= 0) return;
    
    NSString *mediaFunction;
    switch (curve) {
        case UIViewAnimationCurveEaseInOut: {
            mediaFunction = kCAMediaTimingFunctionEaseInEaseOut;
        } break;
        case UIViewAnimationCurveEaseIn: {
            mediaFunction = kCAMediaTimingFunctionEaseIn;
        } break;
        case UIViewAnimationCurveEaseOut: {
            mediaFunction = kCAMediaTimingFunctionEaseOut;
        } break;
        case UIViewAnimationCurveLinear: {
            mediaFunction = kCAMediaTimingFunctionLinear;
        } break;
        default: {
            mediaFunction = kCAMediaTimingFunctionLinear;
        } break;
    }
    
    CATransition *transition = [CATransition animation];
    transition.duration = duration;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:mediaFunction];
    transition.type = kCATransitionFade;
    [self addAnimation:transition forKey:@"yykit.fade"];
}


//转场动画
-(void)transitionWithTransitionType:(TransitionType)transitionType transitionSubType:(TransitionSubType)transitionSubType transitionCurve:(TransitionCurve)transitionCurve duration:(CGFloat)duration{

    NSString *aniKey = @"yyqTransitionKey";
    if ([self animationForKey:aniKey] != nil) {
        [self removeAnimationForKey:aniKey];
    }
    
    CATransition *transition = [CATransition animation];
    
    //动画持续时间
    transition.duration = duration;
    
    //动画类型
    transition.type =[self animationTypeWithTransitionType:transitionType];
    
    //动画的方向
    transition.subtype = [self animationSubType:transitionSubType];
    
    //动画的曲线函数
    transition.timingFunction = [CAMediaTimingFunction functionWithName:[self animationTimingFunctionName:transitionCurve]];
    
    //动画完成后删除
    transition.removedOnCompletion = YES;
    
    [self addAnimation:transition forKey:aniKey];
    
}

/**
 *  选择动画曲线
 */
-(NSString *)animationTimingFunctionName:(TransitionCurve)curve{

    NSArray *curveArr = [NSArray arrayWithObjects:
                         kCAMediaTimingFunctionDefault,
                         kCAMediaTimingFunctionEaseIn,
                         kCAMediaTimingFunctionEaseOut,
                         kCAMediaTimingFunctionEaseInEaseOut,
                         kCAMediaTimingFunctionLinear,
                         nil];
    
   return  [self selectedObjectInArray:curveArr index:curve isRamdom:(curve == TransitionCurveRamdom)];

}

/**
 *  选择动画方向
 */
-(NSString *)animationSubType:(TransitionSubType)subType{

    NSArray *subTypeArr = [NSArray arrayWithObjects:
                           kCATransitionFromTop,
                           kCATransitionFromLeft,
                           kCATransitionFromBottom,
                           kCATransitionFromRight,
                           nil];
    
    return [self selectedObjectInArray:subTypeArr index:subType isRamdom:(subType == TransitionSubtypeFromRamdom)];
}


/**
 *  选择动画类型
 */
-(NSString *)animationTypeWithTransitionType:(TransitionType)type{
    
    NSArray *animationType = [NSArray arrayWithObjects:
                              @"cube",
                              @"suckEffect",
                              @"rippleEffect",
                              @"pageCurl",
                              @"pageUnCurl",
                              @"oglFlip",
                              @"cameraIrisHollowOpen",
                              @"cameraIrisHollowClose",
                              nil];
    return [self selectedObjectInArray:animationType index:type isRamdom:(type ==  TransitionTypeRamdom)];
}


-(id)selectedObjectInArray:(NSArray *)array index:(NSInteger)index isRamdom:(BOOL)isRamdom{
    
    NSInteger count = array.count;
    
    NSInteger i = isRamdom ?arc4random_uniform((u_int32_t)count) : index;
    
    return [array objectAtIndex:i];

}

#pragma mark - 基础
-(void)setBorderColor:(CGColorRef)borderColor borderWidth:(CGFloat)borderWidth{

    self.borderWidth = borderWidth;
    self.borderColor = borderColor;

}

@end
