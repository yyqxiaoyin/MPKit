//
//  UIFont+YYQExtension.m
//  MoponChinaFilm
//
//  Created by Mopon on 16/10/23.
//  Copyright © 2016年 Mopon. All rights reserved.
//

#import "UIFont+YYQExtension.h"

@implementation UIFont (YYQExtension)

-(CGFloat)realLineHeight{

    CGFloat realHeight = self.lineHeight - (self.lineHeight - self.pointSize);
    
    return realHeight;
}

@end
