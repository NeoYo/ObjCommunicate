//
//  Record.m
//  UI
//
//  Created by WeixiYu on 15/7/30.
//  Copyright (c) 2015年 liveabean. All rights reserved.
//

#import "Record.h"


@implementation Record

@dynamic date;
@dynamic location;
@dynamic money;
@dynamic time;
//-(void)setRec:(NSString *)receiveStr{
//    
////    Record *record=[NSEntityDescription insertNewObjectForEntityForName:@"Record" inManagedObjectContext:self.context];
//    
//    NSArray *receiveArr=[receiveStr componentsSeparatedByString:NSLocalizedString(@"-", nil)];
//    record.date=receiveArr[1];
//    record.time=receiveArr[2];
//    record.location=receiveArr[4];
//    
//    NSError *error=nil;
//    [self.context save:&error];
//    if (!error) {
//        NSLog(@"success");
//    }else{
//        NSLog(@"%@",error);
//    }
//    
//}
@end
