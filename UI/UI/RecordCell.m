//
//  RecordCell.m
//  UI
//
//  Created by WeixiYu on 15/7/31.
//  Copyright (c) 2015年 liveabean. All rights reserved.
//

#import "RecordCell.h"



@interface RecordCell ()
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *canteen;
@property (strong,nonatomic) NSArray *canteens;
@end
//    canteens=@[@"全部",@"荔山餐厅",@"实验餐厅",@"荔天餐厅",@"听荔教工餐厅",@"文山湖餐厅",@"凯风清真餐厅",@"老西南(晨风餐厅)",@"小西南餐厅",@"文科楼西北谷餐厅",@"南区饭堂"];
@implementation RecordCell
-(NSArray *)canteens{
    if (!_canteens) {
        _canteens=@[@"荔山餐厅",@"实验餐厅",@"荔天餐厅",@"听荔教工餐厅",@"文山湖  餐厅",@"凯风清真餐厅",@"老西南  晨风餐厅",@"小西南  餐厅",@"文科楼西北谷餐厅",@"南区饭堂"];
    }
    return _canteens;
}


-(void)setRecordCell:(Record *)record{
    self.date.text=record.date;
    self.time.text=record.time;
    self.money.text=[NSString stringWithFormat:@"-%@",record.money];
    int i=[record.location intValue]-1;
    self.canteen.text=self.canteens[i];

}
+(instancetype)recordCellWithTableView:(UITableView *)tableView{
    static NSString *reuseId=@"record";
    RecordCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RecordCell" owner:nil options:nil] lastObject];
    }
    return cell;
}


@end
