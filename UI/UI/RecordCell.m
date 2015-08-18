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
@property (weak, nonatomic) IBOutlet UIImageView *location;

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
    switch ([record.location intValue]) {
        case 1:
            self.location.image=[UIImage imageNamed:@"荔山餐厅"];
            break;
        case 2 :
            self.location.image=[UIImage imageNamed:@"实验餐厅"];
            break;
        case 3:
            self.location.image=[UIImage imageNamed:@"荔天餐厅"];
            break;
        case 4:
            self.location.image=[UIImage imageNamed:@"教工餐厅"];
            break;
        case 5:
            self.location.image=[UIImage imageNamed:@"文山湖餐厅"];
            break;
        case 6:
            self.location.image=[UIImage imageNamed:@"新西南饭堂"];
            break;
        case 7:
            self.location.image=[UIImage imageNamed:@"晨风餐厅"];
            break;
        case 8:
            self.location.image=[UIImage imageNamed:@"小西南餐厅"];
            break;
        case 9:
            self.location.image=[UIImage imageNamed:@"文科楼西北谷"];
            break;
        case 10:
            self.location.image=[UIImage imageNamed:@"南区饭堂"];
            break;
        default:
            break;
    }

    

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
