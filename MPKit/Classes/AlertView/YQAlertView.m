//
//  YQAlertView.m
//  YQAlertView
//
//  Created by Mopon on 2017/10/27.
//  Copyright © 2017年 YYQXiaoyin. All rights reserved.
//

#import "YQAlertView.h"

#define UIColorFromHex(s) [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1.0]
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define kScreenWidthRatio  (SCREEN_WIDTH / 375.0)
#define kScreenHeightRatio (SCREEN_HEIGHT / 667.0)
#define AdaptedWidth(x)  ceilf((x) * kScreenWidthRatio)
#define AdaptedHeight(x) ceilf((x) * kScreenHeightRatio)
#define kFontSize(R)     [UIFont systemFontOfSize:AdaptedWidth(R)]

@interface YQAlertView ()

/** 承载警告框内容的视图 */
@property (nonatomic ,strong) UIView *alertView;

/** 标题 */
@property (nonatomic ,strong) UILabel *alertTitleLabel;

/** 描述 */
@property (nonatomic ,strong) UILabel *messageLabel;

/** 水平分割线 */
//@property (nonatomic ,strong) UIView *horizontalLine;

/** 垂直分割线 */
//@property (nonatomic ,strong) UIView *verticalLine;

/** action数组 */
@property (nonatomic ,strong) NSMutableArray *actions;

/** action对应字典  eg: @"action0":action */
@property (nonatomic ,strong) NSMutableDictionary *actionsDic;

@property (nonatomic, assign) BOOL isCustom;

@end

@implementation YQAlertView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.alpha = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backgroundTap)];
        [self addGestureRecognizer:tap];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self addKeyboardNotice];
    }
    return self;
}

- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.7];
        self.frame = [UIScreen mainScreen].bounds;
    }
    return self;
}

+ (instancetype)alertViewWithTitle:(NSString *)title message:(NSString *)message{
    
    NSAttributedString *attTitle = [[NSAttributedString alloc]initWithString:title attributes:@{NSForegroundColorAttributeName : UIColorFromHex(0x282828),NSFontAttributeName :kFontSize(17)}];
    NSAttributedString *attMessage = [[NSAttributedString alloc]initWithString:message attributes:@{NSForegroundColorAttributeName : UIColorFromHex(0x282828),NSFontAttributeName :kFontSize(15)}];
    
    return [self alertViewWithAttributedTitle:attTitle attributedmessage:attMessage];
}

+ (instancetype)alertViewWithAttributedTitle:(NSAttributedString *)attributedTitle attributedmessage:(NSAttributedString *)attributedMessage{
    YQAlertView *backgroundView = [[YQAlertView alloc]init];
    backgroundView.alertTitleLabel.attributedText = attributedTitle;
    backgroundView.messageLabel.attributedText = attributedMessage;
    return backgroundView;
}

+ (instancetype)alertviewwithAttributedTitle:(NSAttributedString *)attributedTitle messgae:(NSString *)message{
    return [self alertViewWithAttributedTitle:attributedTitle attributedmessage:[[NSAttributedString alloc]initWithString:message attributes:@{NSFontAttributeName : kFontSize(15)}]];
}

+ (instancetype)alertViewWithTitle:(NSString *)title attributedmessage:(NSAttributedString *)attributedMessage{
    return [self alertViewWithAttributedTitle:
            [[NSAttributedString alloc]initWithString:title attributes:@{NSFontAttributeName : kFontSize(17),NSForegroundColorAttributeName : UIColorFromHex(0x282828)}] attributedmessage:attributedMessage];
}

- (void)addAction:(YQAlertAction *)action{
    
    if (action.alertActionType == AlertActionTypeCustom) {
        self.isCustom = YES;
    }
    
    [self.alertView addSubview:action];
    
    [self.actions addObject:action];
    
    [self.actionsDic setObject:action forKey:[NSString stringWithFormat:@"action%lu",[self.actions indexOfObject:action]]];
    
}

- (void)backgroundTap{
    [self endEditing:YES];
}

- (void)show{
    
    [self addViewsConstraints];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.3;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [_alertView.layer addAnimation:animation forKey:@"YQAlertViewAnimation"];
    
}
- (void)hide{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        for (UIView *subView in self.alertView.subviews) {
            if ([subView isKindOfClass:[YQAlertAction class]]) {
                [subView performSelector:@selector(releaseBlock)];
            }
        }
        [_alertView removeFromSuperview];
        [self removeFromSuperview];
    }];
    
}

