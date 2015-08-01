//
//  SearchResultsViewController.m
//  UI
//
//  Created by WeixiYu on 15/7/15.
//  Copyright (c) 2015年 liveabean. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "RecordCell.h"

@interface SearchResultsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableVIew;

@end

@implementation SearchResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableVIew.rowHeight=60;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//Set tableView
//Sections
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
//Sections' rows
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 3;
    }else if(section==1) {
        return 2;
    }else {
        return 1;
    }
}
//TableViewCell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RecordCell *cell=[RecordCell recordCellWithTableView:tableView];
    //section 0
    if (indexPath.section==0) {
//        if (indexPath.row==0) {
//            cell.textLabel.text=@"荔园超市";
//            cell.detailTextLabel.text=@"2014.10.12";
//            cell.imageView.image=[UIImage imageNamed:@"174074057446.png"];
//        } else if(indexPath.row==1){
//            cell.textLabel.text=@"南区超市";
//            cell.detailTextLabel.text=@"2014.10.12";
//            cell.imageView.image=[UIImage imageNamed:@"173890450691.png"];
//        } else{
//            cell.textLabel.text=@"南区超市";
//            cell.imageView.image=[UIImage imageNamed:@"173890255948.png"];
//            cell.detailTextLabel.text=@"2014.10.12";
//        }
        
//        [cell setRecordCell:<#(Record *)#>]
        cell.location.image=[UIImage imageNamed:@"canteen.jpg"];
    //section 1
    } else if(indexPath.section==1) {
//        if (indexPath.row==0) {
//            cell.textLabel.text=@"荔园超市";
//            cell.detailTextLabel.text=@"2014.11.12";
//        } else if(indexPath.row==1){
//            cell.textLabel.text=@"南区超市";
//            cell.detailTextLabel.text=@"2014.11.12";
//        } else{
//            cell.textLabel.text=@"南区大酒店";
//            cell.detailTextLabel.text=@"2014.11.12";
//        }
        
        
        
    }
    //section2
    else {
//        if (indexPath.row==0) {
//            cell.textLabel.text=@"荔园超市";
//            cell.detailTextLabel.text=@"2014.12.12";
//        } else if(indexPath.row==1){
//            cell.textLabel.text=@"南区超市";
//            cell.detailTextLabel.text=@"2014.12.12";
//        } else{
//            cell.textLabel.text=@"南区大酒店";
//            cell.detailTextLabel.text=@"2014.12.12";
//        }
        
        
        
    }
    
    return cell;
}


//分组头标题
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return @"10月";
    } else if(section==1){
        return  @"11月";
    } else {
        return @"12月";
    }
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
