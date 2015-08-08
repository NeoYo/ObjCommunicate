//
//  TestDataViewController.m
//  UI
//
//  Created by WeixiYu on 15/7/30.
//  Copyright (c) 2015年 liveabean. All rights reserved.
//

#import "TestDataViewController.h"
#import <CoreData/CoreData.h>
#import "Record.h"
@interface TestDataViewController ()
@property (strong,nonatomic)NSManagedObjectContext *context;
@end

@implementation TestDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// 08:36:11  12:53:28   20:45:33   09:55:43   13:23:34   15:21:46    16:32:34    19:32:22   11:14:56
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self setupContext];
//    [self searchWithSendStr:@"chaxun:2012160063:2015/6/20:2015/7/10:1"];
    [self testAdd];

}

-(void)setupContext{
    NSManagedObjectContext *context=[[NSManagedObjectContext alloc]init];
    NSManagedObjectModel *model=[NSManagedObjectModel mergedModelFromBundles:nil];
    NSPersistentStoreCoordinator *store=[[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
    NSError *error=nil;
    NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSLog(@"%@",doc);
    NSString *sqlitePath=[doc stringByAppendingString:@"/record.db"];
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:sqlitePath] options:nil error:&error];
    context.persistentStoreCoordinator=store;
    self.context=context;
}

-(void)deleteAllRecords{
    
}


//sendStr----chaxun:2012160063:2015/6/20:2015/7/10:1
-(void)searchWithSendStr:(NSString *)sendStr{
    NSArray *arr=[sendStr componentsSeparatedByString:@":"];
    NSArray *dateMin=[arr[2] componentsSeparatedByString:@"/"];
    NSArray *dateMax=[arr[3] componentsSeparatedByString:@"/"];
    
    NSNumber *minMonth=[NSNumber numberWithInt:[dateMin[1] intValue]];
    NSNumber *minDay=[NSNumber numberWithInt:[dateMin[2] intValue]];
    NSNumber *maxMonth=[NSNumber numberWithInt:[dateMax[1] intValue]];
    NSNumber *maxDay=[NSNumber numberWithInt:[dateMax[2] intValue]];
    // 查询
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Record"];

    NSPredicate *pre = [NSPredicate predicateWithFormat:@"(month=%@ AND day>=%@) OR(month=%@  AND day<=%@) OR(month>%@ AND month<%@)",minMonth,minDay,maxMonth,maxDay,minMonth,maxMonth];//举列：1/12 —7/11   1/12-1/30   2    3    4     5    6    7/1-7/11
    request.predicate = pre;
    
    //读取信息
    NSError *error = nil;
    NSArray *records = [self.context executeFetchRequest:request error:&error];
    if (!error) {
//        NSLog(@"record: %@",records);
        for (Record *record in records) {
            NSLog(@"%@ %@ %@ %@",record.time,record.date,record.location,record.money);
        }
    }else{
        NSLog(@"%@",error);
    }
}



-(void)addRecordWithReceiveStr:(NSString *)receiveStr{
        //删除接收信息的最后一个“|” ，删除只有NSMutableString有 切割只有NSString有
    NSMutableString *mutRece=[NSMutableString stringWithString:receiveStr];
    [mutRece deleteCharactersInRange:NSMakeRange([mutRece length]-1, 1)];
        //NSLog(@"%@",mutRece);
    receiveStr=[NSString stringWithFormat:@"%@",mutRece];
    
    NSArray *receiveArrs=[receiveStr componentsSeparatedByString:NSLocalizedString(@"|", nil)];
    NSLog(@"%@",receiveArrs[0]);
    
    for (int i=0; i<receiveArrs.count; i++) {
        NSArray *receiveArr=[receiveArrs[i] componentsSeparatedByString:NSLocalizedString(@"-", nil)];
        //NSLog(@"%@",receiveArr);
        Record *record=[NSEntityDescription insertNewObjectForEntityForName:@"Record" inManagedObjectContext:self.context];
        record.date=receiveArr[1];
        record.time=receiveArr[2];
        record.money=receiveArr[3];
        record.location=receiveArr[4];
        
//        2015/7/16
        NSArray *date=[record.date componentsSeparatedByString:NSLocalizedString(@"/", nil)];
        record.month=[NSNumber numberWithInt:[date[1] intValue]];
        record.day=[NSNumber numberWithInt:[date[2]intValue]];
        
        NSError *error=nil;
        [self.context save:&error];
        if (!error) {
            NSLog(@"success");
        }else{
            NSLog(@"%@",error);
        }
    }
}