#pragma mark - 监听键盘通知
- (void)addKeyboardNotice{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
#pragma mark - 监听键盘移动子控件
#pragma mark 键盘即将显示
- (void)keyboardWillShow:(NSNotification *)notif {
    if (self.hidden == YES) {
        return;
    }
    NSDictionary *userInfo = [notif userInfo];
    CGFloat animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect rect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat y = rect.origin.y;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    NSArray *subviews = [self subviews];
    for (UIView *sub in subviews) {
        
        CGFloat maxY = CGRectGetMaxY(sub.frame);
        if (maxY > y - 2) {
            sub.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, sub.center.y - maxY + y - 2);
        }
    }
    [UIView commitAnimations];
    
}
#pragma mark 键盘即将隐藏
- (void)keyboardWillHide:(NSNotification *)notif {
    if (self.hidden == YES) {
        return;
    }
    NSDictionary *userInfo = [notif userInfo];
    CGFloat animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    NSArray *subviews = [self subviews];
    for (UIView *sub in subviews) {
        if (sub.center.y < CGRectGetHeight(self.frame)/2.0) {
            sub.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
        }
    }
    [UIView commitAnimations];
}

- (void)dealloc{
#ifdef DEBUG
    NSLog(@"%s",__func__);
#else
#endif
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    while (self.subviews.count) {
        [self.subviews.lastObject removeFromSuperview];
    }
}

- (void)addViewsConstraints{
    
    [self alertView];
    [self alertTitleLabel];
    [self messageLabel];
//    [self horizontalLine];
    
    [_alertView removeConstraints:_alertView.constraints];
    
    [self removeConstraints:self.constraints];
    
    //self -> window
    {
        UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
        [window addSubview:self];
        
        NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(self);
        [window addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[self]|"
                                                 options:NSLayoutFormatAlignAllLeft|NSLayoutFormatAlignAllRight
                                                 metrics:nil
                                                   views:viewsDictionary]];
        [window addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[self]|"
                                                 options:NSLayoutFormatAlignAllCenterY
                                                 metrics:nil
                                                   views:viewsDictionary]];
    }
    
    //alertView -> self
    {
        [self addConstraints:[NSLayoutConstraint
                              constraintsWithVisualFormat:@"H:|-alertViewLeftRightMargin-[_alertView]-alertViewLeftRightMargin-|"
                              options:0
                              metrics:[self metrics]
                              views:NSDictionaryOfVariableBindings(_alertView)]];
        
        [self addConstraints:[NSLayoutConstraint
                              constraintsWithVisualFormat:@"V:[_alertView]"
                              options:NSLayoutFormatAlignAllLeft
                              metrics:nil
                              views:NSDictionaryOfVariableBindings(_alertView)]];
        
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:_alertView
                             attribute:NSLayoutAttributeCenterY
                             relatedBy:NSLayoutRelationEqual
                             toItem:self
                             attribute:NSLayoutAttributeCenterY
                             multiplier:1
                             constant:0]];
    }
    
    //titleLabel
    {
        [self addConstraints:[NSLayoutConstraint
                              constraintsWithVisualFormat:@"H:|-titleLeftRightMargin-[_alertTitleLabel]-titleLeftRightMargin-|"
                              options:0
                              metrics:[self metrics]
                              views:NSDictionaryOfVariableBindings(_alertTitleLabel)]];
        
        [self addConstraints:[NSLayoutConstraint
                              constraintsWithVisualFormat:@"V:|-titleLabelTop-[_alertTitleLabel]"
                              options:0
                              metrics:[self metrics]
                              views:NSDictionaryOfVariableBindings(_alertTitleLabel)]];
    }
    
    //messageLabel
    {
        NSString *vVfl = @"V:[_alertTitleLabel]-messageLabelTop-[_messageLabel]";
        
        if (self.actions.count) {//有action，需要横向分割线
//            [self horizontalLine];
            
            //actions
            vVfl = [self joinActionsContraintVFLString:vVfl];
            
        }else{//没有action。message作为最底部的控件
            if ([self titleLabelCanShow]) {//有标题
                vVfl = [vVfl stringByAppendingString:[NSString stringWithFormat:@"-%.2f-|",[self messageLabelTop] + [self titleLabelTop]]];
            }else{
                //添加跟messageTop一样的间隙在底部
                vVfl = [vVfl stringByAppendingString:[NSString stringWithFormat:@"-%.2f-|",[self messageLabelTop]]];
            }
        }
        
        NSMutableDictionary *views = [NSMutableDictionary dictionaryWithDictionary:self.actionsDic];
        [views setObject:_messageLabel forKey:@"_messageLabel"];
        [views setObject:_alertTitleLabel forKey:@"_alertTitleLabel"];
//        [views setObject:_horizontalLine forKey:@"_horizontalLine"];

        [self addConstraints:[NSLayoutConstraint
                              constraintsWithVisualFormat:@"H:|-titleLeftRightMargin-[_messageLabel]-titleLeftRightMargin-|"
                              options:0
                              metrics:[self metrics]
                              views:NSDictionaryOfVariableBindings(_messageLabel)]];
        
        [self addConstraints:[NSLayoutConstraint
                              constraintsWithVisualFormat:vVfl
                              options:0
                              metrics:[self metrics]
                              views:views]];
    }
    
    
}

