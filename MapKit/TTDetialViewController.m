//
//  TTDetialViewController.m
//  MapKit
//
//  Created by 业余班 on 16/4/10.
//  Copyright © 2016年 xiaoM. All rights reserved.
//

#import "TTDetialViewController.h"

@interface TTDetialViewController ()

@end

@implementation TTDetialViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    UIButton *subbtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 155, 40)];
    subbtn.backgroundColor = [UIColor redColor];
    [subbtn setTitle:@"我是按钮" forState:0];
    [self.view addSubview:subbtn];
    [subbtn addTarget:self action:@selector(saysomthing) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor = [UIColor orangeColor];
}

- (void)saysomthing{
    NSLog(@"按钮哥哥你动一个试试");
}



@end
