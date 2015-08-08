//
//  MonthRecords.m
//  UI
//
//  Created by WeixiYu on 15/8/7.
//  Copyright (c) 2015年 liveabean. All rights reserved.
//

#import "MonthRecords.h"

@implementation MonthRecords
-(instancetype)initWithTitle:(NSString *)title{
    if (self=[super init]) {
        self.title=title;
    }
    return self;
}
+(instancetype)monthRecordsWithTitle:(NSString *)title{
    return [[self alloc]initWithTitle:title];
}

@end