- (NSString *)joinActionsContraintVFLString:(NSString *)vflString{
    
    NSMutableArray *textFieldAndCustomActions = [NSMutableArray array];
    NSMutableArray *normalActions = [NSMutableArray array];
    
    for (YQAlertAction *action in self.actions)
    {
        if (action.alertActionType == AlertActionTypeTextField || action.alertActionType == AlertActionTypeCustom) {
            [textFieldAndCustomActions addObject:action];
        }else if(action.alertActionType == AlertActionTypeNormal){
            [normalActions addObject:action];
        }
    }
    
    //添加textfield的action
    if (textFieldAndCustomActions.count) {
        for (NSInteger i =0; i<textFieldAndCustomActions.count; i++) {
            YQAlertAction *action = textFieldAndCustomActions[i];
            NSInteger index  = [self.actions indexOfObject:action];
            
            if (action.alertActionType == AlertActionTypeTextField) {
                //textField
                NSString *hVfl = [NSString stringWithFormat:@"H:|-textFieldLeftRightMargin-[action%lu]-textFieldLeftRightMargin-|",index];
                [self addConstraints:[NSLayoutConstraint
                                      constraintsWithVisualFormat:hVfl
                                      options:0
                                      metrics:[self metrics]
                                      views:[self actionsDic]]];
                vflString = [vflString stringByAppendingString:[NSString stringWithFormat:@"-textFieldActionTop-[action%lu(textFieldActionHeight)]",index]];
            }else{
                //customView
                [self addConstraints:[NSLayoutConstraint
                                      constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|[action%lu]|",index]
                                      options:0
                                      metrics:[self metrics]
                                      views:[self actionsDic]]];
                
                vflString = [vflString stringByAppendingString:[NSString stringWithFormat:@"[action%lu]",index]];
                
            }
        }
        
    }
    
    //横向分割线
//    [self addConstraints:[NSLayoutConstraint
//                          constraintsWithVisualFormat:@"H:|[_horizontalLine]|"
//                          options:0
//                          metrics:nil
//                          views:NSDictionaryOfVariableBindings(_horizontalLine)]];
//    vflString = [vflString stringByAppendingString:@"-horizontalLineTop-[_horizontalLine(==horizontalLineHeight)]"];
    vflString = [vflString stringByAppendingString:@"-horizontalLineTop-"];
    
    
    //拼接按钮的约束
    if (normalActions.count == 2) {

//        [self verticalLine];

        NSMutableDictionary *views = [NSMutableDictionary dictionaryWithDictionary:[self actionsDic]];
//        [views setObject:_verticalLine forKey:@"_verticalLine"];
        
        YQAlertAction *action0 = normalActions[0];
        YQAlertAction *action1 = normalActions[1];
        
        [action0 setBorderWithTop:YES left:NO bottom:NO right:YES borderColor:UIColorFromHex(0xe1e1e1)];
        [action1 setBorderWithTop:YES left:NO bottom:NO right:NO borderColor:UIColorFromHex(0xe1e1e1)];
        
        NSInteger firstIndexInAllActions = [self.actions indexOfObject:action0];
        NSInteger secondIndexInAllActions = [self.actions indexOfObject:action1];
        
//        NSString *hVfl = [NSString stringWithFormat:@"H:|[action%lu][_verticalLine(horizontalLineHeight)][action%lu(==action%lu)]|",
//                          firstIndexInAllActions,secondIndexInAllActions,firstIndexInAllActions];
        NSString *hVfl = [NSString stringWithFormat:@"H:|[action%lu][action%lu(==action%lu)]|",
                          firstIndexInAllActions,secondIndexInAllActions,firstIndexInAllActions];

        [self addConstraints:[NSLayoutConstraint
                              constraintsWithVisualFormat:hVfl
                              options:NSLayoutFormatAlignAllTop|NSLayoutFormatAlignAllBottom
                              metrics:[self metrics]
                              views:views]];


        return [vflString stringByAppendingString:[NSString stringWithFormat:@"[action%lu(actionHeight)]|",firstIndexInAllActions]];

    }else{
        for (NSInteger i = 0; i<normalActions.count; i++) {
            YQAlertAction *action = normalActions[i];
            [action setBorderWithTop:YES left:NO bottom:NO right:NO borderColor:UIColorFromHex(0xe1e1e1)];
            NSString *hVfl = [NSString stringWithFormat:@"H:|[action%lu]|",[self.actions indexOfObject:normalActions[i]]];
            [self addConstraints:[NSLayoutConstraint
                                  constraintsWithVisualFormat:hVfl
                                  options:0
                                  metrics:[self metrics]
                                  views:[self actionsDic]]];

            vflString = [vflString stringByAppendingString:[NSString stringWithFormat:@"[action%lu(actionHeight)]",[self.actions indexOfObject:normalActions[i]]]];
            if (i == normalActions.count - 1) {
                vflString = [vflString stringByAppendingString:@"|"];
            }
        }
    }

    return vflString;
}

