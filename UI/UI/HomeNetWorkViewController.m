//
//  HomeNetWorkViewController.m
//  UI
//
//  Created by WeixiYu on 15/8/19.
//  Copyright (c) 2015年 liveabean. All rights reserved.
//

#import "HomeNetWorkViewController.h"
#import "UnfoldToolBar.h"

@interface HomeNetWorkViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *lampView;
@property (weak, nonatomic) IBOutlet UISlider *lightSlider;

@property (assign,nonatomic) NSInteger lampImageCnt;
@end

@implementation HomeNetWorkViewController{
    UIImageView *homeView;
}


-(NSInteger)lampImageCnt{
    if (!_lampImageCnt) {
        _lampImageCnt=4;
    }
    return _lampImageCnt;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor blackColor];
    //背景图层
    CGFloat viewW=self.view.frame.size.width;
    CGFloat viewH=self.view.frame.size.height;
    homeView=[[UIImageView alloc]init];
    homeView.frame=CGRectMake(0, -200, viewW, viewH+200);
    homeView.image=[UIImage imageNamed:@"pureblue"];
    [self.view insertSubview:homeView atIndex:0];
    
    //隐藏导航条
    self.navigationController.navigationBarHidden=YES;
    
    //对sliderView的定制
    self.lightSlider.maximumTrackTintColor=[UIColor grayColor];
    self.lightSlider.minimumTrackTintColor=[UIColor whiteColor];
    self.lightSlider.maximumValue=6.99;
    self.lightSlider.value=4;
    homeView.alpha=self.lightSlider.value/30.0+0.777;
    [self.lightSlider setThumbImage:[UIImage imageNamed:@"playbar_slider_thumb"] forState:UIControlStateNormal];
    
    //可展开的旋转菜单
    UnfoldToolBar *toolBar=[[UnfoldToolBar alloc]initWithFrame:CGRectMake(viewW*0.1, viewH*0.7, viewW*0.9, 50)];
//    toolBar.backgroundColor=[UIColor redColor];
    [self.view insertSubview:toolBar aboveSubview:homeView];
}

#pragma mark slideChange
- (IBAction)slideChange:(UISlider *)sender {
    int selectedInt=sender.value;
    int initialInt=self.lampImageCnt;
    
    homeView.alpha=selectedInt/30.0+0.777;
    if (selectedInt==initialInt) {
        return ;
    }
    NSLog(@"%d",selectedInt);
    NSString *imgName=[NSString stringWithFormat:@"lamp%d",selectedInt];
    self.lampView.image=[UIImage imageNamed:imgName];
    CATransition *annimation = [CATransition animation];
    annimation.type=@"fade";
    annimation.duration=abs(selectedInt-initialInt)/4.0;
    [self.lampView.layer addAnimation:annimation forKey:nil];
    self.lampImageCnt=sender.value;
}




@end
