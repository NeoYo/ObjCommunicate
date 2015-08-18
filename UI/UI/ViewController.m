//
//  ViewController.m
//  UI
//
//  Created by WeixiYu on 15/7/14.
//  Copyright (c) 2015年 liveabean. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"
#import "MBProgressHUD+CZ.h"

#define rememberPwdKey @"rememberPwd"//记录密码
#define autoLoginKey @"autoLogin"//自动登录
#define studentIdKey @"studentId"//帐号
#define passwordKey @"password"


@interface ViewController ()<NSStreamDelegate,GCDAsyncSocketDelegate>{
//    NSInputStream *inputStream;
//    NSOutputStream *outputStream;
    GCDAsyncSocket *socket;//GCDAsyncSocket是封装好了的可以指定GCD,不用自己去实现
}

@property (weak, nonatomic) IBOutlet UITextField *studentID;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
- (IBAction)logIn:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *rememberPwdSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *autoLoginSwitch;
@property (weak, nonatomic) IBOutlet UIButton *logInbtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 设置 “开关” 默认值
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.rememberPwdSwitch.on = [defaults boolForKey:rememberPwdKey];
    self.autoLoginSwitch.on = [defaults boolForKey:autoLoginKey];
    
    // 设置 帐号 和 密码 默认值
    self.studentID.text = [defaults objectForKey:studentIdKey];
    if (self.rememberPwdSwitch.isOn) {
        self.passWord.text = [defaults objectForKey:passwordKey];
    }
    
    //调用 文本变化 的方法
    [self textChange];
    
    // 如果 "自动登录" 勾选，让自动登录
    if (self.autoLoginSwitch.isOn) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self logIn:nil];
        });
    }
    
}
- (IBAction)nextTopasswordField:(id)sender {
    [self.studentID endEditing:YES];
    [self.passWord becomeFirstResponder];
}
//监听文本输入框变化
-(IBAction)textChange{
    self.logInbtn.enabled = (self.studentID.text.length != 0 && self.passWord.text.length != 0);
    //没有值，禁用登录按钮
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logIn:(id)sender {
//    测试
//    [self logIn];
    
    
    [MBProgressHUD showMessage:@"拼命登录中..."];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
        if (/* DISABLES CODE */ (1)) {
            //保存用户帐和密码
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:self.studentID.text forKey:studentIdKey];
            //只有 "记住密码" 为开启的状态，才要保存
            if (self.rememberPwdSwitch.isOn) {
                [defaults setObject:self.passWord.text forKey:passwordKey];
            }
            [defaults synchronize];
            //密码正确而且存储完信息将进入主界面
            [self performSegueWithIdentifier:@"toMainView" sender:nil];
        } else {
            [MBProgressHUD showError:@"学号或密码错误"];
        }
    });
}

/**
 *  记录密码开关的值变化
 */
- (IBAction)rememberPwdSwitchChange {
    //如果记住密码 为 关闭状态，并且 自动登录为 开启的状态，此时，自动登录 应改为关闭
    if(self.rememberPwdSwitch.isOn == NO && self.autoLoginSwitch.isOn == YES){
        //self.autoLoginSwitch.on = NO;
        
        //添加动画
        [self.autoLoginSwitch setOn:NO animated:YES];
    }
    //保存开关数据
    [self saveSwitchToPreference];
}

/**
 *  自动登录开关的值变化
 */
- (IBAction)autoLoginSwitchChange {
    
    //如果 自动登录  为 开启状态 并且 记住密码为 关闭状态，些时，记住密码应改为开启
    if(self.autoLoginSwitch.isOn == YES  && self.rememberPwdSwitch.isOn == NO){
        [self.rememberPwdSwitch setOn:YES animated:YES];
    }
    
    [self saveSwitchToPreference];
}

/**
 *  保存开关数据 到 用户偏好设置
 */
-(void)saveSwitchToPreference{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.rememberPwdSwitch.isOn forKey:rememberPwdKey];
    [defaults setBool:self.autoLoginSwitch.isOn forKey:autoLoginKey];
    [defaults synchronize];
}

//隐藏键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}