#pragma mark - setter
- (void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
    if (self.alertTitleLabel) {
        NSMutableAttributedString *attTitle = [[NSMutableAttributedString alloc]initWithAttributedString:self.alertTitleLabel.attributedText];
        [attTitle addAttribute:NSForegroundColorAttributeName value:titleColor range:NSMakeRange(0, self.alertTitleLabel.attributedText.length)];
        self.alertTitleLabel.attributedText = attTitle;
    }
}

- (void)setMessageColor:(UIColor *)messageColor{
    _messageColor = messageColor;
    if (self.messageLabel) {
        NSMutableAttributedString *attMessage = [[NSMutableAttributedString alloc]initWithAttributedString:self.messageLabel.attributedText];
        [attMessage addAttribute:NSForegroundColorAttributeName value:messageColor range:NSMakeRange(0, self.messageLabel.attributedText.length)];
        self.messageLabel.attributedText = attMessage;
    }
}

- (void)setAttributedTitle:(NSAttributedString *)attributedTitle{
    _attributedTitle = attributedTitle;
    if (self.alertTitleLabel) {
        self.alertTitleLabel.attributedText = attributedTitle;
    }
}

- (void)setAttributedMessage:(NSAttributedString *)attributedMessage{
    _attributedMessage = attributedMessage;
    if (self.messageLabel) {
        self.messageLabel.attributedText = attributedMessage;
    }
}

#pragma mark - getter
- (CGFloat)titleLabelTop{
    if (self.alertTitleLabel.text.length || self.alertTitleLabel.attributedText.length) {
        return AdaptedHeight(26);
    }
    return 0;
}

- (CGFloat)messageLabelTop{
    if (self.messageLabel.text.length || self.messageLabel.attributedText.length) {
        if (!self.alertTitleLabel.text.length || !self.messageLabel.attributedText.length) {
            return AdaptedHeight(26+15);
        }
        return AdaptedHeight(15);
    }
    return 0;
}

- (CGFloat)horizontalLineTop{
    if (self.isCustom) {
        return 0;
    }
    return AdaptedHeight(22);
}

- (CGFloat)titleLeftRightMargin{
    return AdaptedWidth(10);
}

- (CGFloat)alertViewLeftRightMargin{
    return AdaptedWidth(30);
}

- (CGFloat)horizontalLineHeight{
    return (1);
}

- (CGFloat)textFieldLeftRightMargin{
    return AdaptedWidth(18);
}

- (BOOL)titleLabelCanShow{
    if (self.alertTitleLabel.text.length || self.alertTitleLabel.attributedText.length) {
        return YES;
    }
    return NO;
}

