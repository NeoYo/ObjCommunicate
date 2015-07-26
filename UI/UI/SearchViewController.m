//
//  SearchViewController.m
//  UI
//
//  Created by WeixiYu on 15/7/15.
//  Copyright (c) 2015年 liveabean. All rights reserved.
//

#import "SearchViewController.h"
#import "KeyboardToolbar.h"

@interface SearchViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,KeyboardDelegate>{
    NSArray *canteens;
}
@property (weak, nonatomic) IBOutlet UIPickerView *location;
@property (strong,nonatomic) UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITextField *fromDate;
@property (weak, nonatomic) IBOutlet UITextField *toDate;

-(IBAction)hideKeyboard;
@end

@implementation SearchViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    canteens=@[@"全部",@"荔山餐厅",@"实验餐厅",@"荔天餐厅",@"听荔教工餐厅",@"文山湖餐厅",@"凯风清真餐厅",@"老西南(晨风餐厅)",@"小西南餐厅",@"文科楼西北谷餐厅",@"南区饭堂"];
    
    //创建datePicker
    self.datePicker=[[UIDatePicker alloc]init];
    self.datePicker.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"zh"];
    self.datePicker.datePickerMode=UIDatePickerModeDate;
    
    //创建keyboardToolbar
    KeyboardToolbar *keyToolBar=[KeyboardToolbar toolBar];
    keyToolBar.kbDelegate=self;
    
    //fromDateField
    self.fromDate.inputView=self.datePicker;
    self.fromDate.inputAccessoryView=keyToolBar;
    
    //toDateField
    self.toDate.inputView=self.datePicker;
    self.toDate.inputAccessoryView=keyToolBar;
}


#pragma mark  UIPickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;//深大餐厅
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return canteens.count;//深大餐厅个数
}

#pragma mark UIPickerViewDelegate
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{

    return canteens[row];
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *label=(UILabel *)view;
    if (!label) {
        label = [[UILabel alloc] init];
    }
    label.text = canteens[row];
    label.font=[UIFont fontWithName:@"STHeiti-Medium.ttc" size:50];
    label.textAlignment=NSTextAlignmentCenter;
    return label;
}



#pragma mark height
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 45;
}

#pragma mark KeyboarToolbarDelegate
-(void)keyboardToolbar:(KeyboardToolbar *)toolbar itemDidSelected:(UIBarButtonItem *)item{
    [self.fromDate resignFirstResponder];
    [self.toDate becomeFirstResponder];
    
    if (self.fromDate.isFirstResponder) {
        
    }
    if (self.toDate.isFirstResponder) {
        
    }
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
