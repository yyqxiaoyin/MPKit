//
//  UIImage+YYQExtension.m
//
//  Created by 尹永奇 on 16/6/15.
//  Copyright © 2016年 尹永奇. All rights reserved.
//

#import "UIImage+YYQExtension.h"
#import "UIImage+ImageEffects.h"
#import <ImageIO/ImageIO.h>


@implementation UIImage (YYQExtension)

+(NSString *)getLaunchImageName{
    
    NSString *viewOrientation = @"Portrait";
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        
        viewOrientation = @"Landscape";
    }
    NSString *launchImageName = nil;
    NSArray *imageDict = [[[NSBundle mainBundle] infoDictionary]valueForKey:@"UILaunchImages"];
    
    CGSize viewSize  = [[UIApplication sharedApplication].windows firstObject].bounds.size;
    for (NSDictionary *dict in imageDict) {
        
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            
            launchImageName = dict[@"UILaunchImageName"];
            
        }
        
    }
    return launchImageName;
}

+(UIImage *)getLaunchImage{
    
    return [UIImage imageNamed:[self getLaunchImageName]];
}

+(UIImage *)imageWithColor:(UIColor *)color{
    return [self imageWithColor:color size:CGSizeMake(1, 1)];
}

+(UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    if (!color ||size.width<=0 ||size.height<=0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+(UIImage *)resizeWithImageName:(NSString *)imageName leftCap:(CGFloat)leftCap topCap:(CGFloat)topCap{
    UIImage *image = [self imageNamed:imageName];
    return [image stretchableImageWithLeftCapWidth:image.size.width*leftCap topCapHeight:image.size.height * topCap];
}

+(UIImage *)imageWithAnimatedGIFName:(NSString *)name{
    CGFloat scale = [UIScreen mainScreen].scale;
    if (scale >1.0f) {
        NSInteger scaleI = (NSInteger)scale;
        NSString *retinaPath = [[NSBundle mainBundle]pathForResource:[name stringByAppendingString:[NSString stringWithFormat:@"@%zdx",scaleI]] ofType:@"gif"];
        
        NSData *data = [NSData dataWithContentsOfFile:retinaPath];
        
        if (data) {
            return [UIImage imageWithAnimatedGIFData:data];
        }
        
        return [UIImage imageNamed:name];
    }
    else{
        NSString *path = [[NSBundle mainBundle]pathForResource:name ofType:@"gif"];
        
        NSData *data = [NSData dataWithContentsOfFile:path];
        
        if (data) {
            return [UIImage imageWithAnimatedGIFData:data];
        }
        
        return [UIImage imageNamed:name];
    }
}

+(UIImage *)imageWithAnimatedGifURLString:(NSString *)urlString{
    
    UIImage *animatedImage;
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    
    animatedImage =  [self imageWithAnimatedGIFData:imageData];
    
    return animatedImage;
}

+(UIImage *)imageWithAnimatedGIFData:(NSData *)data{
    if (!data) return nil;
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    size_t count =  CGImageSourceGetCount(source);
    
    UIImage *animatedImage;
    
    if (count <=1) {
        animatedImage = [[UIImage alloc]initWithData:data];
    }
    else{
        NSMutableArray *images = @[].mutableCopy;
        
        NSTimeInterval duration = 0.0f;
        
        for (size_t i =0; i<count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            duration += [self frameDurationAtIndex:i source:source];
            
            [images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
            CFRelease(image);
        }
        
        if (!duration) {
            duration = (1.0 / 10.0f) *count;//如果获取不到gif内的动画时间。默认为这个时间
        }
        
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }
    
    CFRelease(source);
    
    return animatedImage;
}

//计算每一帧图片的动画时间
+(float)frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source{
    float frameDuration = 0.1f;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, NULL);
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    
    }else{
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp) {
            frameDuration = [delayTimeProp floatValue];
        }
    }
    CFRelease(cfFrameProperties);
    return frameDuration;
}

-(UIImage *)imageByBlurLightEffect{
    
    return [self applyLightEffect];
}

-(UIImage *)imageByBlurDarkEffect{

    return [self applyDarkEffect];
}

-(UIImage *)imageByExtraLightEffect{
    return [self applyExtraLightEffect];
}

-(UIImage *)imageByTintEffectWithColor:(UIColor *)tintColor{
    return [self applyTintEffectWithColor:tintColor];
}
-(UIImage *)imageByBlurWithFuzzy:(CGFloat)fuzzy density:(CGFloat)density{

    UIImage *image = [self applyBlurWithRadius:fuzzy tintColor:nil saturationDeltaFactor:density maskImage:nil];
    return image;
}
- (UIImage *)fixOrientation {
    
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

-(UIImage*)imageWithCornerRadius:(CGFloat)radius{
    
    CGRect rect = (CGRect){0.f,0.f,self.size};
  
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [UIScreen mainScreen].scale);
    
    CGContextAddPath(UIGraphicsGetCurrentContext(), [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath);
    [[UIColor whiteColor] setFill];
    [self drawInRect:rect];

    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (instancetype)circleImage
{
    // 开启图形上下文
    UIGraphicsBeginImageContext(self.size);
    
    // 上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 添加一个圆
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctx, rect);
    
    // 裁剪
    CGContextClip(ctx);
    
    // 绘制图片
    [self drawInRect:rect];
    
    // 获得图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭图形上下文
    UIGraphicsEndImageContext();
    
    return image;
}

+ (instancetype)circleImage:(NSString *)name
{
    return [[self imageNamed:name] circleImage];
}



+ (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, [[UIScreen mainScreen] scale]);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIImage *)clipWithRect:(CGRect)clipRect clipImage:(UIImage *)clipImage{

    UIGraphicsBeginImageContext(clipRect.size);
    
    [clipImage drawInRect:CGRectMake(0, -clipRect.origin.y, clipRect.size.width, clipRect.size.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return  newImage;
}

@end
