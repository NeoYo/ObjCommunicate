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

@end

@implementation RecordCell




-(void)setRecordCell:(Record *)record{
    self.date.text=record.date;
    self.time.text=record.time;
    self.money.text=record.money;
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
