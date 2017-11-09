//
//  MPViewController.m
//  MPKit
//
//  Created by yyqxiaoyin on 11/08/2017.
//  Copyright (c) 2017 yyqxiaoyin. All rights reserved.
//

#import "MPViewController.h"
#import "MPKit.h"

@interface MPViewController ()

@end

@implementation MPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    YQAlertView *alertView = [YQAlertView alertViewWithTitle:nil message:@"123"];
//    alertView.isLastButtonActionNormalColor = YES;
    YQAlertAction *action1 = [YQAlertAction actionWithTitle:@"好的" handler:^(YQAlertAction *action) {
        
    }];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"自定义" forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 100, 40);
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    YQAlertAction *custom = [YQAlertAction actionWithCustumView:btn];
    [alertView addAction:action1];
    [alertView addAction:custom];
    [alertView show];
    
}

- (void)btnClick{
    NSLog(@"自定义View点击");
    [YQAlertView hideWithCompletion:^{
        NSLog(@"123");
        YQAlertView *alertView1 = [YQAlertView alertViewWithTitle:nil message:@"123"];
        YQAlertAction *action1 = [YQAlertAction actionWithTitle:@"好的" handler:^(YQAlertAction *action) {
            
        }];
        [alertView1 addAction:action1];
        [alertView1 show];
    }];
}

@end
