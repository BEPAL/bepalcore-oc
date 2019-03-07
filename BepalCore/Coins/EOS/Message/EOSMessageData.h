//
//  EOSMessageData.h
//  mycoin
//
//  Created by 潘孝钦 on 2018/4/8.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol EOSMessageData <NSObject>

- (NSData*)toByte;
- (void)parse:(NSData*)data;

@end
