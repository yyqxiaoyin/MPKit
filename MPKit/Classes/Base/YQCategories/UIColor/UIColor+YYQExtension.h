//
//  UIColor+YYQExtension.h
//
//  Created by 尹永奇 on 16/6/15.
//  Copyright © 2016年 尹永奇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (YYQExtension)

//RGBColor
#define RGBColor(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]
//十六进制color
#define hexColor(colorV) [UIColor colorWithHexColorString:@#colorV]
//十六进制color带alpha
#define hexColorAlpha(colorV,a) [UIColor colorWithHexColorString:@#colorV alpha:a]
//随机颜色
#define ramdomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0f green:arc4random_uniform(255)/255.0f blue:arc4random_uniform(255)/255.0f alpha:1.0f]


/**
 *  十六进制颜色
 */
+ (UIColor *)colorWithHexColorString:(NSString *)hexColorString;

/**
 *  十六进制颜色:含alpha
 */
+ (UIColor *)colorWithHexColorString:(NSString *)hexColorString alpha:(float)alpha;


@end
