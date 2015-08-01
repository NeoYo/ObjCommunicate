//
//  ViewController.m
//  UI
//
//  Created by WeixiYu on 15/7/14.
//  Copyright (c) 2015年 liveabean. All rights reserved.
//

#import "ViewController.h"
#import "SocketViewController.h"

#define host @"192.168.1.102"
#define port 5000

@interface ViewController ()<NSStreamDelegate>{
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
}

@property (weak, nonatomic) IBOutlet UITextField *studentID;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
- (IBAction)logIn:(id)sender;
- (IBAction)hideKyboard:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self showLogInfobefore];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logIn:(id)sender {
    NSString *logInfo=[NSString stringWithFormat:@"%@",self.studentID.text];
    NSString *docDir=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *logInfoFile=[docDir stringByAppendingPathComponent:@"logInfo.csv"];
    //不存在就创建文件，存在但是logInfo<logInfoBefore (else if)也要创建文件
    if (![[NSFileManager defaultManager]fileExistsAtPath:logInfoFile]) {
        [[NSFileManager defaultManager]createFileAtPath:logInfoFile contents:nil attributes:nil];
    }else if([logInfo length]<[[self logInfoBefore]length] ){
        [[NSFileManager defaultManager]createFileAtPath:logInfoFile contents:nil attributes:nil];
    }

    NSFileHandle *fileHandleWrite=[NSFileHandle fileHandleForUpdatingAtPath:logInfoFile];
    [fileHandleWrite writeData:[logInfo dataUsingEncoding:NSUTF8StringEncoding]];
    [fileHandleWrite closeFile];
    //测试
    //[self chaxun];
    
    
    //手工启动切换,用户输完密码后想直接登录，优化用户体验
    [self performSegueWithIdentifier:@"toMainView" sender:nil];
    
}



- (IBAction)hideKyboard:(id)sender {
    [self.studentID resignFirstResponder];
    [self.passWord resignFirstResponder];
}

-(void)showLogInfobefore{
    NSString *logInfoBefore=[self logInfoBefore];
    if (logInfoBefore) {
        self.studentID.text=logInfoBefore;
    }
}
-(NSString *)logInfoBefore{
    //Document path
    NSString *docDir=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    //Document Path+logInfo.csv
    NSString *logInfoFile=[docDir stringByAppendingPathComponent:@"logInfo.csv"];
    if ([[NSFileManager defaultManager]fileExistsAtPath:logInfoFile]) {
        NSFileHandle *fileHandleRead=[NSFileHandle fileHandleForReadingAtPath:logInfoFile];
        NSString *logInfoBefore= [[NSString alloc]initWithData:[fileHandleRead availableData] encoding:NSUTF8StringEncoding];
        [fileHandleRead closeFile];
        return logInfoBefore;
    }else{
        return nil;
    }
}
#pragma mark TcpAsyncSocket



#pragma mark TCP Socket C语言
//测试Tcp通信
-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{
    NSLog(@"%@",aStream);
    //    NSStreamEventOpenCompleted = 1UL << 0,
    //    NSStreamEventHasBytesAvailable = 1UL << 1,
    //    NSStreamEventHasSpaceAvailable = 1UL << 2,
    //    NSStreamEventErrorOccurred = 1UL << 3,
    //    NSStreamEventEndEncountered = 1UL << 4
    switch (eventCode) {
        case NSStreamEventOpenCompleted://数据流打开完成
            NSLog(@"数据流打开完成");
            break;
        case NSStreamEventHasBytesAvailable://有可读字节
            NSLog(@"有可读字节");
            [self readBytes];
            break;
        case NSStreamEventHasSpaceAvailable:// 可发送字节
            NSLog(@"可发送字节");
            break;
        case NSStreamEventErrorOccurred://连接错误
            NSLog(@"连接错误");
            break;
            //        case NSStreamEventEndEncountered:
            //            NSLog(@"到达流末尾，可以点击关闭流或者继续输出");
            //            //[outputStream close];
            //            break;
        case NSStreamEventEndEncountered://到达流未尾，要关闭输入输出流
            NSLog(@"到达流未尾，关闭输入输出流");
            [outputStream close];
            [inputStream close];
            [outputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
            [inputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
            break;
            
        default:
            break;
    }
}

//连接服务器
-(void)connect{
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL,(__bridge CFStringRef) host, port, &readStream, &writeStream);
    
    inputStream = (__bridge NSInputStream *)(readStream);
    outputStream = (__bridge NSOutputStream *)(writeStream);
    
    inputStream.delegate = self;
    outputStream.delegate = self;
    
//    [inputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
//    [outputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [outputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [inputStream open];
    [outputStream open];
}

-(void)closeSocket{
    [outputStream close];
    [inputStream close];
    [outputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    NSLog(@"已经关闭好了输入输出流");
}

- (void)login{
    //登录时和连接一起绑定
    [self connect];
    NSString *str = @"login:2012160063:273535";
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [outputStream write:data.bytes maxLength:data.length];
    //Test
    NSLog(@"here");
}

-(void)readBytes{
    uint8_t buffer[1012];
    NSInteger len = [inputStream read:buffer maxLength:sizeof(buffer)];
    
    NSData *data = [NSData dataWithBytes:buffer length:len];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",str);
}

- (void)chaxun{
    /*
     注意：需要用不同的变量
     */
    [self connect];
    NSString *str2 = @"chaxun:2012160063:2015/7/16:2015/7/19";
    NSData *data2 = [str2 dataUsingEncoding:NSUTF8StringEncoding];
    [outputStream write:data2.bytes maxLength:data2.length];
}

@end
