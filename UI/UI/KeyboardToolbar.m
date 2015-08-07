//
//  KeyboardToolbar.m
//  UI
//
//  Created by WeixiYu on 15/7/26.
//  Copyright (c) 2015年 liveabean. All rights reserved.
//

#import "KeyboardToolbar.h"

@implementation KeyboardToolbar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//+(instancetype)toolBar{
//    return [[[NSBundle mainBundle]loadNibNamed:@"KeyboardToolBar" owner:nil options:nil] lastObject];
//    bundle读取错误就会有异常
//}
+(instancetype)toolBar{
    return [[[NSBundle mainBundle] loadNibNamed:@"KeyboardToolbar" owner:nil options:nil] lastObject];
}

- (IBAction)itemBtnClicked:(id)sender {
    if ([self.kbDelegate respondsToSelector:@selector(keyboardToolbar:itemDidSelected:)]) {
        [self.kbDelegate keyboardToolbar:self itemDidSelected:sender];
    }
}
@end
