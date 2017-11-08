//
//  UIView+YYQExtension.h
//
//  Created by 尹永奇 on 16/6/15.
//  Copyright © 2016年 尹永奇. All rights reserved.
//

#import "UIView+YYQExtension.h"

@implementation UIView (YYQExtension)

-(void)removeAllSubviews{
    
    while (self.subviews.count) {
        [self.subviews.lastObject removeFromSuperview];
    }
}

-(void)setBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth{
    CALayer *layer = self.layer;
    layer.borderColor = borderColor.CGColor;
    layer.borderWidth = borderWidth;
}

-(void)setBorderWithPosition:(UIViewBorderDirection)direction color:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth{
    
    UIView *borderLine = [[UIView alloc]init];
    borderLine.backgroundColor = borderColor;
    [self addSubview:borderLine];
    borderLine.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views=NSDictionaryOfVariableBindings(borderLine);
    NSDictionary *metrics=@{@"w":@(borderWidth),@"y":@(self.height - borderWidth),@"x":@(self.width - borderWidth)};
    
    
    NSString *vfl_H=@"";
    NSString *vfl_W=@"";
    
    //上
    if(UIViewBorderDirectionTop==direction){
        vfl_H=@"H:|-0-[line]-0-|";
        vfl_W=@"V:|-0-[line(==w)]";
    }
    
    //左
    if(UIViewBorderDirectionLeft==direction){
        vfl_H=@"H:|-0-[line(==w)]";
        vfl_W=@"V:|-0-[line]-0-|";
    }
    
    //下
    if(UIViewBorderDirectionBottom==direction){
        vfl_H=@"H:|-0-[line]-0-|";
        vfl_W=@"V:[line(==w)]-0-|";
    }
    
    //右
    if(UIViewBorderDirectionRight==direction){
        vfl_H=@"H:|-x-[line(==w)]";
        vfl_W=@"V:|-0-[line]-0-|";
    }
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl_H options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl_W options:0 metrics:metrics views:views]];
}

-(UIImage *)snapshotImage{
    //开启图形上下文
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    //获取当前上下文并把view的layer渲染到图形上下文
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    //从当前上下文获取截图
    UIImage *snapImage = UIGraphicsGetImageFromCurrentImageContext();
    //关闭图形上下文
    UIGraphicsEndImageContext();
    return snapImage;
}

-(UIImage *)snapshotImageWithFrame:(CGRect)frame{

    UIImage *image = [self snapshotImage];
    CGImageRef cgImageRef = CGImageCreateWithImageInRect(image.CGImage, frame);
    
    UIImage *snapImage = [UIImage imageWithCGImage:cgImageRef];
    CGImageRelease(cgImageRef);
    return snapImage;
}

-(void)debug:(UIColor *)color width:(CGFloat)width{
    [self setBorderColor:color borderWidth:width];
}

+(void)removeViews:(NSArray *)views{
    //在主线程移除需要移除的视图数组
    dispatch_async(dispatch_get_main_queue(), ^{
        for (UIView *subView in views) {
                [subView removeFromSuperview];
        }
    });
}

-(UIViewController *)viewController{

    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (UIView *)subViewWithResponseToSelector:(SEL)selector
{
    UIView *resultView = nil;
    for(UIView *subView in self.subviews)
    {
        if([subView respondsToSelector:selector])
        {
            resultView = subView;
        }
        
        if([subView subViewWithResponseToSelector:selector])
        {
            resultView = [subView subViewWithResponseToSelector:selector];
        }
    }
    return resultView;

}

-(CGFloat)x{
    return self.frame.origin.x;
}

-(void)setX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame  =frame;
}

-(CGFloat)maxX{
    return self.frame.origin.x +self.frame.size.width;
}

-(void)setMaxX:(CGFloat)maxX{
    CGRect frame = self.frame;
    frame.origin.x = maxX - frame.size.width;
    self.frame = frame;
}

-(CGFloat)y{
    return self.frame.origin.y;
}

-(void)setY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

-(CGFloat)maxY{
    return self.frame.origin.y +self.frame.size.height;
}

-(void)setMaxY:(CGFloat)maxY{
    CGRect frame = self.frame;
    frame.origin.y = maxY - frame.size.height;
    self.frame = frame;
}

-(CGFloat)width{
    return self.frame.size.width;
}

-(void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

-(CGFloat)height{
    return self.frame.size.height;
}

-(void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

-(CGFloat)centerX{
    return self.center.x;
}

-(void)setCenterX:(CGFloat)centerX{
    self.center = CGPointMake(centerX, self.center.y);
}

-(CGFloat)centerY{
    return self.center.y;
}

-(void)setCenterY:(CGFloat)centerY{
    self.center = CGPointMake(self.center.x, centerY);
}

-(CGPoint)origin{
    return self.frame.origin;
}

-(void)setOrigin:(CGPoint)origin{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

-(CGSize)size{
    return self.frame.size;
}

-(void)setSize:(CGSize)size{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

-(void)setRadius:(CGFloat)radius{
    if (radius <= 0) radius = self.frame.size.width *.5f;
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

-(CGFloat)radius{
    return self.layer.cornerRadius;
}


@end
