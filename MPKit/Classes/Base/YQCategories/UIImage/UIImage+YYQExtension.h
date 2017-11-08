//
//  UIImage+YYQExtension.h
//
//  Created by 尹永奇 on 16/6/15.
//  Copyright © 2016年 尹永奇. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImage (YYQExtension)

/**
 *  获取app启动图名字
 */
+(NSString *)getLaunchImageName;

/**
 *  获取app启动图
 */
+(UIImage *)getLaunchImage;

/**
 *  根据颜色生成一个1x1点的图片
 */
+(UIImage *)imageWithColor:(UIColor *)color;

/**
 *  根据颜色生成一个图片
 *
 *  @param color 颜色
 *  @param size  图片大小
 */
+(UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 *  根据提供的图片名字自定义比例生成一个拉伸的图片
 *
 *  @param imageName 图片名字
 *  @param leftCap   拉伸左边起点
 *  @param topCap    拉伸上边起点
 */
+(UIImage *)resizeWithImageName:(NSString *)imageName leftCap:(CGFloat)leftCap topCap:(CGFloat)topCap;


/**
 *  根据gif文件名生成一个动态image
 *
 *  @param name gif文件的名字
 */
+(UIImage *)imageWithAnimatedGIFName:(NSString *)name;

/**
 *  根据gif data文件生成一个动态图
 *
 *  @param data gif文件data
 */
+(UIImage *)imageWithAnimatedGIFData:(NSData *)data;

/**
 *  根据gif链接生成一个动态图(注意这是一个同步请求，若有需要。放在子线程执行)
 *
 *  @param urlString gif的链接
 */
+(UIImage *)imageWithAnimatedGifURLString:(NSString *)urlString;

/**
 *  生成一个模糊的image（透明蒙层）
 */
-(UIImage *)imageByBlurLightEffect;

/**
 *  生成一个模糊的image（白色蒙层）
 */
- (UIImage *)imageByExtraLightEffect;

/**
 *  生成一个模糊的image（黑色蒙层）
 */
-(UIImage *)imageByBlurDarkEffect;

/**
 *  生成一个模糊的image（自定义颜色蒙层）
 *
 *  @param tintColor 蒙层颜色
 */
-(UIImage *)imageByTintEffectWithColor:(UIColor *)tintColor;

/**
 *  生成一个模糊图片（自定义模糊程度）
 *
 *  @param fuzzy   0~68.5f（范围）
 *  @param density 0~5.0f （范围）
 */
-(UIImage *)imageByBlurWithFuzzy:(CGFloat)fuzzy density:(CGFloat)density;

/**
 *  调整image方向
 *  通过相机或是在相册中取图片上传到服务器的时候，服务器端显示的图片的方向可能会向左旋转
 */
-(UIImage *)fixOrientation;

/**
 *  image设置圆角
 *
 *  @param radius 圆角
 */
-(UIImage*)imageWithCornerRadius:(CGFloat)radius;

/**
 *  返回圆形图片
 */
- (instancetype)circleImage;

+ (instancetype)circleImage:(NSString *)name;

/**
 *  根据传进来的UIView生成UIImage对象
 */
+ (UIImage *) imageWithView:(UIView *)view;

- (UIImage *)clipWithRect:(CGRect)clipRect clipImage:(UIImage *)clipImage;

@end
