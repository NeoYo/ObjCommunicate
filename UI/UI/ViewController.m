//
//  ViewController.m
//  UI
//
//  Created by WeixiYu on 15/7/14.
//  Copyright (c) 2015年 liveabean. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
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
    //手工启动切换,用户输完密码后想直接登录，优化用户体验
    [self performSegueWithIdentifier:@"toMainView" sender:self];
    
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
@end
