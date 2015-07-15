//
//  ViewController.m
//  01.聊天室
//
//  Created by Yong Feng Guo on 14-11-22.
//  Copyright (c) 2014年 Fung. All rights reserved.
//

#import "ViewController.h"
#define host @"192.168.1.109"
#define port 4057
@interface ViewController ()<NSStreamDelegate>{
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}


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
        case NSStreamEventEndEncountered:
            NSLog(@"到达流末尾，可以点击关闭流或者继续输出");
            //[outputStream close];
            break;
        /*case NSStreamEventEndEncountered://到达流未尾，要关闭输入输出流
            NSLog(@"到达流未尾，要关闭输入输出流");
            [outputStream close];
            [inputStream close];
            [outputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
            [inputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
            break;
       */
        default:
            break;
    }
}
- (IBAction)connect:(id)sender {
    //连接服务器
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL,(__bridge CFStringRef) host, port, &readStream, &writeStream);
    
    
    inputStream = (__bridge NSInputStream *)(readStream);
    outputStream = (__bridge NSOutputStream *)(writeStream);
    
    
    inputStream.delegate = self;
    outputStream.delegate = self;
    
    [inputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    [inputStream open];
    [outputStream open];
}
- (IBAction)login:(id)sender {
    
    NSString *str = @"login:2012160063:273535";
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [outputStream write:data.bytes maxLength:data.length];
}
- (IBAction)closeSocket:(id)sender {
    [outputStream close];
    [inputStream close];
    [outputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
     NSLog(@"已经关闭好了输入输出流");
}
- (IBAction)passWord:(id)sender {
    /*
     注意：需要用不同的变量
    NSString *str2 = @"273535";
    NSData *data2 = [str2 dataUsingEncoding:NSUTF8StringEncoding];
    [outputStream write:data2.bytes maxLength:data2.length];
     */
}




-(void)readBytes{
    uint8_t buffer[1012];
    NSInteger len = [inputStream read:buffer maxLength:sizeof(buffer)];
    
    NSData *data = [NSData dataWithBytes:buffer length:len];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",str);
    
}
@end
