//
//  UILabel+YYQExtension.m
//  Pods-YYQCategory_Example
//
//  Created by Mopon on 2017/10/18.
//

#import "UILabel+YYQExtension.h"
#import <objc/runtime.h>

@implementation UILabel (YYQExtension)

-  (CGFloat)attributeTextHeightWithSize:(CGSize)size
{
    
    CGSize labelsize = [self sizeThatFits:size];
    
    return labelsize.height;
}

-(void)alignBottom
{
    CGSize fontSize = [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}];
    double height = fontSize.height*self.numberOfLines;
    double width = self.frame.size.width;
    CGSize stringSize = [self.text boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size;
    NSInteger line = (height - stringSize.height) / fontSize.height;
    // 前面补齐换行符
    for (int i = 0; i < line; i++) {
        self.text = [NSString stringWithFormat:@" \n%@", self.text];
    }
}
@end
