//
//  RecordCell.h
//  UI
//
//  Created by WeixiYu on 15/7/31.
//  Copyright (c) 2015年 liveabean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Record.h"
@interface RecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *location;
+(instancetype)recordCellWithTableView:(UITableView *)tableView;
-(void)setRecordCell:(Record *)record;
@end
