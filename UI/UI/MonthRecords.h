//
//  MonthRecords.h
//  UI
//
//  Created by WeixiYu on 15/8/7.
//  Copyright (c) 2015年 liveabean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MonthRecords : NSObject
@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) NSArray *records;

+(instancetype)monthRecordsWithTitle:(NSString *)title;
@end
