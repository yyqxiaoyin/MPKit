//
//  UIBarButtonItem+YYQExtension.m
//  Pods-YYQCategory_Example
//
//  Created by Mopon on 2017/10/18.
//

#import "UIBarButtonItem+YYQExtension.h"

@implementation UIBarButtonItem (YYQExtension)

+ (instancetype)mp_barBtnItemWithNmlImg:(NSString *)nmlImg hltImg:(NSString *)hltImg target:(id)target action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *nmlImage = [UIImage imageNamed:nmlImg];
    
    [btn setImage:nmlImage forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:hltImg] forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    btn.bounds = CGRectMake(0, 0,nmlImage.size.width,nmlImage.size.height );
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

+ (instancetype)mp_barBtnItemWithNmlImg:(NSString *)nmlImg
                                 hltImg:(NSString *)hltImg
                                 selImg:(NSString *)selImg
                                 target:(id)target
                                 action:(SEL)action{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *nmlImage = [UIImage imageNamed:nmlImg];
    
    [btn setImage:nmlImage forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:selImg] forState:UIControlStateSelected];
    [btn setImage:[UIImage imageNamed:hltImg] forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    btn.bounds = CGRectMake(0, 0,nmlImage.size.width,nmlImage.size.height  );
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
    
}

+ (instancetype)mp_barBtnItemWithTitle:(NSString *)title titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont target:(id)target action:(SEL)action{
    
    CGSize maxSize =  CGSizeMake(MAXFLOAT, MAXFLOAT);
    
    CGSize titleSize = [title boundingRectWithSize:maxSize
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName:titleFont}
                                           context:nil].size;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    
    //设置不可用字体颜色
    [btn setTitleColor:[UIColor colorWithRed:157/255.0 green:157/255.0 blue:157/255.0 alpha:1.0]
              forState:UIControlStateDisabled];
    
    //设置字体大小
    btn.titleLabel.font = titleFont;
    btn.bounds = CGRectMake(0, 0, titleSize.width, titleSize.height);
    
    //事件
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

@end
