//
//  UnfoldToolBar.m
//  UI
//
//  Created by WeixiYu on 15/8/20.
//  Copyright (c) 2015年 liveabean. All rights reserved.
//

#import "UnfoldToolBar.h"
#define animationDuration 2
@interface UnfoldToolBar()
@property (strong,nonatomic) UIButton *mainBtn;
@property (strong,nonatomic) UIButton *blueToothBtn;
@property (strong,nonatomic) UIButton *wifiBtn;
@end
@implementation UnfoldToolBar{
    CGRect toolBarframe;
    enum{
        MAINBTNSHOWONLY,//只展示主按钮
        BLUETOOTHBTNSHOWONLY,
        WIFIBTNSHOWONLY,
        ALLSHOW, //展示所有btn
    }showState;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        toolBarframe=frame;
        [self generate];
    }
    return self;
}

-(void)generate{
    
    
    self.mainBtn=[[UIButton alloc]init];
    self.mainBtn.frame=CGRectMake(1, 1, 48, 48);
    [self.mainBtn setBackgroundImage:[UIImage imageNamed:@"mainBtn"] forState:UIControlStateNormal];
    [self.mainBtn addTarget:self action:@selector(touchmainBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.mainBtn];
    
    
    
    self.blueToothBtn=[[UIButton alloc]init];
    self.blueToothBtn.frame=CGRectMake(1, 1, 48, 48);
    self.blueToothBtn.tag=1;
    [self.blueToothBtn setBackgroundImage:[UIImage imageNamed:@"bluetooth"] forState:UIControlStateNormal];
    [self.blueToothBtn addTarget:self action:@selector(touchBlueToothBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.blueToothBtn];
    
    
    
    self.wifiBtn=[[UIButton alloc]init];
    self.wifiBtn.frame=CGRectMake(1, 1, 48, 48);
    self.wifiBtn.tag=2;
    [self.wifiBtn addTarget:self action:@selector(touchWifiBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.wifiBtn setBackgroundImage:[UIImage imageNamed:@"wifi"] forState:UIControlStateNormal];
    [self addSubview:self.wifiBtn];
    [self bringSubviewToFront:self.mainBtn];
    
}
-(void)touchmainBtn{
    NSLog(@"%s",__func__);
    if (showState==MAINBTNSHOWONLY) {
        [UIView animateWithDuration:animationDuration animations:^{
            self.mainBtn.transform=CGAffineTransformMakeRotation(M_PI_2);
        }];
        //设置蓝牙按钮坐标
        CGFloat blueToothBtnX=toolBarframe.size.width*0.35;
        CGFloat btnY=self.mainBtn.center.y;
        [self unfoldBtnWithBtnY:btnY andBtnX:blueToothBtnX inView:self.wifiBtn];
        //设置Wifi按钮坐标
        CGFloat wifiBtnX=toolBarframe.size.width*0.65;
        [self unfoldBtnWithBtnY:btnY andBtnX:wifiBtnX inView:self.blueToothBtn];
        //改变展示状态
        showState=ALLSHOW;
    }else if (showState==BLUETOOTHBTNSHOWONLY){
            self.blueToothBtn.center=self.mainBtn.center;
            [UIView animateWithDuration:animationDuration animations:^{
                self.mainBtn.transform=CGAffineTransformMakeRotation(0);
            }];
            showState=MAINBTNSHOWONLY;
    }else if (showState==WIFIBTNSHOWONLY){
            self.wifiBtn.center=self.mainBtn.center;
            [UIView animateWithDuration:animationDuration animations:^{
                self.mainBtn.transform=CGAffineTransformMakeRotation(0);
            }];
            showState=MAINBTNSHOWONLY;
    }
}
- (void)unfoldBtnWithBtnY:(CGFloat)btnY andBtnX:(CGFloat)BtnX inView:(UIButton *)btn{
    CAAnimationGroup *group=[CAAnimationGroup animation];
    group.duration=animationDuration;
    //平移动画
    CAKeyframeAnimation *positionAni=[CAKeyframeAnimation animation];
    positionAni.keyPath=@"position";
    NSValue *value0=[NSValue valueWithCGPoint:self.mainBtn.center];
    NSValue *value1=[NSValue valueWithCGPoint:CGPointMake(BtnX*0.5, btnY)];
    NSValue *value2=[NSValue valueWithCGPoint:CGPointMake(BtnX*1.4, btnY)];
    NSValue *value3=[NSValue valueWithCGPoint:CGPointMake(BtnX, btnY)];
    positionAni.values=@[value0,value1,value2,value3];
    //旋转动画
    CAKeyframeAnimation *rotateAni=[CAKeyframeAnimation animation];
    rotateAni.keyPath=@"transform.rotation";
    rotateAni.values=@[@0,@(M_PI*2),@(M_PI*4),@(M_PI_2*2)];
    
    group.animations=@[positionAni,rotateAni];
    [btn.layer addAnimation:group forKey:nil];
    btn.center=CGPointMake(BtnX, btnY);
}

- (void)foldBtnWithBtnY:(CGFloat)btnY andBtnX:(CGFloat)BtnX inView:(UIButton *)btn{
    CAAnimationGroup *group=[CAAnimationGroup animation];
    group.duration=animationDuration;
    //平移动画
    CAKeyframeAnimation *positionAni=[CAKeyframeAnimation animation];
    positionAni.keyPath=@"position";
    NSValue *value0=[NSValue valueWithCGPoint:self.mainBtn.center];
    NSValue *value1=[NSValue valueWithCGPoint:CGPointMake(BtnX*0.5, btnY)];
    NSValue *value2=[NSValue valueWithCGPoint:CGPointMake(BtnX*1.4, btnY)];
    NSValue *value3=[NSValue valueWithCGPoint:CGPointMake(BtnX, btnY)];
    positionAni.values=@[value3,value2,value1,value0];
    //旋转动画
    CAKeyframeAnimation *rotateAni=[CAKeyframeAnimation animation];
    rotateAni.keyPath=@"transform.rotation";
//    rotateAni.values=@[@0,@(M_PI*2),@(M_PI*4),@(M_PI_2*2)];
    rotateAni.values=@[@(M_PI_2*2),@(M_PI*4),@(M_PI*2),@0];
    
    group.animations=@[positionAni,rotateAni];
    [btn.layer addAnimation:group forKey:nil];
    btn.center=self.mainBtn.center;
}

-(void)touchBlueToothBtn{
    NSLog(@"%s",__func__);
    if (showState==ALLSHOW) {
        //设置蓝牙按钮坐标
        CGFloat blueToothBtnX=toolBarframe.size.width*0.35;
        CGFloat btnY=self.mainBtn.center.y;
        [self foldBtnWithBtnY:btnY andBtnX:blueToothBtnX inView:self.wifiBtn];
        //改变展示状态
        showState=BLUETOOTHBTNSHOWONLY;
    }
}
-(void)touchWifiBtn{
    NSLog(@"%s",__func__);
    if (showState==ALLSHOW) {
        CGFloat btnY=self.mainBtn.center.y;
        CGFloat wifiBtnX=toolBarframe.size.width*0.65;
        [self foldBtnWithBtnY:btnY andBtnX:wifiBtnX inView:self.blueToothBtn];
        //改变展示状态
        showState=WIFIBTNSHOWONLY;
    }
}

@end
