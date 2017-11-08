//
//  UIImageView+YYQExtension.h
//
//  Created by 尹永奇 on 16/6/15.
//  Copyright © 2016年 尹永奇. All rights reserved.
//
//

#import "UIImageView+YYQExtension.h"
#import "UIImage+YYQExtension.h"
#import "CALayer+YYQExtension.h"



static NSMutableDictionary *imageCacheDict;

@implementation UIImageView (YYQExtension)

+(void)initialize{
    
    if (imageCacheDict == nil) {
        imageCacheDict = [NSKeyedUnarchiver unarchiveObjectWithFile:YQImageCachePath];
        if (imageCacheDict ==nil) {
            imageCacheDict = [NSMutableDictionary dictionary];
        }
    }
    
}

-(void)setWebImageWithURLString:(NSString *)urlString placeHloder:(UIImage *)image{
   __block UIImage *cacheImage = imageCacheDict[urlString];//根据图片链接查找缓存中有没有缓存好的图片
    if (cacheImage == nil) {//没有缓存好的照片
        self.image = image;//设置占坑图片

        dispatch_async(dispatch_get_global_queue(0, 0), ^{
           //新开子线程下载图片
            cacheImage = [UIImage imageWithAnimatedGifURLString:urlString];
            if(cacheImage !=nil){
                [imageCacheDict setObject:cacheImage forKey:urlString];
                
                [NSKeyedArchiver archiveRootObject:imageCacheDict toFile:YQImageCachePath];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                [self.layer addFadeAnimationWithDuration:0.5f curve:UIViewAnimationCurveEaseInOut];

                self.image = imageCacheDict[urlString];
                
            });
            
        });
        
    }else{//有缓存好的图片。直接拿来用
        
        self.image = cacheImage;
        
    }
}

-(void)setWebImageWithURLString:(NSString *)urlString{

    [self setWebImageWithURLString:urlString placeHloder:nil];
}


@end
