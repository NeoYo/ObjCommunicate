//
//  SearchViewController.m
//  UI
//
//  Created by WeixiYu on 15/7/15.
//  Copyright (c) 2015年 liveabean. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()
@property (weak, nonatomic) IBOutlet UITextField *time;
@property (weak, nonatomic) IBOutlet UITextField *location;
@property (weak, nonatomic) IBOutlet UITextField *type;
-(IBAction)hideKeyboard;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)exitToHere:(UIStoryboardSegue *)sender{
    //Execute this code upon unwinding
}
-(IBAction)hideKeyboard{
    [self.view endEditing:YES];
}
@end
