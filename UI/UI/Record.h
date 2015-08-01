//
//  Record.h
//  UI
//
//  Created by WeixiYu on 15/7/30.
//  Copyright (c) 2015年 liveabean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Record : NSManagedObject

@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * money;
@property (nonatomic, retain) NSString * time;

@end
