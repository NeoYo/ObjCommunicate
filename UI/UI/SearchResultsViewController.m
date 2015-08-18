//
//  SearchResultsViewController.m
//  UI
//
//  Created by WeixiYu on 15/7/15.
//  Copyright (c) 2015年 liveabean. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "RecordCell.h"
#import "Record.h"
#import "MonthRecords.h"
#import <CoreData/CoreData.h>

@interface SearchResultsViewController ()<UITableViewDataSource,UITableViewDelegate>{

}
@property (weak, nonatomic) IBOutlet UITableView *tableVIew;
@property (strong,nonatomic) NSManagedObjectContext *context;
@property (strong,nonatomic) NSMutableArray *Sections;
@end

@implementation SearchResultsViewController
-(NSArray *)Sections{
    if (!_Sections) {
        _Sections=[NSMutableArray array];
    }
    return _Sections;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //设置行高
    self.tableVIew.rowHeight=50;
    [self setupContext];
    [self searchWithSendStr:self.sendStr];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 数据库
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
//chaxun:2012160063:2015/1/1:2015/8/2:1
-(void)searchWithSendStr:(NSString *)sendStr{
    NSArray *arr=[sendStr componentsSeparatedByString:@":"];
    NSArray *dateMin=[arr[2] componentsSeparatedByString:@"/"];
    NSArray *dateMax=[arr[3] componentsSeparatedByString:@"/"];
    int canteen=[arr[4] intValue];
    
    NSNumber *minMonth=[NSNumber numberWithInt:[dateMin[1] intValue]];
    NSNumber *minDay=[NSNumber numberWithInt:[dateMin[2] intValue]];
    NSNumber *maxMonth=[NSNumber numberWithInt:[dateMax[1] intValue]];
    NSNumber *maxDay=[NSNumber numberWithInt:[dateMax[2] intValue]];
    int maxIntMonth=[maxMonth intValue];
    int minIntMonth=[minMonth intValue];
    int SectionsCount=maxIntMonth-minIntMonth+1;
    NSLog(@"sectiongsCOunt;......%d",SectionsCount);
    //SectionsCount 客户想要多少个月的消费记录
    
    
    //遍历 每一个月的消费记录
    for (int i=0; i<SectionsCount; i++) {
        // 查询
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Record"];
        //       NSPredicate *pre = [NSPredicate predicateWithFormat:@"(month=%@ AND day>=%@) OR(month=%@  AND day<=%@) OR(month>%@ AND month<%@)",minMonth,minDay,maxMonth,maxDay,minMonth,maxMonth];
        NSNumber *month= [NSNumber numberWithInt:minIntMonth+i];
        //生成自定义月消费记录的对象
        MonthRecords *monthRecords=[MonthRecords monthRecordsWithTitle:[NSString stringWithFormat:@"%@",month]];
        NSPredicate *pre;
        if (canteen==0) {
            if (i==0) {
                pre = [NSPredicate predicateWithFormat:@"month=%@ AND day>=%@",month,minDay];
            }else if(i==SectionsCount-1){
                pre = [NSPredicate predicateWithFormat:@"month=%@  AND day<=%@",month,maxDay];
            }else{
                pre = [NSPredicate predicateWithFormat:@"month=%@",month];
            }
        }else {
            if (i==0) {
                pre = [NSPredicate predicateWithFormat:@"month=%@ AND day>=%@ AND location=%@",month,minDay,arr[4]];
            }else if(i==SectionsCount-1){
                pre = [NSPredicate predicateWithFormat:@"month=%@  AND day<=%@ AND location=%@",month,maxDay,arr[4]];
            }else{
                pre = [NSPredicate predicateWithFormat:@"month=%@ AND location=%@",month,arr[4]];
            }
        }
        request.predicate = pre;
        //读取信息
        NSError *error = nil;
        NSArray *records = [self.context executeFetchRequest:request error:&error];
        if (!error) {
            monthRecords.records=records;
            NSLog(@"%@月",monthRecords.title);
            for (Record *record in monthRecords.records) {
                NSLog(@"%@ %@ %@ %@",record.time,record.date,record.location,record.money);
            }
        }else{
            NSLog(@"%@",error);
        }
        [self.Sections addObject:monthRecords];
    }
}





#pragma mark 设置TableView
//Sections
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.Sections.count;
}
//Sections' rows
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    MonthRecords *monthRecords=self.Sections[section];
    return monthRecords.records.count;
}
//TableViewCell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RecordCell *cell=[RecordCell recordCellWithTableView:tableView];
    //section 0
    if (indexPath.section==0) {
//        cell.location.image=[UIImage imageNamed:@"canteen.jpg"];
    //section 1
    } else if(indexPath.section==1) {
    }
    //section2
    else {
    }
    
    MonthRecords *monthRecords=self.Sections[indexPath.section];//获得第几个月
    Record *record=monthRecords.records[indexPath.row];//这个月的第几个记录
    [cell setRecordCell:record];
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}


//分组头标题
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    MonthRecords *monthRecords=self.Sections[section];
    return [NSString stringWithFormat:@"%@月",monthRecords.title];
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSMutableArray *arr=[NSMutableArray array];
    for (int i=0; i<self.Sections.count; i++) {
        MonthRecords *records=self.Sections[i];
        [arr addObject:[NSString stringWithFormat:@"%@月",records.title]];
    }
    return [arr copy];
}


#pragma mark 对导航栏的定制
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;
    [self hideTabBar];
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden=YES;
    [self showTabBar];
}
- (void)showTabBar
{
    if (self.tabBarController.tabBar.hidden == NO)
    {
        return;
    }
    UIView *contentView;
    if ([[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]])
        
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    
    else
        
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
    contentView.frame = CGRectMake(contentView.bounds.origin.x, contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height - self.tabBarController.tabBar.frame.size.height);
    self.tabBarController.tabBar.hidden = NO;
    
}
- (void)hideTabBar {
    if (self.tabBarController.tabBar.hidden == YES) {
        return;
    }
    UIView *contentView;
    if ( [[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    else
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
    contentView.frame = CGRectMake(contentView.bounds.origin.x,  contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height + self.tabBarController.tabBar.frame.size.height);
    self.tabBarController.tabBar.hidden = YES;
    
}


@end