#pragma mark -GCDAsyncSocket
-(void)connect{
    //创建socket
    socket=[[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        NSError *error=nil;
    
 
    [socket connectToHost:@"172.31.101.139" onPort:5000 error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    
}
#pragma mark-GCDAsyncSocketDelegate
//连接成功
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    NSLog(@"%s",__func__);
}
//断开连接
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    if (err) {
        NSLog(@"连接失败");
    } else {
        NSLog(@"正常断开");
    }
}
//发送成功
-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    NSLog(@"%s",__func__);
    //发送成功要有下面这行代码才会调用代理方法 didReadData tag设置发送对应的返回
    [socket readDataWithTimeout:-1 tag:tag];
}
//读取数据
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
//    NSLog(@"%@",[NSThread currentThread]);
    
    NSString *receiveStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (tag==100) {
        NSLog(@"login:%s_______%@",__func__,receiveStr);
    } else if(tag==101){
        NSLog(@"chaxun:%s____%@",__func__,receiveStr);
    }
}
-(void)logIn{
    [self connect];
    NSString *loginStr= @"login:2012160063:123456";
    NSData *data=[loginStr dataUsingEncoding:NSUTF8StringEncoding];
    [socket writeData:data withTimeout:-1 tag:100];
}
- (void)chaxun{
    /*
     注意：需要用不同的变量?
     */
    [self connect];
    NSString *searchStr= @"chaxun:2012160063:2015/7/16:2015/7/19";
    NSData *data2 = [searchStr dataUsingEncoding:NSUTF8StringEncoding];
    [socket writeData:data2 withTimeout:-1 tag:101];
}

#pragma mark TCP Socket 基于CFStream
////测试Tcp通信
//-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{
//    NSLog(@"%@",aStream);
//    //    NSStreamEventOpenCompleted = 1UL << 0,
//    //    NSStreamEventHasBytesAvailable = 1UL << 1,
//    //    NSStreamEventHasSpaceAvailable = 1UL << 2,
//    //    NSStreamEventErrorOccurred = 1UL << 3,
//    //    NSStreamEventEndEncountered = 1UL << 4
//    switch (eventCode) {
//        case NSStreamEventOpenCompleted://数据流打开完成
//            NSLog(@"数据流打开完成");
//            break;
//        case NSStreamEventHasBytesAvailable://有可读字节
//            NSLog(@"有可读字节");
//            [self readBytes];
//            break;
//        case NSStreamEventHasSpaceAvailable:// 可发送字节
//            NSLog(@"可发送字节");
//            break;
//        case NSStreamEventErrorOccurred://连接错误
//            NSLog(@"连接错误");
//            break;
//            //        case NSStreamEventEndEncountered:
//            //            NSLog(@"到达流末尾，可以点击关闭流或者继续输出");
//            //            //[outputStream close];
//            //            break;
//        case NSStreamEventEndEncountered://到达流未尾，要关闭输入输出流
//            NSLog(@"到达流未尾，关闭输入输出流");
//            [outputStream close];
//            [inputStream close];
//            [outputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
//            [inputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
//            break;
//            
//        default:
//            break;
//    }
//}
//
////连接服务器
//-(void)connect{
//    CFReadStreamRef readStream;
//    CFWriteStreamRef writeStream;
//    CFStreamCreatePairWithSocketToHost(NULL,(__bridge CFStringRef) host, port, &readStream, &writeStream);
//    
//    inputStream = (__bridge NSInputStream *)(readStream);
//    outputStream = (__bridge NSOutputStream *)(writeStream);
//    
//    inputStream.delegate = self;
//    outputStream.delegate = self;
//    
////    [inputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
////    [outputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
//    [inputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
//    [outputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
//    [inputStream open];
//    [outputStream open];
//}
//
//-(void)closeSocket{
//    [outputStream close];
//    [inputStream close];
//    [outputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
//    [inputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
//    NSLog(@"已经关闭好了输入输出流");
//}
//
//- (void)login{
//    //登录时和连接一起绑定
//    [self connect];
//    NSString *str = @"login:2012160063:273535";
//    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
//    [outputStream write:data.bytes maxLength:data.length];
//    //Test
//    NSLog(@"here");
//}
//
//-(void)readBytes{
//    uint8_t buffer[1012];
//    NSInteger len = [inputStream read:buffer maxLength:sizeof(buffer)];
//    
//    NSData *data = [NSData dataWithBytes:buffer length:len];
//    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    
//    NSLog(@"%@",str);
//}
//
//- (void)chaxun{
//    /*
//     注意：需要用不同的变量
//     */
//    [self connect];
//    NSString *str2 = @"chaxun:2012160063:2015/7/16:2015/7/19";
//    NSData *data2 = [str2 dataUsingEncoding:NSUTF8StringEncoding];
//    [outputStream write:data2.bytes maxLength:data2.length];
//}

@end
