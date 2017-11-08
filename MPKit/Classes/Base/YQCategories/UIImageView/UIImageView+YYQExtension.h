//
//  UIImageView+YYQExtension.h
//
//  Created by 尹永奇 on 16/6/15.
//  Copyright © 2016年 尹永奇. All rights reserved.
//
//

#import <UIKit/UIKit.h>

#define YQImageCachePath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"yqCacheImageDict.data"]

@interface UIImageView (YYQExtension)

/**
 *  加载网络图片
 *
 *  @param urlString 图片的链接地址
 *  @param image     占坑图
 */
-(void)setWebImageWithURLString:(NSString *)urlString placeHloder:(UIImage *)image;

/**
 *  加载网络图片
 *
 *  @param urlString 图片的链接地址
 */
-(void)setWebImageWithURLString:(NSString *)urlString;

@end
