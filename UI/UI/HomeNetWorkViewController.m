//
//  HomeNetWorkViewController.m
//  UI
//
//  Created by WeixiYu on 15/8/19.
//  Copyright (c) 2015年 liveabean. All rights reserved.
//

#import "HomeNetWorkViewController.h"

@interface HomeNetWorkViewController ()

@end

@implementation HomeNetWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat viewW=self.view.frame.size.width;
    CGFloat viewH=self.view.frame.size.height;
    UIImageView *homeView=[[UIImageView alloc]init];
    homeView.frame=CGRectMake(0, 0, viewW, viewH);
//    homeView.image=[UIImage imageNamed:@"try"];
    [self.view addSubview:homeView];
}


@end
