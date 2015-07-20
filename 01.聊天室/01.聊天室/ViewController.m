//
//  ViewController.m
//  01.聊天室
//
//  Created by Yong Feng Guo on 14-11-22.
//  Copyright (c) 2014年 Fung. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *place;
@property (weak, nonatomic) IBOutlet UILabel *money;

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


- (IBAction)login:(id)sender {

}

