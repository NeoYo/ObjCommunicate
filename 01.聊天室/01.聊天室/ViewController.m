//
//  ViewController.m
//  01.聊天室
//
//  Created by Yong Feng Guo on 14-11-22.
//  Copyright (c) 2014年 Fung. All rights reserved.
//

#import "ViewController.h"
#define host @"192.168.1.102"
#define port 5000
@interface ViewController ()<NSStreamDelegate>{
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
}
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *place;
@property (weak, nonatomic) IBOutlet UILabel *money;
- (IBAction)Test:(id)sender;

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
- (IBAction)login:(id)sender {
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
    NSArray *array = [str componentsSeparatedByString:@"-"];
    NSString *strType=array[0];
    if ([strType isEqualToString:@"cha"]) {
        [self show:str];
    }
    //[self closeSocket];
}
-(void)show:(NSString *)str{
    NSArray *array = [str componentsSeparatedByString:@"-"];
    if(array!=nil){
        for (int i=0; i<array.count; i++) {
            if (i==1) {
                self.time.text=array[1];
            }
            if (i==3) {
                self.place.text=[NSString stringWithFormat:@"%@元",array[3]];
            }
            if (i==4) {
                self.money.text=array[4];
            }
        }
    }
}
- (IBAction)Test:(id)sender {
    NSString *str=@"2015/7/16-20:36:28-8-shiyan";
    NSArray *array = [str componentsSeparatedByString:@"-"];
//    for (int i=0; i<[array count]; i++) {
//        NSLog(@"array[%d]:%@",i,array[i]);
//        NSString *str1=array[0];
//        NSLog(@"str1:%@",str1);
//        self.time.text=array[i];
//    }
    self.time.text=array[1];
    self.place.text=[NSString stringWithFormat:@"%@元",array[2]];;
    self.money.text=array[3];
    
}
- (IBAction)closeSocket:(id)sender {
    [self closeSocket];
}
- (IBAction)passWord:(id)sender {
    /*
     注意：需要用不同的变量
     */
    [self connect];
    NSString *str2 = @"chaxun:2012160063:2015/7/16";
    NSData *data2 = [str2 dataUsingEncoding:NSUTF8StringEncoding];
    [outputStream write:data2.bytes maxLength:data2.length];
}
- (IBAction)connect:(id)sender {
    //连接服务器
    [self connect];
}
@end