- (CGFloat)normalActionHeight{
    
    return AdaptedHeight(50);
}

- (CGFloat)textFieldActionHeight{
    return AdaptedHeight(42);
}

- (CGFloat)textFieldActionTop{
    return AdaptedHeight(13);
}

- (NSDictionary *)metrics{
    return @{
             @"titleLeftRightMargin"        :       @([self titleLeftRightMargin]),
             @"titleLabelTop"               :       @([self titleLabelTop]),
             @"messageLabelTop"             :       @([self messageLabelTop]),
             @"horizontalLineTop"           :       @([self horizontalLineTop]),
             @"alertViewLeftRightMargin"    :       @([self alertViewLeftRightMargin]),
             @"horizontalLineHeight"        :       @([self horizontalLineHeight]),
             @"actionHeight"                :       @([self normalActionHeight]),
             @"textFieldActionHeight"       :       @([self textFieldActionHeight]),
             @"textFieldLeftRightMargin"    :       @([self textFieldLeftRightMargin]),
             @"textFieldActionTop"          :       @([self textFieldActionTop])
             };
}

#pragma mark - 懒加载
- (UIView *)alertView{
    if (!_alertView) {
        _alertView = [[UIView alloc] init];
        _alertView.backgroundColor = UIColorFromHex(0xf7f7f7);
        _alertView.layer.cornerRadius = 5;
        _alertView.clipsToBounds = YES;
        _alertView.bounds = CGRectMake(0, 0, SCREEN_WIDTH - AdaptedWidth(60), AdaptedHeight(173));
        [self addSubview:_alertView];

        _alertView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _alertView;
}

-(UILabel *)alertTitleLabel{
    
    if (!_alertTitleLabel) {
        _alertTitleLabel = [[UILabel alloc]init];
        _alertTitleLabel.textColor = [self colorWithHexColorString:@"282828"];
        _alertTitleLabel.font = kFontSize(17);
        _alertTitleLabel.textAlignment = NSTextAlignmentCenter;
        _alertTitleLabel.numberOfLines = 0;
        _alertTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.alertView addSubview:_alertTitleLabel];
        
    }
    return _alertTitleLabel;
}

- (UILabel *)messageLabel{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc]init];
        _messageLabel = [[UILabel alloc]init];
        _messageLabel.textColor = [self colorWithHexColorString:@"282828"];
        _messageLabel.font = kFontSize(15);
        _messageLabel.numberOfLines = 0;
        _messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - AdaptedWidth(60) - AdaptedWidth(20);
        [self.alertView addSubview:_messageLabel];
    }
    return _messageLabel;
}

- (NSMutableArray *)actions{
    if (!_actions) {
        _actions = [NSMutableArray array];
    }
    return _actions;
}

- (NSMutableDictionary *)actionsDic{
    if (!_actionsDic) {
        _actionsDic = [NSMutableDictionary dictionary];
    }
    return _actionsDic;
}

//- (UIView *)horizontalLine{
//    if (!_horizontalLine) {
//        _horizontalLine = [UIView new];
//        _horizontalLine.backgroundColor = UIColorFromHex(0xe1e1e1);
//        _horizontalLine.translatesAutoresizingMaskIntoConstraints = NO;
//        [self.alertView addSubview:_horizontalLine];
//    }
//    return _horizontalLine;
//}

//- (UIView *)verticalLine{
//    if (!_verticalLine) {
//        _verticalLine = [UIView new];
//        _verticalLine.backgroundColor = UIColorFromHex(0xe1e1e1);
//        _verticalLine.translatesAutoresizingMaskIntoConstraints = NO;
//        [self.alertView addSubview:_verticalLine];
//    }
//    return _horizontalLine;
//}

- (UIColor *)colorWithHexColorString:(NSString *)hexColorString{
    return [self colorWithHexColorString:hexColorString alpha:1.0f];
}
#pragma mark  十六进制颜色
- (UIColor *)colorWithHexColorString:(NSString *)hexColorString alpha:(float)alpha{
    
    unsigned int red, green, blue;
    
    NSRange range;
    
    range.length =2;
    
    range.location =0;
    
    [[NSScanner scannerWithString:[hexColorString substringWithRange:range]]scanHexInt:&red];
    
    range.location =2;
    
    [[NSScanner scannerWithString:[hexColorString substringWithRange:range]]scanHexInt:&green];
    
    range.location =4;
    
    [[NSScanner scannerWithString:[hexColorString substringWithRange:range]]scanHexInt:&blue];
    
    UIColor *color = [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green/255.0f)blue:(float)(blue/255.0f)alpha:alpha];
    
    return color;
}

