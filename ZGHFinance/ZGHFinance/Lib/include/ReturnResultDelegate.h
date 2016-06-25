//
//  ReturnResultDelegate.h
//  19pay_p2p_SDK_code
//
//  Created by Seth Cheng on 15/8/10.
//  Copyright (c) 2015年 19pay. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ReturnResultDelegate <NSObject>

- (void)ResultWithInfo:(NSDictionary *)Info;

@end
