//
//  EOSWaitWeight.h
//  mycoin
//
//  Created by 潘孝钦 on 2018/5/15.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSMutableData+Extend.h"
#import "NSData+Extend.h"

@interface EOSWaitWeight : NSObject

@property (assign, nonatomic) uint32_t waitSec;
@property (assign, nonatomic) uint16_t weight;

- (NSData*)toByte;
- (void)parse:(NSData*)data :(NSUInteger*)index;

@end