@end


@interface YQAlertAction ()

/** normalAction的回调 */
@property (nonatomic ,copy) AlertActionNormalHandler normalHandler;

/** textField的回调 */
@property (nonatomic ,copy) AlertActionTextFieldHandle textFieldHandler;

/** 标题 */
@property (nonatomic ,strong) NSString *title;

/** 属性标题 */
@property (nonatomic ,strong) NSAttributedString *attributedTitle;

/** textField */
@property (nonatomic ,strong) UITextField *textField;

/** 自定义View */
@property (nonatomic ,strong) UIView *customView;

/** button */
@property (nonatomic ,strong) UIButton *button;

@property (nonatomic ,strong) CALayer *leftLineLayer;

@property (nonatomic ,strong) CALayer *rightLineLayer;

@property (nonatomic ,strong) CALayer *topLineLayer;

@property (nonatomic ,strong) CALayer *bottomLineLayer;

@end

@implementation YQAlertAction

- (instancetype)init{
    self = [super init];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

+ (instancetype)actionWithTitle:(NSString *)title
                        handler:(AlertActionNormalHandler)handler{
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName : kFontSize(17),
                                 NSForegroundColorAttributeName : UIColorFromHex(666666),
                                 };
    NSAttributedString *attString = [[NSAttributedString alloc]initWithString:title attributes:attributes];
    return [self actionWithAttributedTitle:attString handler:handler];
}

+ (instancetype)actionWithAttributedTitle:(NSAttributedString *)attributedTitle handler:(AlertActionNormalHandler)handler{
    YQAlertAction *action = [[YQAlertAction alloc]init];
    action.normalHandler = handler;
    action.attributedTitle = attributedTitle;
    [action setAlertActionType:AlertActionTypeNormal];
    [action setupViewsWithNormalWithAttributedTitle:attributedTitle];
    return action;
}

+ (instancetype)actionWithTitle:(NSString *)title titleColor:(UIColor *)titleColor handler:(AlertActionNormalHandler)handler{
    NSAttributedString *attTitle = [[NSAttributedString alloc]initWithString:title attributes:@{NSForegroundColorAttributeName : titleColor,NSFontAttributeName : kFontSize(17)}];
    return [self actionWithAttributedTitle:attTitle handler:handler];
}

+ (instancetype)actionWithTextField:(UITextField *)textField
                             handle:(AlertActionTextFieldHandle)handler{
    
    YQAlertAction *action = [[YQAlertAction alloc]init];
    action.textFieldHandler = handler;
    action.textField = textField;
    [action setAlertActionType:AlertActionTypeTextField];
    [action setupViewsWithTextField];
    return action;
}

+ (instancetype)actionWithCustumView:(UIView *)customView{
    YQAlertAction *action = [[YQAlertAction alloc]init];
    [action setAlertActionType:AlertActionTypeCustom];
    action.customView = customView;
    [action setupViewsWithCustomView];
    return action;
}

- (void)setupViewsWithCustomView{
    [self addSubview:self.customView];
    self.customView.translatesAutoresizingMaskIntoConstraints = NO;
    CGRect frame = self.customView.frame;
    NSString *Hvfl = @"|[_customView]|";
    NSString *Vvfl = @"|[_customView]|";
    NSMutableDictionary *metrics = [NSMutableDictionary dictionary];
    if (!CGRectEqualToRect(CGRectZero, frame)) {
        [metrics setObject:@(frame.origin.x) forKey:@"left"];
        [metrics setObject:@(frame.origin.y) forKey:@"top"];
        [metrics setObject:@(frame.size.width) forKey:@"width"];
        [metrics setObject:@(frame.size.height) forKey:@"height"];
        
        Hvfl = @"H:|-left-[_customView(width)]";
        Vvfl = @"V:|-top-[_customView(height@1000)]|";
    }
    NSDictionary *views = NSDictionaryOfVariableBindings(_customView);
    NSArray *Hconstraints = [NSLayoutConstraint constraintsWithVisualFormat:Hvfl options:0 metrics:metrics views:views];
    NSArray *Vconstraints = [NSLayoutConstraint constraintsWithVisualFormat:Vvfl options:0 metrics:metrics views:views];
    [self addConstraints:Hconstraints];
    [self addConstraints:Vconstraints];
}

