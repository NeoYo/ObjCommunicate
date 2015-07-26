//
//  KeyboardToolbar.h
//  UI
//
//  Created by WeixiYu on 15/7/26.
//  Copyright (c) 2015年 liveabean. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KeyboardToolbar;
@protocol KeyboardDelegate <NSObject>

-(void)keyboardToolbar:(KeyboardToolbar *)toolbar itemDidSelected:(UIBarButtonItem *)item;


@end



@interface KeyboardToolbar : UIToolbar
+(instancetype)toolBar;
@property (nonatomic,weak)  id<KeyboardDelegate> kbDelegate;

@end
