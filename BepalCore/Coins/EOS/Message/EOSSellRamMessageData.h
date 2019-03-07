//
//  EOSSellRamMessageData.h
//  BepalSdk
//
//  Created by 潘孝钦 on 2018/5/28.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EOSAccountName.h"
#import "EOSMessageData.h"

@interface EOSSellRamMessageData : NSObject<EOSMessageData>

@property (strong, nonatomic) EOSAccountName *account;
@property (assign, nonatomic) uint64_t bytes;

@end