- (void)setupViewsWithTextField{
    [self addSubview:self.textField];
    self.textField.translatesAutoresizingMaskIntoConstraints = NO;
    NSString *Hvfl = @"H:|[_textField]|";
    NSString *Vvfl = @"V:|[_textField]|";
    NSDictionary *views = NSDictionaryOfVariableBindings(_textField);
    NSArray *Hconstraints = [NSLayoutConstraint constraintsWithVisualFormat:Hvfl options:NSLayoutFormatAlignAllLeft|NSLayoutFormatAlignAllRight metrics:nil views:views];
    NSArray *Vconstraints = [NSLayoutConstraint constraintsWithVisualFormat:Vvfl options:NSLayoutFormatAlignAllCenterY metrics:nil views:views];
    
    [self addConstraints:Hconstraints];
    [self addConstraints:Vconstraints];

}

- (void)setupViewsWithNormalWithAttributedTitle:(NSAttributedString *)attString{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setAttributedTitle:attString forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:btn];
    self.button = btn;
    
    NSString *Hvfl = @"H:|[btn]|";
    NSString *Vvfl = @"V:|[btn]|";
    NSDictionary *views = NSDictionaryOfVariableBindings(btn);
    NSArray *Hconstraints = [NSLayoutConstraint constraintsWithVisualFormat:Hvfl options:NSLayoutFormatAlignAllLeft|NSLayoutFormatAlignAllRight metrics:nil views:views];
    NSArray *Vconstraints = [NSLayoutConstraint constraintsWithVisualFormat:Vvfl options:NSLayoutFormatAlignAllCenterY metrics:nil views:views];
    
    [self addConstraints:Hconstraints];
    [self addConstraints:Vconstraints];
    
}

- (void)setBorderWithTop:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color
{
    if (top && !self.topLineLayer) {
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = color.CGColor;
        [self.layer addSublayer:layer];
        self.topLineLayer = layer;
    }
    if (left && !self.leftLineLayer) {
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = color.CGColor;
        [self.layer addSublayer:layer];
        self.leftLineLayer = layer;
    }
    if (bottom && !self.bottomLineLayer) {
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = color.CGColor;
        [self.layer addSublayer:layer];
        self.bottomLineLayer = layer;
    }
    if (right && !self.rightLineLayer) {
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = color.CGColor;
        [self.layer addSublayer:layer];
        self.rightLineLayer = layer;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];

    if (self.topLineLayer) {
        self.topLineLayer.frame = CGRectMake(0, 0, self.frame.size.width, 1);
    }
    if (self.leftLineLayer) {
        self.leftLineLayer.frame = CGRectMake(0, 0, 1, self.frame.size.height);
    }
    if (self.bottomLineLayer) {
        self.bottomLineLayer.frame = CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1);
    }
    if (self.rightLineLayer) {
        self.rightLineLayer.frame = CGRectMake(self.frame.size.width - 1, 0, 1, self.frame.size.height);
    }
}

- (void)setAlertActionType:(AlertActionType)alertActionType{
    _alertActionType = alertActionType;
}

- (void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
    if (self.button) {
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithAttributedString:self.button.currentAttributedTitle];
        [attString addAttribute:NSForegroundColorAttributeName value:titleColor range:NSMakeRange(0, self.button.currentAttributedTitle.length)];
        [self.button setAttributedTitle:attString forState:UIControlStateNormal];
    }
}

- (void)btnClick:(UIButton *)sender{
    __weak typeof (self)weakSelf = self;
    if (self.normalHandler) {
        self.normalHandler(weakSelf);
        UIView *view = weakSelf.superview;
        while (view) {
            if ([view isKindOfClass:[YQAlertView class]]) {
                if ([view respondsToSelector:@selector(hide)]) {
                    [view performSelector:@selector(hide) withObject:nil afterDelay:0.0f];
                }
                break;
            }
            view = view.superview;
        }
    }
}

- (void)releaseBlock{
    self.normalHandler = nil;
    self.textFieldHandler = nil;
}

@end
