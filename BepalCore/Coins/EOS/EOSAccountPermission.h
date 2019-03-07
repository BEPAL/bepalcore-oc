//
//  EOSAccountPermission.h
//  mycoin
//
//  Created by 潘孝钦 on 2018/4/8.
//  Copyright © 2018年 潘孝钦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EOSAccountName.h"

@interface EOSAccountPermission : NSObject

@property (strong, nonatomic) EOSAccountName *account;
@property (strong, nonatomic) EOSAccountName *permission;

- (instancetype)initWithString:(NSString*)account Permission:(NSString*)permission;
- (instancetype)initWithData:(NSData*)account Permission:(NSString*)permission;
- (NSData*)toByte;
- (void)parse:(NSData*)data :(NSUInteger*)index;
- (NSDictionary*)toJson;
@end