-(void)testAdd{
    [self addRecordWithReceiveStr:@"cha-2015/1/1-12:3:28-18-3|cha-2015/1/2-08:36:11-7-5|cha-2015/1/7-12:53:28-53-2|cha-2015/1/9-20:45:33-23-5|cha-2015/2/9-20:45:33-66-3|cha-2015/2/13-12:53:28-20-7|cha-2015/2/17-08:36:11-20-8|cha-2015/2/23-09:55:43-23-9|cha-2015/2/26-12:53:28-34-3|cha-2015/3/1-20:36:28-45-2|cha-2015/3/2-13:23:34-66-2|cha-2015/3/4-08:36:11-7-2|cha-2015/3/5-20:45:33-65-2|cha-2015/3/7-12:53:28-8-2|cha-2015/3/8-15:21:46-7-4|cha-2015/3/9-13:23:34-8.7-5|cha-2015/3/10-19:32:22-6.7-6|cha-2015/3/11-12:53:28-5.6-7|cha-2015/3/13-08:36:11-65-8|cha-2015/3/15-09:55:43-6.6-10|cha-2015/3/17-13:23:34-34.5-3|cha-2015/3/55-12:53:28-45-5|cha-2015/3/19-15:21:46-65-4|cha-2015/3/20-20:36:28-76-2|cha-2015/3/21-20:45:33-43-9|cha-2015/3/22-08:36:11-41-9|cha-2015/3/23-19:32:22-34-1|cha-2015/3/24-12:53:28-54-3|cha-2015/3/25-09:55:43-67-2|cha-2015/4/1-13:23:34-5.6-5|cha-2015/4/2-20:36:28-3.5-6|cha-2015/4/3-09:55:43-4.55-8|cha-2015/4/4-15:21:46-5-2|cha-2015/4/5-12:53:28-3.8-3|cha-2015/4/6-08:36:11-8.9-4|cha-2015/4/7-20:45:33-66-5|cha-2015/4/8-13:23:34-34-6|cha-2015/4/9-09:55:43-23-7|cha-2015/4/10-20:36:28-58-8|cha-2015/4/11-19:32:22-12-9|cha-2015/4/12-12:53:28-11.6-10|cha-2015/4/13-08:36:11-23-1|cha-2015/4/14-20:45:33-5-2|cha-2015/4/15-09:55:43-34-4|cha-2015/4/16-13:23:34-3.5-3|cha-2015/4/16-20:36:28-4.6-5|cha-2015/4/17-09:55:43-3.2-6|cha-2015/4/17-12:53:28-4.5-7|cha-2015/4/19-08:36:11-4.2-8|cha-2015/4/20-19:32:22-8.7-9|cha-2015/4/21-20:45:33-4.7-10|cha-2015/4/22-13:23:34-12.3-5|cha-2015/4/23-09:55:43-45.3-1|cha-2015/4/24-20:36:28-23.8-6|cha-2015/5/2-12:53:28-34-7|cha-2015/5/5-08:36:11-42-8|cha-2015/5/12-15:21:46-23-9|cha-2015/5/15-20:45:33-35-10|cha-2015/5/2.8-09:55:43-32-6|cha-2015/5/20-08:36:11-22-8|cha-2015/5/22-13:23:34-12.3-9|cha-2015/5/24-20:45:33-12.5-4|cha-2015/5/26-09:55:43-12.3-5|cha-2015/6/5-20:36:28-43.1-6|cha-2015/6/8-12:53:28-32.2-7|cha-2015/6/12-08:36:11-34.3-8|cha-2015/6/16-09:55:43-32.2-9|cha-2015/6/20-20:45:33-33.6-10|cha-2015/6/22-13:23:34-23.3-5|cha-2015/7/1-08:36:11-2.4-2|cha-2015/7/2-20:36:28-5.5-3|cha-2015/7/2-12:53:28-6.6-4|cha-2015/7/9-20:45:33-8.6-5|cha-2015/7/11-11:14:56-6.1-5|cha-2015/7/13-09:55:43-23.3-6|cha-2015/7/15-15:21:46-12-7|cha-2015/7/16-08:36:11-8.8-8|cha-2015/7/17-12:53:28-6.7-9|cha-2015/7/25-11:14:56-22.3-10|"];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
