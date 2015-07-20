//
//  SocketViewController.m
//  UI
//
//  Created by WeixiYu on 15/7/20.
//  Copyright (c) 2015年 liveabean. All rights reserved.
//

#import "SocketViewController.h"

#define host @"192.168.1.102"
#define port 5000
@interface SocketViewController ()<NSStreamDelegate>{
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
}


@end

@implementation SocketViewController

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
    
    [inputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
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
}

-(void)readBytes{
    uint8_t buffer[1012];
    NSInteger len = [inputStream read:buffer maxLength:sizeof(buffer)];
    
    NSData *data = [NSData dataWithBytes:buffer length:len];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",str);
}
- (void)passWord{
    /*
     注意：需要用不同的变量
     */
    [self connect];
    NSString *str2 = @"chaxun:2012160063:2015/7/16:2015/7/19";
    NSData *data2 = [str2 dataUsingEncoding:NSUTF8StringEncoding];
    [outputStream write:data2.bytes maxLength:data2.length];
}
@end
