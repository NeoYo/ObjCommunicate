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
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self setupContext];
    [self addRecord];
}
-(void)setupContext{
    NSManagedObjectContext *context=[[NSManagedObjectContext alloc]init];
    NSManagedObjectModel *model=[NSManagedObjectModel mergedModelFromBundles:nil];
    NSPersistentStoreCoordinator *store=[[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
    NSError *error=nil;
    NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSLog(@"%@",doc);
    NSString *sqlitePath=[doc stringByAppendingString:@"/record.db"];
    NSLog(@"%@",sqlitePath);
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:sqlitePath] options:nil error:&error];
    context.persistentStoreCoordinator=store;
    self.context=context;
}
-(void)addRecord{
    for (int i=0; i<10; i++) {
        Record *record=[NSEntityDescription insertNewObjectForEntityForName:@"Record" inManagedObjectContext:self.context];
        
        record.time=@"9";
        record.date=[NSString stringWithFormat:@"%@",[NSDate date]];
        record.location=@"szu";
        record.money=[NSString stringWithFormat:@"10%d",i];
        NSError *error=nil;
        [self.context save:&error];
        if (!error) {
            NSLog(@"success");
        }else{
            NSLog(@"%@",error);
        }
    }
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
