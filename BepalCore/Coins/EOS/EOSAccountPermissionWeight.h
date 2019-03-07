//
//  EOSAccountPermissionWeight.h
//  mycoin
//
//  Created by 潘孝钦 on 2018/4/8.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EOSAccountPermission.h"

@interface EOSAccountPermissionWeight : NSObject

@property (strong, nonatomic) EOSAccountPermission *permission;
@property (assign, nonatomic) uint16_t weight;

- (instancetype)init:(NSString*)account :(NSString*)permission;
- (NSData*)toByte;
- (void)parse:(NSData*)data :(NSUInteger*)index;
@end
